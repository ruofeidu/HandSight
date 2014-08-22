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
    [File write:[NSString stringWithFormat:@"%@.csv", [File userID]] dataArray:array];
    
    array = [NSArray arrayWithObjects:m_data, nil];
    [File write:[NSString stringWithFormat:@"%@.stat", [File userID]] dataArray:array];
}

- (void) reset: (CGFloat) startTime {
    m_startTime = startTime;
}

- (void) endTask: (CGFloat) endTime {
    m_endTime = endTime;
    [m_data appendFormat:@"Doc: %d, Cate: %d, Spent: %.4f, Words: %d, Speed: %.4f\n", State.documentType, State.categoryType, m_endTime - m_startTime,
     [State numWords], [State numWords] / (m_endTime - m_startTime) * 60];
    [self saveToFile]; 
}

@end
