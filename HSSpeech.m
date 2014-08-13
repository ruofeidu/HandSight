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
        m_queue                 =       [NSMutableArray array];
        State                   =       [HSState sharedInstance];
        m_pause                 =       0;
        m_lastSpoken            =       @"";

        m_timer                 =       [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(speakTimer:) userInfo:nil repeats:YES];
        
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
            
            s = [NSString stringWithFormat:@"%@ %@", s, t];
            if ([self isTooShort:s] && [m_queue empty]) {
                //NSLog(@"[SP] Words %@ too short", s);
                break;
            }
            
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
    //NSLog(@"[SP] speakText %@", s);
    m_lastSpoken = s;
    AVSpeechUtterance *utt = [AVSpeechUtterance speechUtteranceWithString:s];

    if ([self isInstruction: s]) {
        if ([State instructionGender] == SG_MALE) {
            utt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
        }
        utt.rate = 0.6;
        m_pause += 3;
    } else {
        if ([State readingGender] == SG_MALE) {
            utt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
        }
        utt.rate = 0.6;  //TODO
    }
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
