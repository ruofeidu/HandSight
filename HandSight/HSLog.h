//
//  HSLog.h
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSFile.h"
#import "HSState.h"
#import "HSStat.h"

@interface HSLog : NSObject {
    enum RECORD {

    SOFTWARE_STARTED, DOCUMENT_LOADED, AUDIO_ON, AUDIO_OFF, VIBRATION_ON, VIBRATION_OFF,
    TOUCH_DOWN, TOUCH_UP, TOUCH_MOVE, BEGIN_LINE, END_LINE,
    END_PARAGRAPH, VERTICAL_FEEDBACK, SPEAK_WORD, RECORD_RESET, RECORD_REVERSE,
    TASK_ENDED, TASK_BEGIN,
    
    OVERVIEW_ON, OVERVIEW_OFF,
    FEEDBACK_TYPE,
    CONVERT_MODE, VERTICAL_STOP, OVER_TEXT,
        
    TRAINING, CONTROL_PANEL,
        
        TRAIN_STEP_CHANGE,

    };
    
    NSMutableString* m_data;
    NSMutableString* m_json;
    NSMutableString* m_txt;

    NSString* m_instruction; 
    
    CGFloat m_startTime;
    CGFloat m_time; 
    int m_numOfLogs;
    
    HSFile* File;
    HSState* State;
    HSStat* Stat;
}


+ (HSLog*) sharedInstance;
- (NSString*) dumpJson;
- (void) recordSoftwareStart;
- (void) recordTaskEnd;
- (void) recordTaskBegin;
- (void) recordTrain;
- (void) recordTrainStepChange: (int)stepID; 
- (void) recordControlPanel;
- (void) recordReset;
- (void) recordReverse;
- (void) recordDocumentLoaded;
- (void) recordFeedbackTypeChanged;
- (void) recordTouchDown: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText;
- (void) recordTouchUp: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText;
- (void) recordTouchMove: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText;
- (void) recordBeginLine: (int)lineID;
- (void) recordConvertMode;

- (void) recordEndLine: (int)lineID;
- (void) recordEndParagraph: (int)paraID;
- (void) recordSpeakWord: (NSString*)word withSpeed: (float)speed;
- (void) recordVerticalFeedback: (int)vibrationCommand withVibrationDistance: (float)power withAudioFrequency:(float)freq;
- (void) recordVerticalStop;
- (void) saveToFile;

@end
