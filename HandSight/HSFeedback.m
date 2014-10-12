//
//  HSFeedback.m
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSFeedback.h"

@implementation HSFeedback

+ (HSFeedback*) sharedInstance
{
    static  HSFeedback* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self  alloc] init];
    });
    return  sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        Audio = [HSAudio sharedInstance];
        Bluetooth = [HSBluetooth sharedInstance];
        Log = [HSLog sharedInstance];
        State = [HSState sharedInstance];
        Speech = [HSSpeech sharedInstance];
        Stat = [HSStat sharedInstance];
        
        m_verticalOn = NO;
        
        NSLog(@"[FB] Inited"); 
    }
    
    return self;
}

/**
 * The interface to provide vertical feedback to users
 */
- (void) verticalFeedback: (CGFloat) y {
    if (y == 0) [self verticalStop]; else [self verticalStart:y];
}

/**
 * The implementation of vertical feedback
 *
 * by guidance, y > 0 if upwards, y < 0 if downwards
 *
 */
- (void) verticalStart: (CGFloat) y {
    if (y == 0) return;
    
    if (!m_verticalOn) {
        m_verticalOn = YES;
        [Stat exitLine:y]; 
    }
    
    if ([State isAudioOn]) {
        [Audio updateAudioFrequency:y];
        [Audio play];
        [Audio stopMusic];
    }
    if ([State isHapticOn] || [State isHaptio]) {
        [Bluetooth verticalFeedback: y];
    }
    
    [Log recordVerticalFeedback:1 withVibrationDistance:y withAudioFrequency:[Audio audioFrequency]];
}

/**
 * Feedback for vertical stop
 */
- (void) verticalStop {
    m_verticalOn = NO;
    
    if ([State isAudioOn]) {
        [Audio stop];
        [Audio stopMusic];
    }
    if ([State isHapticOn] || [State isHaptio]) {
        [Bluetooth verticalStop];
    }
    [Log recordVerticalStop];
}

/**
 * Task start feedback, called only once in each document
 */
- (void) taskStart {
    if ([State lockTaskStarted]) return;
    State.lockTaskStarted = true;
    State.waitLineBegin = true;
    
    switch (State.mode) {
        case MD_EXPLORATION_TEXT:
            if ([State categoryType] == CT_MAGAZINE) {
                [Speech queueText:[State insStartMagExplore]];
            } else
            if ([State categoryType] == CT_PLAIN) {
                [Speech queueText:[State insStartPlainExplore]];
            }
            break;
        case MD_READING:
            if ([State categoryType] == CT_MAGAZINE) {
                [Speech queueText:[State insStartMag]];
            } else
            if ([State categoryType] == CT_PLAIN) {
                [Speech queueText:[State insStartPlain]];
            }
            break;
        case MD_SIGHTED:
            [Speech queueText:[State insStartSighted]];
            break;
    }
    
    CGFloat delay = State.mode == MD_SIGHTED ? 0.01 : 0.1;
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(setTaskStart:) userInfo:nil repeats:NO];
    
    [Log recordTaskBegin];
}

/**
 * Call task tasked; 2 seconds delay for speech "Please start to read the following text below"
 */
- (void) setTaskStart: (NSTimer*) timer {
    [self lineBegin];
    State.taskStarted = true;
}

/**
 * Feedback for over title
 */
- (void) overTitle {
    [self overText];
}

/**
 * Feedback for over text
 */
- (void) overText {
    [Audio playFlute];
    //[Bluetooth verticalFeedback: 10];
}

/**
 * Feedback for over paragraph
 */
- (void) overParagraph: (int) i {
    [self overText];
}

/**
 * Feedback for over picture
 */
- (void) overPicture {
    [Audio playViolin];
    [Bluetooth verticalStop];
}

/**
 * Feedback for task end
 */
- (void) taskEnd {
    [Log recordTaskEnd];

    CGFloat delay = State.mode == MD_SIGHTED ? 0.01 : 0.5;
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(setTaskEnd:) userInfo:nil repeats:NO];
}

- (void) setTaskEnd: (NSTimer*) timer {
    [Speech speakText: [State insEndPlain]];
    //[Speech speakText: [State insEndPlain]];

    [Log saveToFile];
}

- (void) stopFeedback {
    [self verticalStop];
    [Speech stopSpeaking]; 
}

- (void) convertMode {
    [State toggleMode];
    
    [self stopFeedback];
    
    if ([State isExplorationTextMode]) {
        [Speech queueText: [State insExploreMode]];
    } else {
        [Speech queueText: [State insReadingMode]];
    }
    
    if ([State isAudioOn] || [State isHaptio]) {
        [Audio stopMusic]; 
    }
    
    [Log recordConvertMode];
}

- (void) lineBegin {
    if (State.automaticMode) [self overSpacing];
    
    if (State.feedbackStepByStep == StepVertical || State.feedbackStepByStep == StepVerticalText) return;
        
    State.thisLineHasAtLeastOneWordSpoken = false;
    [Log recordBeginLine: State.lineID];
    
    if ([State isAudioOn] || [State isHaptio]) {
        [Audio playAudio:AU_LINE_BEGIN];
    }
    
    State.automaticExploration = NO; 
    
    if ([State isHapticOn]) {
        [Bluetooth lineBegin];
    }
    
    State.waitLineBegin = false;
    State.thisLineHasAtLeastOneWordSpoken = false;
}

- (void) lineEnd {
    [Log recordEndLine: State.lineID];
    
    if (State.feedbackStepByStep == StepVertical || State.feedbackStepByStep == StepVerticalText) return;
    
    NSLog(@"%d, %d, %d", [State feedbackType], FT_AUDIO, [State feedbackType] == FT_AUDIO);
    
    NSLog(@"%d", [State isAudioOn]);
    
    if (State.automaticMode) {
        State.automaticExploration = YES;
    }
    
    if ([State isAudioOn] || [State isHaptio]) {
        [Audio playAudio:AU_LINE_END];
    }
    
    if ([State isHapticOn]) {
        [Bluetooth lineEnd];
    }
}


- (void) lineBeginOnly {
    [Audio playAudio:AU_LINE_BEGIN];
}

- (void) lineEndOnly {
    [Audio playAudio:AU_LINE_END];
}

- (void) paraEndOnly {
    [Audio playAudio:AU_PARA_END];
}

- (void) paraEnd {
    [Log recordEndParagraph: State.paraID];
    if (State.feedbackStepByStep == StepVertical || State.feedbackStepByStep == StepVerticalText) return;
    
    if ([State isAudioOn] || [State isHaptio]) {
        [Audio playAudio:AU_PARA_END];
    }
    
    if ([State isHapticOn]) {
        [Bluetooth paraEnd];
    }
}

- (void) overSpacing {
    [Audio stopMusic];
    [Bluetooth verticalStop];
}

- (void)speekCurrentWord: (NSString*) s {
    if (State.mode == MD_SIGHTED && ![State sightedSpeaking]) return;
    [Speech queueText: s]; 
}

- (void)changed {
    if (State.feedbackType == FT_HAPTIC || State.feedbackType == FT_HYBRID || [State isHaptio]) {
        [Bluetooth turnOnBluetooth];
    } else {
        [Bluetooth turnOffBluetooth];
    }
    [Log recordFeedbackTypeChanged];
}


- (void) handsightPanel {
    //[Speech speakText: State.insHandSightPanel];
}

- (void) handsightText {
    //[Speech speakText: State.insHandSightText];
}

@end
