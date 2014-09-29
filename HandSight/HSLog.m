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
        m_startTime = 0;
        m_data = [NSMutableString stringWithString:@""];
        m_json = [NSMutableString stringWithString:@""];
        m_txt = [NSMutableString stringWithString:@""];
        
        File = [HSFile sharedInstance];
        State = [HSState sharedInstance];
        Stat = [HSStat sharedInstance];
        
        [self recordSoftwareStart];
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
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm:ss"];
    
    m_startTime = CACurrentMediaTime(); 
    m_instruction = @"";
    
    [m_data appendFormat:@"%d\t%.3f\n", SOFTWARE_STARTED, m_startTime];
    [m_json appendFormat:@"\"Software-started\": {\n\t\"T\": %.3f\n}\n\n", m_startTime];
    [m_txt appendFormat:@"%.4f | Software-start:    %@\n", m_startTime-m_startTime, [formatter stringFromDate:[NSDate date]]];
}

-(void) recordTaskEnd {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat endTask: time];
    
    [m_data appendFormat:@"%d\t%.3f\n", TASK_ENDED , time];
    [m_json appendFormat:@"\"Task-ended\": {\n\t\"T\": %.3f\n}\n\n", time];
    [m_txt appendFormat:@"%.4f | Task-end\n", time - m_startTime];
}

-(void) recordTaskBegin {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat reset: time];
    [m_data appendFormat:@"%d\t%.3f\n", TASK_BEGIN , time];
    [m_json appendFormat:@"\"Task-Begin\": {\n\t\"T\": %.3f\n}\n\n", time];
    [m_txt appendFormat:@"%.4f | Task-begin:    Feedback- %d    Cat- %d Doc- %d\n", time - m_startTime, State.feedbackType, State.categoryType, State.documentType];
}

-(void) recordReset {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\n", RECORD_RESET, time];
    [m_json appendFormat:@"\"Software-reset\": {\n\t\"T\": %.3f\n}\n\n", time];
    [m_txt appendFormat:@"%.4f | Software-reset\n", time - m_startTime];
}

-(void) recordReverse {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\n", RECORD_REVERSE, time];
    [m_json appendFormat:@"\"Feedback-reversed\": {\n\t\"T\": %.3f\n}\n\n", time];
    [m_txt appendFormat:@"%.4f | Feedback-reversed  %d\n", time - m_startTime, State.guided];
}

-(void) recordDocumentLoaded {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%d\t%d\n", DOCUMENT_LOADED, time, State.documentType, State.categoryType];
    [m_json appendFormat:@"\"Document-loaded\": {\n\t\"T\": %.3f,\n\t\"Document-ID\": %d\n\t\"Category-ID\": %d\n}\n\n", time, State.documentType, State.categoryType];
    [m_txt appendFormat:@"%.4f | Document-loaded:    Feedback- %d    Cat- %d Doc- %d\n", time - m_startTime, State.feedbackType, State.categoryType, State.documentType];
}

-(void) recordFeedbackTypeChanged {
    ++m_numOfLogs;
    
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%d\n", FEEDBACK_TYPE, time, State.feedbackType];
    [m_json appendFormat:@"\"Feedback-type\": {\n\t\"T\": %.3f,\n\t\"Type:\"%d\"\n}\n\n", CACurrentMediaTime(), State.feedbackType];
    [m_txt appendFormat:@"%.4f | Feedback-type:    %@\n", time - m_startTime, State.feedbackType == FT_AUDIO ? @"Audio" : @"Haptio"];
}

-(void) recordState {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    
    [m_txt appendFormat:@"State:    %.4f    %d  %d  %d\n", time - m_startTime, State.feedbackType, State.categoryType, State.documentType];
}

-(void) recordVerticalStop {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\n", VERTICAL_STOP, time];
    [m_json appendFormat:@"\"Vertical-stop\": {\n\t\"T\": %.3f\n}\n\n", time];
    [m_txt appendFormat:@"%.4f | Vertical-stop\n", time - m_startTime];
}

-(void) recordTouchDown: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText{
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%.2f\t%.2f\t%d\t%d\t%@\n", TOUCH_DOWN, time, x, y, lineIndex, wordIndex, wordText];
    [m_json appendFormat:@"\"Touch-down\": {\n\t\"T\": %.3f,\n\t\"x\": %.2f,\n\t\"y\": %.2f,\n\t\"Line-index\": %d,\n\t\"Word-index\": %d,\n\t\"Word-text\": \"%@\"\n}\n\n", CACurrentMediaTime(), x, y, lineIndex, wordIndex, wordText];
    
    [m_txt appendFormat:@"%.4f | touch-down (%.3f,%.3f) @%d-%d  %@\n", time - m_startTime, x, y, lineIndex, wordIndex, wordText];
}

-(void) recordTouchUp: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText{
    ++m_numOfLogs;
    
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%.2f\t%.2f\t%d\t%d\t%@\n", TOUCH_UP, time, x, y, lineIndex, wordIndex, wordText];
    [m_json appendFormat:@"\"Touch-up\": {\n\t\"T\": %.3f,\n\t\"x\": %.2f,\n\t\"y\": %.2f,\n\t\"Line-index\": %d,\n\t\"Word-index\": %d,\n\t\"Word-text\": \"%@\"\n}\n\n", CACurrentMediaTime(), x, y, lineIndex, wordIndex, wordText];
    
    [m_txt appendFormat:@"%.4f | touch-up (%.3f,%.3f) @%d-%d  %@\n", time - m_startTime, x, y, lineIndex, wordIndex, wordText];
}

