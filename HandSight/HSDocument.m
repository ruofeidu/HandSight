//
//  HSDocument.m
//  HandSight
//
//  Created by Ruofei Du on 8/1/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSDocument.h"

@implementation HSDocument

+ (HSDocument*) sharedInstance {
    static  HSDocument* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self  alloc] init];
    });
    return sharedInstance;
}

- (id) init {
    self = [super init];
    [self reset];
    
    self.lineSymImg         =           100;
    State = [HSState sharedInstance];
    
    return self;
}

- (void) reset {
    NSLog(@"Doc reset");
    if (State.categoryType == CT_PLAIN) {
        self.numCols            =           1;
    } else {
        self.numCols            =           2;
    }
        
    self.isLoaded           =           NO;
    self.numPicParas        =           6;
    self.hasTitle           =           NO;
    
    self.arrWord            =           nil; 
    self.arrWordStartIndex  =           [[NSMutableArray alloc] init];
    self.arrWordDict        =           [[NSMutableArray alloc] init];
    self.dictParaLine       =           [[NSMutableDictionary alloc] init];
}


- (void) setLoaded {
    NSLog(@"[Doc] Set loaded");
    self.isLoaded           =           YES;
    
    if (State.documentType == DT_D && State.plainDocType == CT_PLAIN)
        State.mode               =       MD_READING;
}

- (void) clear {
    NSLog(@"[Doc] Clear");
    [self.dictParaLine removeAllObjects];
    [self.arrImg removeAllObjects];
    [self.arrWordDict removeAllObjects];
    [self.arrWordStartIndex removeAllObjects]; 
    
    [State reset];
    
    self.firstColumnCharacters     =       -1;
}

- (void) setTitle {
    self.hasTitle = true;
}

- (NSUInteger) numWords {
    return [self.arrWord count];
}

- (NSUInteger) numActualWords {
    return [self.arrWordDict count];
}

/**
 * Get the word dictionary
 */
- (NSMutableDictionary*) getWordDict: (int) wordIndex {
    if (wordIndex < 0) wordIndex = 0;
    if (wordIndex >= [self.arrWordDict count]) return nil;  // modification: -1
    return [self.arrWordDict objectAtIndex:wordIndex];
}

/**
 * Get the valid word index starting from wordIndex
 */
- (int) getValidWordIndex: (int) wordIndex {
    int nextWordIndex = wordIndex - 1;          // backwards a step for the loop
    NSMutableDictionary *dictNext;
    NSString* keyNext;
    
    do {
        ++nextWordIndex;        // next step
        if (nextWordIndex >= [self.arrWordDict count] - 1) break;
        
        dictNext = [self getWordDict:nextWordIndex];
        if (dictNext != nil) {
            keyNext = [dictNext getKey];
        } else keyNext = @"";
        
    } while ([keyNext isLineBreak] || [keyNext isEmpty]);
    
    return nextWordIndex;
}


- (int) getNextWordID: (int) currentWordID {
    return [self getValidWordIndex: currentWordID + 1];
}



-(int) getColFromWordIndex: (int) wordIndex {
    NSMutableDictionary* dict = [self getWordDict: wordIndex];
    return [dict getColumn];
}

-(int) getLineFromWordIndex: (int) wordIndex {
    NSMutableDictionary* dict = [self getWordDict: wordIndex];
    return [dict getLine];
}

-(NSString*) getKeyFromWordIndex: (int) wordIndex {
    NSMutableDictionary* dict = [self getWordDict: wordIndex];
    return [dict getKey];
}

- (int) getParaFromWordIndex: (int) wordIndex {
    NSMutableDictionary* dict = [self getWordDict: wordIndex];
    return [dict getPara];
}

- (int) getTheLastWordIDInTheSameLine {
    int x1 = State.lastWordID;
    
    int x2 = x1;
    int ans = x2;
    
    while ([self inTheSameLine:x1 with:x2]) {
        ans = x2;
        x2 = [self getNextWordID: x2];
    }
    
    return ans;
}

- (BOOL) inTheSameLine: (int)x  with: (int) y {
    return [self getLineFromWordIndex:x] == [self getLineFromWordIndex:y] && [self getParaFromWordIndex:x] == [self getParaFromWordIndex:y];
}

@end
