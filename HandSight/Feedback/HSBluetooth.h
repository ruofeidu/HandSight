//
//  HSBluetooth.h
//  HandSight
//
//  The bluetooth module supports on / off of bluetooth LTE using redbear bluetooth module
//  Redbear Bluetoothshield: http://redbearlab.com/bleshield/
//  Some code is edited from the SDK for their BLE device: https://github.com/RedBearLab
//
//  Created by Ruofei Du on 7/16/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLE.h"
#import "HSState.h"

#define BT_LINE_END 8
#define BT_LINE_BEGIN 9
#define BT_PARA_END 10
#define BT_FEEDBACK 1
#define BT_STOP 0
#define BT_EXPLORATION_VALUE 50
#define BT_PAUSE -1

@interface HSBluetooth : NSObject <BLEDelegate> {
    NSTimer                 *m_timer;
    NSInteger               m_command, m_y;
    
    HSState* State;
}

+ (HSBluetooth*) sharedInstance;

- (void) turnOnBluetooth;
- (void) turnOffBluetooth;

- (void) connectionTimer:(NSTimer *)timer;
- (void) bleDidConnect;
- (void) bleDidDisconnect;

- (void) bleDidUpdateRSSI:(NSNumber *) rssi;
- (void) bleDidReceiveData:(unsigned char *)data length:(int)length;
- (void) readRSSITimer:(NSTimer *)timer;

- (void) lineEnd;
- (void) paraEnd;
- (void) lineBegin;
- (void) overText;
- (void) overSpacing; 
- (void) verticalFeedback: (CGFloat) value;
- (void) verticalStop;

@property (strong, nonatomic) BLE *ble;

@end