-(void) recordTouchMove: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText{
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    //NSLog(@"%.2f %.2f; Line: %d, Word: %@, WordID: %d; %.2f", x, y, lineIndex, wordText, wordIndex, m_prevY);
    
    [m_data appendFormat:@"%d\t%.3f\t%.2f\t%.2f\t%d\t%d\t%@\n", TOUCH_MOVE, time, x, y, lineIndex, wordIndex, wordText];
    [m_json appendFormat:@"\"Touch-move\": {\n\t\"T\": %.3f,\n\t\"x\": %.2f,\n\t\"y\": %.2f,\n\t\"Line-index\": %d,\n\t\"Word-index\": %d,\n\t\"Word-text\": \"%@\"\n}\n\n", CACurrentMediaTime(), x, y, lineIndex, wordIndex, wordText];
    
    [m_txt appendFormat:@"%.4f | touch-move (%.3f,%.3f) @%d-%d  %@\n", time - m_startTime, x, y, lineIndex, wordIndex, wordText];
}

-(void) recordBeginLine: (int)lineID {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat lineBegin:time];
    
    [m_data appendFormat:@"%d\t%.3f\t%d\n", BEGIN_LINE, time, lineID];
    [m_json appendFormat:@"\"Begin-line\": {\n\t\"T\": %.3f,\n\t\"Line-index:\"%d\n}\n\n", time, lineID];
    [m_txt appendFormat:@"%.4f | Begin-line %d\n", time - m_startTime, lineID];
}


-(void) recordConvertMode {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%d\n", CONVERT_MODE, time, State.mode];
    [m_json appendFormat:@"\"Convert-mode\": {\n\t\"T\": %.3f,\n\t\"Mode:\"%@\n}\n\n", time, [State isExplorationTextMode] ? @"Exploration" : @"Reading"];
    [m_txt appendFormat:@"%.4f | Convert-mode   %@\n", time - m_startTime, [State isExplorationTextMode] ? @"Exploration" : @"Reading" ];
}

-(void) recordEndLine: (int)lineID {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    
    [Stat lineEnd:time];
    
    [m_data appendFormat:@"%d\t%.3f\t%d\n", END_LINE, time, lineID];
    [m_json appendFormat:@"\"End-line\": {\n\t\"T\": %.3f,\n\t\"Line-index:\"%d\n}\n\n", time, lineID];
    [m_txt appendFormat:@"%.4f | End-line %d\n", time - m_startTime, lineID];
}

-(void) recordEndParagraph: (int)paraID  {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat lineEnd:time];
    [m_data appendFormat:@"%d\t%.3f\t%d\n", END_PARAGRAPH, time, paraID];
    [m_json appendFormat:@"\"End-paragraph\": {\n\t\"T\": %.3f,\n\t\"Paragraph-index:\"%d\n}\n\n", time, paraID];
    [m_txt appendFormat:@"%.4f | End-paragraph %d\n", time - m_startTime, paraID];
}

-(void) recordSpeakWord: (NSString*)word withSpeed: (float)speed {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%@\t%.2f\n", SPEAK_WORD, time, word, speed];
    [m_json appendFormat:@"\"Speak-word\": {\n\t\"T\": %.3f,\n\t\"Word\": \"%@\",\n\t\"Speed\": %.2f\n}\n\n", CACurrentMediaTime(), word, speed];
    [m_txt appendFormat:@"%.4f | Speak-word %@~%.3f\n", time - m_startTime, word, speed];
}

-(void) recordVerticalFeedback: (int)vibrationCommand withVibrationDistance: (float)power withAudioFrequency:(float)freq {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%d\t%.2f\t%.2f\n", VERTICAL_FEEDBACK, time, vibrationCommand, power, freq];
    [m_json appendFormat:@"\"Vertical-feedback\": {\n\t\"T\": %.3f,\n\t\"Haptic-on\": %d,\n\t\"Distance-from-line\": %.2f,\n\t\"Audio-freq\": %.2f\n}\n\n", time, vibrationCommand, power, freq];
    [m_txt appendFormat:@"%.4f | Vertical-feedback %d   %.3f    %.3f\n", time - m_startTime, vibrationCommand, power, freq];
}

- (NSString*) dumpJson {
    return m_txt;
}

- (void) saveToFile {
    NSArray *array = [NSArray arrayWithObjects:m_data, nil];
    [File write:[NSString stringWithFormat:@"%@_log.data", [File userID]] dataArray:array];
    
    array = [NSArray arrayWithObjects:m_json, nil];
    [File write:[NSString stringWithFormat:@"%@_log.json", [File userID]] dataArray:array];
    
    array = [NSArray arrayWithObjects:m_txt, nil];
    [File write:[NSString stringWithFormat:@"%@_log.txt", [File userID]] dataArray:array];
}

@end
