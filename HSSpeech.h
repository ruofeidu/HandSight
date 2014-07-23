//
//  HSSpeech.h
//  HandSight
//
//  Created by Ruofei Du on 7/16/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "HSUtils.h"

@interface HSSpeech : NSObject <AVSpeechSynthesizerDelegate> {
    HSState* State;
    

    AVSpeechSynthesizer *m_speechSynthesizer;
    NSMutableArray *m_queue;
}

+ (HSSpeech*) sharedInstance;
- (void)speakText:(NSString *)toBeSpoken;




@end
