//
//  HSSpeech.m
//  HandSight
//
//  Created by Ruofei Du on 7/16/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSSpeech.h"

@implementation HSSpeech

//int MAX_QUEUE_SIZE = 9;
static uint MIN_SPOKEN_LENGTH = 3;
//CGFloat delay[10] = {0.6, 0.9, 1.0, 1.5, 2.2, 2.9, 2.9, 2.9, 3.0, 3.0};


+ (HSSpeech*) sharedInstance
{
    static  HSSpeech* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self alloc] init];
    });
    return  sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        m_speechSynthesizer     =       [[AVSpeechSynthesizer alloc] init];
        m_dict                  =       [NSMutableDictionary dictionary];
        m_queue                 =       [NSMutableArray array];
        State                   =       [HSState sharedInstance];
        Log                     =       [HSLog sharedInstance];
        m_pause                 =       0;
        m_lastSpoken            =       @"";

        m_timer                 =       [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(speakTimer:) userInfo:nil repeats:YES];
        
        [m_dict setValue:@"Doctor" forKey:@"Dr."];
        [m_dict setValue:@"Leave" forKey:@"live"];
        
        NSLog(@"[SP] Inited");
    }
    
    return self;
}

- (bool) isTooShort: (NSString*) str {
    return [str length] < MIN_SPOKEN_LENGTH;
}

- (bool) isInstruction: (NSString*) str {
    if (str == nil) return NO;
    
    for (NSString* s in State.arrInstruction) {
        if ([str hasPrefix:s]) return YES;
    }
    return NO;
}

/**
 * Speech Timer occurs every 0.1 second
 *
 * 1. wait for pauses
 * 2. if speaking stop
 * 3. 
 *
 */
- (void)speakTimer: (NSTimer*) timer
{
    if (m_pause > 0) {
        --m_pause;
        return;
    }
    if ([m_speechSynthesizer isSpeaking]) return;

    if (![m_queue empty]) {
        
        NSString* s = @"";
        while (![m_queue empty]) {
            NSString* t = [m_queue peekHead];
            
            if ([self isInstruction:t]) {
                if ([s isEmpty]) {
                    s = [m_queue dequeue];
                    break;
                }
            }
            
            t = [t lowercaseString];
            if ([t isEqualToString:@"-"]) t = @"";
            if ([t isEqualToString:@"ms."]) t = @"miss";
            if ([t isEqualToString:@"dr."]) t = @"doctor";
            
            s = [NSString stringWithFormat:@"%@ %@", s, t];
            /*
            if ([self isTooShort:s] && [m_queue count] == 1) {
                //NSLog(@"[SP] Words %@ too short", s);
                return;
            }
            */
            [m_queue dequeue];
            if ([t isEnded]) break;
        }
        
        //NSLog(@"[SP] Queue head: %@, size: %d", s, [m_queue count]);
        [self speakText: s];
    }
}

- (void)stopSpeaking {
    [m_speechSynthesizer stopSpeakingAtBoundary: AVSpeechBoundaryImmediate];
    [m_queue removeAllObjects];
}

- (void)speakText: (NSString *)s {
    if (State.feedbackStepByStep != Step0 && State.feedbackStepByStep != StepAll) return;
    
    m_lastSpoken = s;
    AVSpeechUtterance *utt = [AVSpeechUtterance speechUtteranceWithString:s];

    if ([self isInstruction: s]) {
        
        AVSpeechUtterance *bugWorkaroundUtterance = [AVSpeechUtterance speechUtteranceWithString:@" "];
        bugWorkaroundUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
        bugWorkaroundUtterance.rate = AVSpeechUtteranceMaximumSpeechRate;
        [m_speechSynthesizer speakUtterance:bugWorkaroundUtterance];
        
        if ([State instructionGender] == SG_MALE) {
            utt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
        }
        
        utt.rate = 0.5;
        m_pause += 3;
    } else {
        if (!State.speechOn) return;
        if ([State readingGender] == SG_MALE) {
            utt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
        }
        utt.rate = State.readingSpeed + ([s length] * 0.08) / 10;  //larger means faster speech
        utt.volume = State.readingVolume;
    }
    
    [Log recordSpeakWord:s withSpeed:utt.rate]; 
    [m_speechSynthesizer speakUtterance:utt];
}

- (void)queueText: (NSString *)s {
    if (s == NULL || [s isEmpty]) return;
    if ([s isEqualToString:[m_queue peekTail]]) return;
    //NSLog(@"[SP] queueText: queue's head %@", [m_queue peekHead]);

    while ([self isInstruction: [m_queue peekTail]]) {
        [m_queue popTail];
    }
    [m_queue enqueue:s];
}

- (BOOL) lastWordNotMode {
    NSString* s = m_lastSpoken;
    BOOL a = !([s isEqual: State.insExploreMode] || [s isEqual: State.insReadingMode]);
    s = [m_queue peekTail];
    BOOL b = !([s isEqual: State.insExploreMode] || [s isEqual: State.insReadingMode]);
    return a && b;
}


@end
