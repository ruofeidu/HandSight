//
//  HSDocument.h
//  HandSight
//
//  Created by Ruofei Du on 8/1/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSState.h"
#import "NSMutableArray+QueueAdditions.h"
#import "HSString.h"
#import "HSDictionary.h"

@interface HSDocument : NSObject {
@protected
    
    HSState                 *State;
}

@property (nonatomic) BOOL hasTitle, isLoaded;
@property (nonatomic) int numCols, numImages, numPara, numPicParas, lineSymImg, firstColumnCharacters, textEndID;
@property (nonatomic) NSMutableDictionary *dictParaLine;
@property (nonatomic) NSMutableArray *arrImg, *arrWord, *arrWordStartIndex, *arrWordDict, *lineWidth, *lineCenterY;

+ (HSDocument*) sharedInstance;
- (void) reset;
- (void) clear;
- (void) setLoaded;
- (void) setTitle;


- (NSUInteger) numWords;
- (NSUInteger) numActualWords;

- (NSMutableDictionary*) getWordDict: (int) wordIndex;
- (int) getValidWordIndex: (int) wordIndex;
- (int) getNextWordID: (int) currentWordID;

- (int) getColFromWordIndex: (int) wordIndex;
- (int) getParaFromWordIndex: (int) wordIndex;
- (int) getLineFromWordIndex: (int) wordIndex;
- (NSString*) getKeyFromWordIndex: (int) wordIndex;
- (int) getTheLastWordIDInTheSameLine;
- (BOOL) inTheSameLine: (int)x  with: (int) y;

    
@end
