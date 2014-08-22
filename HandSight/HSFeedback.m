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
        
        NSLog(@"[FB] Inited"); 
    }
    
    return self;
}

/**
 * by guidance, y > 0 if upwards, y < 0 if downwards
 */
- (void) verticalFeedback: (CGFloat) y {
    if (y == 0) [self verticalStop]; else [self verticalStart:y];
}

- (void) verticalStart: (CGFloat) y {
    if (y == 0) return;
    
    if ([State isAudioOn]) {
        [Audio updateAudioFrequency:y];
        [Audio play];
    }
    if ([State isHapticOn] || [State isHaptio]) {
        [Bluetooth verticalFeedback: y];
    }
    
    [Log recordVerticalFeedback:1 withVibrationDistance:y withAudioFrequency:[Audio audioFrequency]];
}

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
            if ([State sightedReading]) {
                [Speech queueText:[State insStartSighted]];
            } else
            if ([State categoryType] == CT_MAGAZINE) {
                [Speech queueText:[State insStartMag]];
            } else
            if ([State categoryType] == CT_PLAIN) {
                [Speech queueText:[State insStartPlain]];
            }
            break;
    }
    
    CGFloat delay = State.sightedReading ? 0.01 : 2.0;
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(setTaskStart:) userInfo:nil repeats:NO];
    
    [Log recordTaskBegin];
}

- (void) setTaskStart: (NSTimer*) timer {
    [self lineBegin];
    State.taskStarted = true;
}

- (void) overTitle {
    [self overText];
}

- (void) overText {
    [Audio playFlute];
}

- (void) overParagraph: (int) i {
    [self overText];
}

- (void) overPicture {
    [Audio playViolin];
    /*
    if ([State isAudioOn]) {
        [Audio playViolin];
    }
    if ([State isHapticOn]) {
        //[Bluetooth overText];
    }
     */
}

- (void) taskEnd {
    [Log recordTaskEnd];
    [Speech queueText: [State insEndPlain]];
    [Log saveToFile];
}

- (void) verticalStop {
    if ([State isAudioOn]) {
        [Audio stop];
    }
    if ([State isHapticOn] || [State isHaptio]) {
        [Bluetooth verticalStop];
    }
    [Log recordVerticalStop];
}

- (void) speak:(NSString *)s {
    
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
    
    if ([State isAudioOn]) {
        [Audio stopMusic]; 
    }
    
    
    [self stopFeedback];
    [Log recordConvertMode];
}

- (void) lineBegin {
    State.thisLineHasAtLeastOneWordSpoken = false;
    [Log recordBeginLine: State.lineID];
    
    if ([State isAudioOn] || [State isHaptio]) {
        [Audio playAudio:AU_LINE_BEGIN];
    }
    
    if ([State isHapticOn]) {
        [Bluetooth lineBegin];
    }
    
    State.waitLineBegin = false;
    State.thisLineHasAtLeastOneWordSpoken = false;
}

- (void) lineEnd {
    [Log recordEndLine: State.lineID];
    
    NSLog(@"%d, %d, %d", [State feedbackType], FT_AUDIO, [State feedbackType] == FT_AUDIO);
    
    NSLog(@"%d", [State isAudioOn]);
    
    if ([State isAudioOn] || [State isHaptio]) {
        [Audio playAudio:AU_LINE_END];
    }
    
    if ([State isHapticOn]) {
        [Bluetooth lineEnd];
    }
}

- (void) paraEnd {
    [Log recordEndParagraph: State.paraID];
    
    if ([State isAudioOn] || [State isHaptio]) {
        [Audio playAudio:AU_PARA_END];
    }
    
    if ([State isHapticOn]) {
        [Bluetooth paraEnd];
    }
}

- (void) overSpacing {
    /*
    if ([Speech lastWordNotMode]) {
        [Speech stopSpeaking];
    }
    */
    [Audio stopMusic];
    /*
    if ([State isAudioOn]) {
        [Audio stopMusic];
    }
    
    if ([State isHapticOn]) {
        [self verticalStop];
    }
     */
}

- (void)speekCurrentWord: (NSString*) s {
    if ([State sightedReading] && ![State sightedSpeaking]) return;
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
@end
