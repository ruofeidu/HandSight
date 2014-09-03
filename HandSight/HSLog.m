//
//  HSLog.m
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSLog.h"

@implementation HSLog

-(id)init
{
    self = [super init];
    
    if (self) {
        m_numOfLogs = 0;
        m_data = [NSMutableString stringWithString:@""];
        m_json = [NSMutableString stringWithString:@""];
        m_txt = [NSMutableString stringWithString:@""];
        
        File = [HSFile sharedInstance];
        State = [HSState sharedInstance];
        Stat = [HSStat sharedInstance];
         
        NSLog(@"[LG] Inited");
    }
    return self;
}

+(HSLog*) sharedInstance
{
    static  HSLog* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self  alloc] init];
    });
    return  sharedInstance;
}

-(void) log: (NSString*) str {
    [m_data appendFormat:@"%@\n", str];
}

-(void) recordSoftwareStart {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\n", SOFTWARE_STARTED, CACurrentMediaTime()];
    [m_json appendFormat:@"\"Software-started\": {\n\t\"T\": %.3f\n}\n\n", CACurrentMediaTime()];
    [m_txt appendFormat:@"Software-start    %.4f\n", CACurrentMediaTime()];
}

-(void) recordTaskEnd {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat endTask: time];
    
    [m_data appendFormat:@"%d\t%.3f\n", TASK_ENDED , time];
    [m_json appendFormat:@"\"Task-ended\": {\n\t\"T\": %.3f\n}\n\n", time];
    [m_txt appendFormat:@"Task-end    %.4f\n", CACurrentMediaTime()];
}

-(void) recordTaskBegin {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat reset: time];
    [m_data appendFormat:@"%d\t%.3f\n", TASK_BEGIN , time];
    [m_json appendFormat:@"\"Task-Begin\": {\n\t\"T\": %.3f\n}\n\n", time];
    [m_txt appendFormat:@"Task-begin    %d  %d  %.4f\n", State.categoryType, State.documentType, CACurrentMediaTime()];
}

-(void) recordReset {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\n", RECORD_RESET, CACurrentMediaTime()];
    [m_json appendFormat:@"\"Software-reset\": {\n\t\"T\": %.3f\n}\n\n", CACurrentMediaTime()];
    
}

-(void) recordReverse {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\n", RECORD_REVERSE, CACurrentMediaTime()];
    [m_json appendFormat:@"\"Feedback-reversed\": {\n\t\"T\": %.3f\n}\n\n", CACurrentMediaTime()];
}

-(void) recordDocumentLoaded {
    ++m_numOfLogs;
    
    [m_data appendFormat:@"%d\t%.3f\t%d\t%d\n", DOCUMENT_LOADED, CACurrentMediaTime(), State.documentType, State.categoryType];
    [m_json appendFormat:@"\"Document-loaded\": {\n\t\"T\": %.3f,\n\t\"Document-ID\": %d\n\t\"Category-ID\": %d\n}\n\n", CACurrentMediaTime(), State.documentType, State.categoryType];
}

-(void) recordFeedbackTypeChanged {
    ++m_numOfLogs;
    
    [m_data appendFormat:@"%d\t%.3f\t%d\n", FEEDBACK_TYPE, CACurrentMediaTime(), State.feedbackType];
    
    [m_json appendFormat:@"\"Feedback-type\": {\n\t\"T\": %.3f,\n\t\"Type:\"%d\"\n}\n\n", CACurrentMediaTime(), State.feedbackType];
}

-(void) recordAudioOn {
    ++m_numOfLogs;
    
    [m_data appendFormat:@"%d\t%.3f\n", AUDIO_ON, CACurrentMediaTime()];
    [m_json appendFormat:@"\"Audio-on\": {\n\t\"T\": %.3f\n}\n\n", CACurrentMediaTime()];
}

-(void) recordAudioOff {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\n", AUDIO_OFF, CACurrentMediaTime()];
    [m_json appendFormat:@"\"Audio-off\": {\n\t\"T\": %.3f\n}\n\n", CACurrentMediaTime()];
}

-(void) recordVibrationOn {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\n", VIBRATION_ON, CACurrentMediaTime()];
    [m_json appendFormat:@"\"Vibration-on\": {\n\t\"T\": %.3f\n}\n\n", CACurrentMediaTime()];
}

-(void) recordVerticalStop {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\n", VERTICAL_STOP, CACurrentMediaTime()];
    [m_json appendFormat:@"\"Vertical-stop\": {\n\t\"T\": %.3f\n}\n\n", CACurrentMediaTime()];
}

-(void) recordVibrationOff {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\n", VIBRATION_OFF, CACurrentMediaTime()];
    [m_json appendFormat:@"\"Vibration-off\": {\n\t\"T\": %.3f\n}\n\n", CACurrentMediaTime()];
}

