//
//  HSFeedback.h
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSUtils.h"
#import "HSAudio.h"
#import "HSBluetooth.h"
#import "HSSpeech.h"

@interface HSFeedback : NSObject {
    HSState* State;
    HSAudio* Audio;
    HSBluetooth* Bluetooth;
    HSLog* Log;
    HSSpeech* Speech;
}

+ (HSFeedback *) sharedInstance;

- (void) verticalFeedback: (CGFloat) y;
- (void) verticalStart: (CGFloat) y;
- (void) verticalStop;

- (void) changed; 

- (void) lineBegin;
- (void) lineEnd;
- (void) paraEnd;

- (void) taskStart;
- (void) taskEnd;

- (void) overTitle;
- (void) overText;
- (void) overParagraph: (int) i;
- (void) overPicture;

- (void) speak: (NSString*) s;
- (void) overSpacing;

- (void) convertMode;
- (void) speekCurrentWord: (NSString*) s;

@end
