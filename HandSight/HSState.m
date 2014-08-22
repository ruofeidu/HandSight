//
//  HSState.m
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSState.h"

@implementation HSState

+ (HSState*) sharedInstance
{
    static  HSState* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self  alloc] init];
    });
    return  sharedInstance;
}

-(void) reset
{
    NSLog(@"[ST] State Reset");
    self.taskStarted        =       false;
    self.taskEnded          =       false;
    self.waitLineBegin      =       false;
    self.waitLineEnd        =       false;
    self.waitParaEnd        =       false;
    self.waitTaskEnd        =       false;
    self.waitColumnEnd      =       false;
    self.softwareStarted    =       false;
    
    self.hasEndColume       =       false; 
    self.currentWordID      =       -1;
    self.lastWordID         =       -1;
    self.nextWordID         =       0;
    self.paraID             =       0;
    self.lineID             =       0; 
    
    
    self.lockTaskStarted    =       NO;
}

- (id) init
{
    self = [super init];
    
    if (self) {
        self.mode                   =       MD_READING; //MD_EXPLORATION;
        self.bluetoothState         =       BT_OFF;
        
        self.debugMode              =       NO;
        self.audioMiddleValue       =       400.0f;
        self.audioStartThres        =       100.0f;
        self.audioIncValue          =       100.0f;
        self.maxFeedbackValue       =       127.0f;
        self.maxVibration           =       127.0f;
        self.maxVolume              =       75.0f;
        self.lineHeight             =       16.0f;
        self.minFeedbackValue       =       -127.0f;
        
        self.fieldOfView            =       4;
        
        self.audioLinear            =       NO;
        self.audioPitch             =       YES;
        self.audioVolume            =       NO;
        self.sightedReading         =       NO;
        self.sightedSpeaking        =       YES; 
        
        self.touchType              =       TT_UP; 
        self.feedbackType           =       FT_AUDIO;
        self.categoryType           =       CT_PLAIN; // CT_MAGAZINE;
        self.documentType           =       DT_TRAIN;
        self.instructionGender      =       SG_MALE;
        self.readingGender          =       SG_FEMALE;
        
        self.insStartSighted        =       @"Start!";
        self.insStartPlain          =       @"Please start reading the following text.";
        self.insStartPlainExplore   =       @"Please start to explore the following text.";
        self.insStartMag            =       @"Please start reading the following magazine article.";
        self.insStartMagExplore     =       @"Please start to explore the following magazine article.";
        self.insEndPlain            =       @"End of Text.";
        self.insEOC                 =       @"End of the first column.";
        self.insParagraph           =       @"Paragraph ";
        self.insPicture             =       @"Picture";
        self.insText                =       @"Text";
        self.insTitle               =       @"Title";
        self.arrInstruction         =       [[NSMutableArray alloc] init];
        
        self.insReadingMode         =       @"Reading Mode";
        self.insExploreMode         =       @"Exploration Mode";
        
        [self.arrInstruction addObject:self.insStartMag];
        [self.arrInstruction addObject:self.insStartSighted];
        [self.arrInstruction addObject:self.insStartMagExplore];
        [self.arrInstruction addObject:self.insStartPlain];
        [self.arrInstruction addObject:self.insStartPlainExplore];
        [self.arrInstruction addObject:self.insEndPlain];
        [self.arrInstruction addObject:self.insParagraph];
        [self.arrInstruction addObject:self.insEOC];
        [self.arrInstruction addObject:self.insText];
        [self.arrInstruction addObject:self.insTitle];
        [self.arrInstruction addObject:self.insPicture];
        [self.arrInstruction addObject:self.insExploreMode];
        [self.arrInstruction addObject:self.insReadingMode];
        
        NSLog(@"[ST] Inited");
    }
    
    return self;
}

- (int) numLinesInPara: (int) i {
    return 0; 
}

- (bool) isMode {
    return self.mode;
}

- (bool) isDetailMode {
    return !self.mode;
}

- (bool) isAudioOn {
    return ([self feedbackType] == FT_AUDIO) || ([self feedbackType] == FT_HYBRID);
}

- (bool) isHapticOn {
    return (([self feedbackType] == FT_HAPTIC) || ([self feedbackType] == FT_HYBRID)) && [self bluetoothState] == BT_ON;

}

- (bool) isExplorationTextMode {
    return self.mode == MD_EXPLORATION_TEXT;
}

- (bool) isReadingMode {
    return self.mode == MD_READING;
}

- (void) toggleMode {
    if ([self isExplorationTextMode]) {
        self.mode = MD_READING;
    } else {
        self.mode = MD_EXPLORATION_TEXT;
    }
}

- (bool) isHaptio {
    return self.feedbackType == FT_HAPTIO;
}

@end
