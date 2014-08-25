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
- (void) changed;
- (void) convertMode;

/**
 * Reading Feedbacks
 */
- (void) verticalFeedback: (CGFloat) y;
- (void) verticalStop;
- (void) speekCurrentWord: (NSString*) s;

/**
 * Task Feedback
 */
- (void) taskStart;
- (void) taskEnd;

/**
 * Structure Feedback
 */
- (void) lineBegin;
- (void) lineEnd;
- (void) paraEnd;

/**
 * Exploration Feedback
 */
- (void) overTitle;
- (void) overParagraph: (int) i;
- (void) overPicture;
- (void) overSpacing;



@end
