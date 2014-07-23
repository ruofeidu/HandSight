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
        m_speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
        m_queue = [NSMutableArray array];
        State = [HSState sharedInstance];
        NSLog(@"[SP] Inited");
    }
    
    return self;
}

- (bool) isTooShort: (NSString*) str {
    return [str length] < MIN_SPOKEN_LENGTH;
}

- (bool) isInstruction: (NSString*) str {
    return [str isEqualToString:[State insStartPlain]] || [str isEqualToString: [State insEndPlain]];
}

- (void)speakTimer: (NSTimer*) timer
{
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
            } else {
                break;
            }
            
            s = [NSString stringWithFormat:@"%@ %@", s, t];
            if ([self isTooShort:s] && [m_queue empty]) {
                NSLog(@"[SP] Words %@ too short", s);
                break;
            }
            
            [m_queue dequeue];
            if ([t isEnded]) break;
        }
        
        [self speakText:s];
    }
}

- (void)speakText: (NSString *)s {
    AVSpeechUtterance *utt = [AVSpeechUtterance speechUtteranceWithString:s];

    if ([self isInstruction: s]) {
        if ([State instructionGender] == SG_MALE) {
            utt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
        }
        utt.rate = 0.6;
    } else {
        if ([State readingGender] == SG_MALE) {
            utt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
        }
        utt.rate = 1.0;  //TODO
    }
    [m_speechSynthesizer speakUtterance:utt];
}

- (void)queueText: (NSString *)s {
    [m_queue enqueue:s];
}

@end
