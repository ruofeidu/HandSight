//
//  HSStat.h
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSFile.h"
#import "HSState.h"

@interface HSStat : NSObject {
    NSMutableString* m_data;
    NSMutableString* m_csv;
    NSMutableString* m_txt;
    
    int m_numOfStat;
    
    CGFloat m_startTime, m_endTime;
    
    HSFile* File;
    HSState* State;
}


+ (HSStat*) sharedInstance;
- (void) reset: (CGFloat) startTime;
- (void) endTask: (CGFloat) endTime;
- (NSString*) dumpCSV;

@end
