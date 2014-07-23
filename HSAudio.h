//
//  HSAudio.h
//  HandSight
//
//  Created by Ruofei Du on 7/16/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "HSUtils.h"
#import "SoundManager.h"

@interface HSAudio : NSObject {
    enum AUDIO { AU_LINE_BEGIN, AU_LINE_END, AU_PARA_END, AU_SKIP_WORD };
    HSState *State;
    SoundManager *Sound;
}

+ (HSAudio*) sharedInstance;

- (double) audioFrequency;

- (AudioComponentInstance) getTone;
- (void) createToneUnit;

- (void) updateAudioFrequency: (CGFloat) y;
- (void) play;
- (void) stop;

- (void) playAudio:(enum AUDIO) audio;

@end
