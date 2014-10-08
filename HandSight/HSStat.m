//
//  HSStat.m
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSStat.h"

@implementation HSStat

+(HSStat*) sharedInstance
{
    static  HSStat* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self  alloc] init];
    });
    return  sharedInstance;
}

-(id)init
{
    self = [super init];
    
    if (self) {
        m_numOfStat = 0;
        m_data = [NSMutableString stringWithString:@""];
        m_csv = [NSMutableString stringWithString:@""];
        m_txt = [NSMutableString stringWithString:@""];
        
        File = [HSFile sharedInstance];
        State = [HSState sharedInstance];
        Doc = [HSDocument sharedInstance];
        
        aad = [[HSMeasure alloc] init];
        aadx = [[HSMeasure alloc] init];
        mda = [[HSMeasure alloc] init];
        mdb = [[HSMeasure alloc] init];
        nea = [[HSMeasure alloc] init];
        neb = [[HSMeasure alloc] init];
        nrh = [[HSMeasure alloc] init];
        nrv = [[HSMeasure alloc] init];
        nrhol = [[HSMeasure alloc] init];
        nrvol = [[HSMeasure alloc] init];
        tn = [[HSMeasure alloc] init];
        ntl = [[HSMeasure alloc] init];
        sk = [[HSMeasure alloc] init];
        TO1 = [[HSMeasure alloc] init];
        TO2 = [[HSMeasure alloc] init];

        NSLog(@"[LG] Inited");
    }
    return self;
}

- (NSString*) dumpCSV {
    return m_data;
}

- (void) saveToFile {
    NSArray *array = [NSArray arrayWithObjects:m_csv, nil];
    [File write:[NSString stringWithFormat:@"%@_Stat.csv", [File userID]] dataArray:array];
    
    array = [NSArray arrayWithObjects:m_data, nil];
    [File write:[NSString stringWithFormat:@"%@_StatData.txt", [File userID]] dataArray:array];
    
    array = [NSArray arrayWithObjects:m_data, nil];
    [File write:[NSString stringWithFormat:@"%@_StatReadme.txt", [File userID]] dataArray:array];
}

- (void) reset: (CGFloat) startTime {
    m_startTime = startTime;
}

- (void) endTask: (CGFloat) endTime {
    m_endTime = endTime;
    [m_data appendFormat:@"[Summary] Doc: %d, Cate: %d, Spent: %.4f, Words: %d, Speed: %.4f\n", State.documentType, State.categoryType, m_endTime - m_startTime,
     [State numWords], [State numWords] / (m_endTime - m_startTime) * 60];
    [self saveToFile]; 
}

- (void) lineBegin: (CGFloat) time {
    m_lineStartTime = time;
    [TO1 end:time];
    [TO2 end:time];
}

- (void) lineEnd: (CGFloat) time {
    m_lineEndTime = time; 
    [T add: m_lineEndTime - m_lineStartTime];
    [TO1 end:time];
    [TO2 end:time];
}

- (void) exitLine: (CGFloat) y {
    
}

- (void) distance: (CGFloat) x withY: (CGFloat) y; {
    //NSLog(@"%d", [aad count]);
    
    float lastX = [aad last];
    
    // absolute distance
    [aad add: fabs(y)];
    //NSLog(@"count %d", [aad count]);
    if (y > 0) [mda add: y]; else [mdb add: -y];
    
    // # of exits
    
    float height = 21.0 / 2;
    float feedbackThres = 27.0 / 2;
    
    if ( y > feedbackThres ) {
        [nea flip];
    } else {
        [nea flop]; 
    }
    
    if ( y < -feedbackThres ) {
        [neb flip];
    } else {
        [neb flop];
    }
    
    if (fabs(y) > feedbackThres) {
        [TO1 start:CACurrentMediaTime()];
    } else {
        [TO1 end:CACurrentMediaTime()];
        
        if (fabs(y) > height) {
            [TO2 start: CACurrentMediaTime()];
        } else {
            [TO2 end: CACurrentMediaTime()];
        }
    }
    
    // # of vertical reverses
    /*
    if ([nrh last] != -1) {
        [nrh ]
    } else {
        int sign = ([nrh last])
    }
    */
}

- (void) skipWord: (int) numWords {
    [sk add: 1.0]; 
    [m_data appendFormat:@"[Word Skip] NumWords: %d\n", numWords];
}

- (void) reverseHorizontalDirection: (BOOL) offLine {
    
}

- (void) reverseVerticalDirection: (BOOL) offLine {
    
}

- (float) getTN {
    return CACurrentMediaTime() - m_lineStartTime;
}

- (NSString*) dumpRealtime {
    return @"";
    
    //return [NSString stringWithFormat:@" [AAD]%.2f [MDA]%.2f [MDB]%.2f [NEA]%.0f [NEB]%.0f [T]%.3f [TO1]%.3f [TO2]%.3f [TN]%.2f [SK]%.2f", [aad avg], [mda max], [mdb max], [nea sum], [neb sum], CACurrentMediaTime() - m_lineStartTime, [TO1 timeCount], [TO2 timeCount], [self getTN], [sk sum]];
    
    //return [NSString stringWithFormat:@" [AAD]%.2f [MDA]%.2f [MDB]%.2f [NEA]%.0f [NEB]%.0f [NRH]%.0f [NRV]%.0f [NRHOL]%.2f [NRVOL]%.2f [T]%.2f [TO1]%.2f [TO2]%.2f [TN]%.2f [NTL]%.2f [SK]%.2f", [aad avg], [mda max], [mdb max], [nea sum], [neb sum], [nrh avg], [nrv avg], [nrhol avg], [nrvol avg], CACurrentMediaTime() - m_lineStartTime, [TO1 timeCount], [TO2 timeCount], [self getTN], [ntl avg], [sk sum]];
}

@end
