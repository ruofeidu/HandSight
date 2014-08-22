//
//  HSBluetooth.m
//  HandSight
//
//  Created by Ruofei Du on 7/16/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSBluetooth.h"

@implementation HSBluetooth

@synthesize ble;

+ (HSBluetooth*) sharedInstance
{
    static  HSBluetooth* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self  alloc] init];
    });
    return  sharedInstance;
}

- (void)sendTimer: (NSTimer*) timer
{
    if (m_command == BT_FEEDBACK) {
        [self write: BT_FEEDBACK withY:m_y];
    } else
    if (m_command == BT_STOP) {
        [self write: BT_STOP];
    }
        
}

- (id)init
{
    self = [super init];
    
    if (self) {
        ble                     =       [[BLE alloc] init];
        [ble controlSetup];
        
        ble.delegate            =       self;
        m_command               =       BT_PAUSE;
        State                   =       [HSState sharedInstance];
        
        m_timer                 =       [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sendTimer:) userInfo:nil repeats:YES];
        
        NSLog(@"[BT] Inited");
    }
    
    return self;
}

- (void) turnOnBluetooth {
    if (State.bluetoothState == BT_ON) return;
    
    State.bluetoothState = BT_CONNECTING;
    
    [ble findBLEPeripherals:2];
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

- (void) turnOffBluetooth {
    if (ble.activePeripheral)
    {
        if (ble.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            State.bluetoothState = BT_OFF;
            return;
        }
    }
    
    if (ble.peripherals)
    {
        ble.peripherals = nil;
        
    }
}

-(void) connectionTimer:(NSTimer *)timer
{
    //[m_swcBluetooth setEnabled: true];
    if (ble.peripherals.count > 0)
    {
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
        State.bluetoothState = BT_ON;
    }
    else
    {
        State.bluetoothState = BT_OFF;
    }
}

#pragma mark - BLE delegate

NSTimer *rssiTimer;

- (void)bleDidDisconnect
{
    NSLog(@"[BT] Disconnected");
    State.bluetoothState = BT_OFF;
    [rssiTimer invalidate];
}

// When RSSI is changed, this will be called
-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
}

-(void) readRSSITimer:(NSTimer *)timer
{
    [ble readRSSI];
}

// When disconnected, this will be called
-(void) bleDidConnect
{
    NSLog(@"[BT] Connected");
    
    // send reset
    UInt8 buf[] = {0x09, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [ble write:data];
    
    // Schedule to read RSSI every 1 sec.
    rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
}

// When data is comming, this will be called
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    for (int i = 0; i < length; i += 3)
    {
        NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
    }
}

- (void) lineEnd {
    m_command = BT_LINE_END;
    [self write: BT_LINE_END];
}

- (void) paraEnd {
    m_command = BT_PARA_END;
    [self write: BT_PARA_END];
}

- (void) lineBegin {
    m_command = BT_LINE_BEGIN;
    [self write: BT_LINE_BEGIN];
}

- (void) overText {
    return [self verticalFeedback: BT_EXPLORATION_VALUE];
}

- (void) overSpacing {
    return [self verticalStop];
}

- (void) verticalFeedback: (CGFloat) value {
    m_y = value;
    if (m_command != BT_FEEDBACK) {
        [self write: BT_FEEDBACK withY:value];
    }
    m_command = BT_FEEDBACK;
}

- (void) verticalStop {
    if (m_command != BT_STOP) {
        [self write: BT_STOP];
    }
    m_command = BT_STOP;
}


- (void) write: (NSInteger)command {
    SInt8 buf[4] = {command, 0, 0, '\n'};
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];
}

- (void) write: (NSInteger)command withY: (NSInteger) y {
    SInt8 buf[4] = {command, 0, y, '\n'};
    NSData *data = [[NSData alloc] initWithBytes:buf length:4];
    [ble write:data];
}

@end