-(void) recordTouchDown: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText{
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\t%.2f\t%.2f\t%d\t%d\t%@\n", TOUCH_DOWN, CACurrentMediaTime(), x, y, lineIndex, wordIndex, wordText];
    [m_json appendFormat:@"\"Touch-down\": {\n\t\"T\": %.3f,\n\t\"x\": %.2f,\n\t\"y\": %.2f,\n\t\"Line-index\": %d,\n\t\"Word-index\": %d,\n\t\"Word-text\": \"%@\"\n}\n\n", CACurrentMediaTime(), x, y, lineIndex, wordIndex, wordText];
}

-(void) recordTouchUp: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText{
    ++m_numOfLogs;
    
    [m_data appendFormat:@"%d\t%.3f\t%.2f\t%.2f\t%d\t%d\t%@\n", TOUCH_UP, CACurrentMediaTime(), x, y, lineIndex, wordIndex, wordText];
    [m_json appendFormat:@"\"Touch-up\": {\n\t\"T\": %.3f,\n\t\"x\": %.2f,\n\t\"y\": %.2f,\n\t\"Line-index\": %d,\n\t\"Word-index\": %d,\n\t\"Word-text\": \"%@\"\n}\n\n", CACurrentMediaTime(), x, y, lineIndex, wordIndex, wordText];
    
}

-(void) recordTouchMove: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText{
    ++m_numOfLogs;
    //NSLog(@"%.2f %.2f; Line: %d, Word: %@, WordID: %d; %.2f", x, y, lineIndex, wordText, wordIndex, m_prevY);
    
    [m_data appendFormat:@"%d\t%.3f\t%.2f\t%.2f\t%d\t%d\t%@\n", TOUCH_MOVE, CACurrentMediaTime(), x, y, lineIndex, wordIndex, wordText];
    [m_json appendFormat:@"\"Touch-move\": {\n\t\"T\": %.3f,\n\t\"x\": %.2f,\n\t\"y\": %.2f,\n\t\"Line-index\": %d,\n\t\"Word-index\": %d,\n\t\"Word-text\": \"%@\"\n}\n\n", CACurrentMediaTime(), x, y, lineIndex, wordIndex, wordText];
}

-(void) recordBeginLine: (int)lineID {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\t%d\n", BEGIN_LINE, CACurrentMediaTime(), lineID];
    [m_json appendFormat:@"\"Begin-line\": {\n\t\"T\": %.3f,\n\t\"Line-index:\"%d\n}\n\n", CACurrentMediaTime(), lineID];
}


-(void) recordConvertMode {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\t%d\n", CONVERT_MODE, CACurrentMediaTime(), State.mode];
    [m_json appendFormat:@"\"Convert-mode\": {\n\t\"T\": %.3f,\n\t\"Mode:\"%@\n}\n\n", CACurrentMediaTime(), [State isExplorationTextMode] ? @"Exploration" : @"Reading"];
}

-(void) recordEndLine: (int)lineID {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\t%d\n", END_LINE, CACurrentMediaTime(), lineID];
    [m_json appendFormat:@"\"End-line\": {\n\t\"T\": %.3f,\n\t\"Line-index:\"%d\n}\n\n", CACurrentMediaTime(), lineID];
}

-(void) recordEndParagraph: (int)paraID  {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\t%d\n", END_PARAGRAPH, CACurrentMediaTime(), paraID];
    [m_json appendFormat:@"\"End-paragraph\": {\n\t\"T\": %.3f,\n\t\"Paragraph-index:\"%d\n}\n\n", CACurrentMediaTime(), paraID];
}

-(void) recordSpeakWord: (NSString*)word withSpeed: (float)speed {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\t%@\t%.2f\n", SPEAK_WORD, CACurrentMediaTime(), word, speed];
    [m_json appendFormat:@"\"Speak-word\": {\n\t\"T\": %.3f,\n\t\"Word\": \"%@\",\n\t\"Speed\": %.2f\n}\n\n", CACurrentMediaTime(), word, speed];
}

-(void) recordVerticalFeedback: (int)vibrationCommand withVibrationDistance: (float)power withAudioFrequency:(float)freq {
    ++m_numOfLogs;
    [m_data appendFormat:@"%d\t%.3f\t%d\t%.2f\t%.2f\n", VERTICAL_FEEDBACK, CACurrentMediaTime(), vibrationCommand, power, freq];
    [m_json appendFormat:@"\"Vertical-feedback\": {\n\t\"T\": %.3f,\n\t\"Haptic-on\": %d,\n\t\"Distance-from-line\": %.2f,\n\t\"Audio-freq\": %.2f\n}\n\n", CACurrentMediaTime(), vibrationCommand, power, freq];
}

- (NSString*) dumpJson {
    return m_json;
}

- (void) saveToFile {
    NSArray *array = [NSArray arrayWithObjects:m_data, nil];
    [File write:[NSString stringWithFormat:@"%@.txt", [File userID]] dataArray:array];
    
    array = [NSArray arrayWithObjects:m_json, nil];
    [File write:[NSString stringWithFormat:@"%@.json", [File userID]] dataArray:array];
}

@end
