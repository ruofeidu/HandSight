//
//  HSStat.h
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSFile.h"
#import "HSSummary.h"
#import "HSMeasure.h"
#import "HSState.h"
#import "HSDocument.h"

@interface HSStat : NSObject {
    NSMutableString* m_data;
    NSMutableString* m_csv;
    NSMutableString* m_txt;
    
    int m_count; 
    int m_numOfStat;
    
    CGFloat m_startTime, m_endTime;
    
    CGFloat m_lineStartTime, m_lineEndTime;
    
    //Overall time between start and end of line
    HSMeasure *T;
    
    //Overall off-line time providing feedbacks between beginning and end of the line
    HSMeasure *TO1;
    
    //Overall off-line time totally lost between beginning and end of the line
    HSMeasure *TO2;
    
    //Average absolute distance from line center
    HSMeasure *aad;
    HSMeasure *aadx;
    
    //Maximum distance reached above line center
    HSMeasure *mda;
    
    //Maximum distance reached below line center
    HSMeasure *mdb;
    
    //Number of exits above the line of text
    HSMeasure *nea;
    
    //Number of exits below the line of text
    HSMeasure *neb;
    
    //Number of times the finger reversed horizontal direction
    HSMeasure *nrh;
    
    //Number of times the finger reversed vertical direction
    HSMeasure *nrv;
    
    //Number of times the finger reversed horizontal direction when Offline
    HSMeasure *nrhol;
    
    //Number of times the finger reversed vertical direction When Off-line
    HSMeasure *nrvol;
    
    //Overall time between end of line to beginning of next line
    HSMeasure *tn;
    
    //Number of times finger was lifted off the screen between start and end of the line
    HSMeasure *ntl;
    
    //Number of Skipped Words
    HSMeasure *sk;
    
    HSFile* File;
    HSState* State;
    HSDocument* Doc; 
}


+ (HSStat*) sharedInstance;
- (void) reset: (CGFloat) startTime;
- (void) endTask: (CGFloat) endTime;
- (NSString*) dumpCSV;
- (NSString*) dumpRealtime; 

- (void) lineBegin: (CGFloat) time;
- (void) lineEnd: (CGFloat) time;

- (void) exitLine: (CGFloat) y;
- (void) distance: (CGFloat) x withY: (CGFloat) y;
- (void) skipWord: (int) numWords;
- (void) reverseHorizontalDirection: (BOOL) offLine;
- (void) reverseVerticalDirection: (BOOL) offLine;



@end
