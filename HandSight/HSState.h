//
//  HSState.h
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>

enum FeedbackType { FT_AUDIO, FT_HAPTIC, FT_HYBRID, FT_HAPTIO, FT_NONE };
enum CategoryType { CT_PLAIN, CT_MAGAZINE, CT_MENU };
enum DocumentType { DT_TRAIN, DT_A, DT_B, DT_C, DT_D };
enum HapticType { HT_CONSTANT, HT_PULSE };
enum AudioType { AT_CONSTANT, AT_PIANO, AT_FLUTE, AT_PULSE };

enum SpeechGender { SG_MALE, SG_FEMALE };
enum ModeType { MD_EXPLORATION_TEXT, MD_READING };
enum BlueToothState { BT_OFF, BT_CONNECTING, BT_ON  };
enum TouchType { TT_DOWN, TT_MOVE, TT_UP  };


@interface HSState : NSObject {

}

@property (nonatomic) CGFloat audioMiddleValue, audioStartThres, audioIncValue, maxFeedbackValue, minFeedbackValue;
@property (nonatomic) BOOL audioLinear;

@property (nonatomic) enum FeedbackType feedbackType;

@property (nonatomic) enum CategoryType categoryType;
@property (nonatomic) enum DocumentType documentType;
@property (nonatomic) enum SpeechGender instructionGender;
@property (nonatomic) enum SpeechGender readingGender;
@property (nonatomic) enum BlueToothState bluetoothState;
@property (nonatomic) enum HapticType hapticType;
@property (nonatomic) enum AudioType audioType;
@property (nonatomic) enum ModeType mode;
@property (nonatomic) enum TouchType touchType;


@property (nonatomic) NSString *insStartPlain, *insStartPlainExplore, *insStartMag, *insExploreMode, *insReadingMode,
                                *insStartMagExplore, *insStartSighted, *insEndPlain, *insTitle, *insParagraph, *insPicture, *insText, *insEOC;
@property (nonatomic) NSMutableArray *arrInstruction;

@property (nonatomic) BOOL taskStarted, taskEnded, lockTaskStarted, softwareStarted, audioPitch, audioVolume;
@property (nonatomic) BOOL waitLineBegin, waitLineEnd, waitParaEnd, waitTaskEnd, waitColumnEnd, sightedReading, sightedSpeaking, readingPitch, audioVolumeChange, hasEndColume, debugMode, thisLineHasAtLeastOneWordSpoken;

@property (nonatomic) int currentWordID, lastWordID, nextWordID, paraID, lineID, numWords;
@property (nonatomic) CGFloat readingSpeed, maxVibration, maxVolume, lineHeight, fieldOfView;


+ (HSState*) sharedInstance;

- (void) reset; 
- (bool) isAudioOn;
- (bool) isHapticOn;
- (bool) isHaptio;
- (bool) isExplorationTextMode;
- (bool) isReadingMode;
- (void) toggleMode; 

@end

