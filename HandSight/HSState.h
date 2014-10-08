//
//  HSState.h
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>

enum FeedbackType { FT_AUDIO, FT_HAPTIO, FT_HAPTIC, FT_HYBRID, FT_NONE };
enum CategoryType { CT_PLAIN, CT_MAGAZINE, CT_MENU };
enum DocumentType { DT_TRAIN, DT_A, DT_B, DT_C, DT_D, DT_E, DT_F };
enum ExpDocType { ED_1, ED_2, ED_NONE };
enum PlainDocType { PD_Train, PD_1, PD_2, PD_3, PD_NONE };
enum MagazineDocType { MD_Train, MD_1, MD_2, MD_3, MD_NONE };

enum HapticType { HT_CONSTANT, HT_PULSE };
enum AudioType { AT_CONSTANT, AT_PIANO, AT_FLUTE, AT_PULSE };

enum SpeechGender { SG_MALE, SG_FEMALE };
enum ModeType { MD_EXPLORATION_TEXT, MD_READING, MD_SIGHTED };
enum BlueToothState { BT_OFF, BT_CONNECTING, BT_ON  };
enum TouchType { TT_DOWN, TT_MOVE, TT_UP  };
enum TouchHand { TH_UNKNOWN, TH_LEFT, TH_RIGHT, TH_EXTRA  };
enum SpeedType { ST_TRAIN, ST_1, ST_2, ST_3, ST_4, ST_NONE };
enum FeedbackTrainType { FTT_TRAIN, FTT_NONE };
enum FeedbackStepByStep { Step0, StepVertical, StepVerticalText, StepLine, StepAll };



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
@property (nonatomic) enum ExpDocType expDocType;
@property (nonatomic) enum PlainDocType plainDocType;
@property (nonatomic) enum MagazineDocType magDocType;
@property (nonatomic) enum SpeedType speedType;
@property (nonatomic) enum FeedbackTrainType feedbackTrainType;
@property (nonatomic) enum FeedbackStepByStep feedbackStepByStep;


@property (nonatomic) NSString *insStartPlain, *insStartPlainExplore, *insStartMag, *insExploreMode, *insReadingMode,
                                *insStartMagExplore, *insStartSighted, *insEndPlain, *insTitle, *insParagraph, *insPicture, *insText, *insEOC;
@property (nonatomic) NSMutableArray *arrInstruction, *activeTouches;
@property (nonatomic) NSMutableDictionary *touchDict;


@property (nonatomic) BOOL taskStarted, taskEnded, lockTaskStarted, softwareStarted, audioPitch, audioVolume;
@property (nonatomic) BOOL waitLineBegin, waitLineEnd, waitParaEnd, waitTaskEnd, waitColumnEnd, sightedSpeaking, readingPitch, audioVolumeChange, hasEndColume, debugMode, showLog, showStat, thisLineHasAtLeastOneWordSpoken, speechOn, guided, automaticMode, automaticExploration;

@property (nonatomic) int currentWordID, lastWordID, nextWordID, paraID, lineID, numWords, numFinger;
@property (nonatomic) CGFloat readingSpeed, maxVibration, maxVolume, lineHeight, fieldOfView;


+ (HSState*) sharedInstance;

- (void) reset; 
- (bool) isAudioOn;
- (bool) isHapticOn;
- (bool) isHaptio;
- (bool) isExplorationTextMode;
- (bool) isReadingMode;
- (void) toggleMode; 
- (BOOL) sightedReading;
- (BOOL) isTrainingMode; 

@end

