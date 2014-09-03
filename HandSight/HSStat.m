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
}

- (void) lineEnd: (CGFloat) time {
    m_lineEndTime = time; 
    [T add: m_lineEndTime - m_lineStartTime];
}

- (void) exitLine: (CGFloat) y {
    
}

- (void) distance: (CGFloat) y {
    
}

- (void) skipWord: (int) numWords {
    [m_data appendFormat:@"[Word Skip] NumWords: %d\n", numWords];
    

}

- (void) reverseHorizontalDirection: (BOOL) offLine {
    
}

- (void) reverseVerticalDirection: (BOOL) offLine {
    
}

- (NSString*) dumpRealtime {
    return [NSString stringWithFormat:@" [AAD]%.2f [MDA]%.2f [MDB]%.2f [NEA]%.2f [NEB]%.2f [NRH]%.2f [NRV]%.2f [NRHOL]%.2f [NRVOL]%.2f [T]%.2f [TO1]%.2f [TO2]%.2f [TN]%.2f [NTL]%.2f [SK]%.2f", [aad avg], [mda max], [mdb max], [nea avg], [neb avg], [nrh avg], [nrv avg], [nrhol avg], [nrvol avg], [T avg], [TO1 avg], [TO2 avg], [tn avg], [ntl avg], [sk avg]];
}



@end
