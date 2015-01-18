//
//  HSSpeech.h
//  HandSight
//
//  The text-to-speech module support reading text on the go via iOS Speech SDK
//  The main idea is to implement a queue and a timer to read aloud the queued text using different speed regarding the length of cached words in the queue.
//
//  Created by Ruofei Du on 7/16/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "HSUtils.h"

@interface HSSpeech : NSObject <AVSpeechSynthesizerDelegate> {

@protected

    HSState                 *State;
    HSLog                   *Log;
    
@private
    int                     m_pause;
    AVSpeechSynthesizer     *m_speechSynthesizer;
    NSMutableArray          *m_queue;
    NSMutableDictionary     *m_dict; 
    NSTimer                 *m_timer;
    NSString                *m_lastSpoken;
    
}

+ (HSSpeech*) sharedInstance;

- (void)speakText:(NSString *)toBeSpoken;
- (void)speakTimer: (NSTimer*) timer;

- (void)queueText: (NSString *)s;
- (void)stopSpeaking; 

- (BOOL) lastWordNotMode;
@end
