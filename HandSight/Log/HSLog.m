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
        
        m_queue = [[NSMutableArray alloc] init];
        m_appendQueue = [[NSMutableArray alloc] init];
        m_writeLock = false;
        
        File = [HSFile sharedInstance];
        State = [HSState sharedInstance];
        Stat = [HSStat sharedInstance];
        
        [self recordSoftwareStart];
        NSLog(@"[LG] Inited");
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(appendToFile) userInfo:nil repeats:YES];
        
        NSString* newStr = @"\n";
        NSArray *array = [NSArray arrayWithObjects:newStr, nil];
        [File write:[NSString stringWithFormat:@"%@_log_append.json", [File userID]] dataArray: array];
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
    
    [m_data appendFormat:@"%d\t%.3f\t%@\n", SOFTWARE_STARTED, m_startTime, [formatter stringFromDate:[NSDate date]]];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: m_startTime];
    [event setEvent:@"Software-start"];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordTaskBegin {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat reset: time];
    [m_data appendFormat:@"%d\t%.3f\t%d\t%d\t%d\t%d\n", TASK_BEGIN , time, State.feedbackType, State.categoryType, State.documentType, State.mode];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Task-begin"];
    [event setFeedback:State.feedbackType];
    [event setCatgory:State.categoryType];
    [event setDocument:State.documentType];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
    
}

-(void) recordTaskEnd {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat endTask: time];
    
    [m_data appendFormat:@"%d\t%.3f\n", TASK_ENDED , time];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Task-end"];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordTrain {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat reset: time];
    [m_data appendFormat:@"%d\t%.3f\t%d\t%d\t%d\t%d\n", TRAINING , time, State.feedbackType, State.categoryType, State.documentType, State.mode];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Train"];
    [event setFeedback:State.feedbackType];
    [event setCatgory:State.categoryType];
    [event setDocument:State.documentType];
    [event setMode: [State isExplorationTextMode] ? @"Exploration" : @"Reading" ];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordTrainStepChange:(int)stepID {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat reset: time];
    [m_data appendFormat:@"%d\t%.3f\t%d\t%d\t%d\n", TRAIN_STEP_CHANGE , time, stepID, State.categoryType, State.documentType];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"TrainStepByStep"];
    [event setFeedback:State.feedbackType];
    [event setCatgory:State.categoryType];
    [event setDocument:State.documentType];
    [event setTrain:State.feedbackStepByStep];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordDocumentLoaded {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat reset: time];
    [m_data appendFormat:@"%d\t%.3f\t%d\t%d\t%d\t%d\t%d\n", DOCUMENT_LOADED , time, State.mode, State.feedbackType, State.categoryType, State.documentType, State.mode];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Document-Loaded"];
    [event setFeedback:State.feedbackType];
    [event setCatgory:State.categoryType];
    [event setMode: [State isExplorationTextMode] ? @"Exploration" : @"Reading" ];
    [event setDocument:State.documentType];
    [event setTrain:State.feedbackStepByStep];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordControlPanel {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat reset: time];
    [m_data appendFormat:@"%d\t%.3f\n", CONTROL_PANEL , time];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Control-panel"];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
    
    [self appendToFile];
}

-(void) recordReset {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\n", RECORD_RESET, time];
    [m_json appendFormat:@"\"Software-reset\": {\n\t\"T\": %.3f\n}\n\n", time];
    [m_txt appendFormat:@"%.4f | Software-reset\n", time - m_startTime];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Software Reset"];
    [event setCatgory:State.feedbackType];
    [event setCatgory:State.categoryType];
    [event setDocument:State.documentType];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordReverse {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\n", RECORD_REVERSE, time];
    [m_json appendFormat:@"\"Feedback-reversed\": {\n\t\"T\": %.3f\n}\n\n", time];
    [m_txt appendFormat:@"%.4f | Feedback-reversed  %d\n", time - m_startTime, State.guided];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Feedback-reverse"];
    [event setCatgory:State.feedbackType];
    [event setCatgory:State.categoryType];
    [event setDocument:State.documentType];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}


-(void) recordFeedbackTypeChanged {
    ++m_numOfLogs;
    
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%d\n", FEEDBACK_TYPE, time, State.feedbackType];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Feedback-type"];
    [event setFeedback:State.feedbackType];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
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
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Vertical-stop"];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordTouchDown: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText{
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%.2f\t%.2f\t%d\t%d\t%@\n", TOUCH_DOWN, time, x, y, lineIndex, wordIndex, wordText];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Touch-down"];
    [event setX: x];
    [event setY: y];
    [event setLineID: lineIndex];
    [event setWordID: wordIndex];
    [event setWordText: wordText];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordTouchUp: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText{
    ++m_numOfLogs;
    
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%.2f\t%.2f\t%d\t%d\t%@\n", TOUCH_UP, time, x, y, lineIndex, wordIndex, wordText];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Touch-up"];
    [event setX: x];
    [event setY: y];
    [event setLineID: lineIndex];
    [event setWordID: wordIndex];
    [event setWordText: wordText];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordTouchLog: (NSString*) string  withNumTouches: (int)touches {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Touch-Log"];
    [event setTouchLog: string];
    [event setNumTouches: touches];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordExplorationFeedback: (NSString*) string {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Exploration-Feedback"];
    [event setExplorationType: string];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordTouchMove: (float)x withY: (float)y withLineIndex: (int)lineIndex withWordIndex:(int)wordIndex withWordText: (NSString*)wordText{
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%.2f\t%.2f\t%d\t%d\t%@\n", TOUCH_MOVE, time, x, y, lineIndex, wordIndex, wordText];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Touch-move"];
    [event setX: x];
    [event setY: y];
    [event setLineID: lineIndex];
    [event setWordID: wordIndex];
    [event setWordText: wordText];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}


-(void) recordConvertMode {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%d\n", CONVERT_MODE, time, State.mode];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Convert-mode"];
    [event setMode: [State isExplorationTextMode] ? @"Exploration" : @"Reading" ];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordBeginLine: (int)lineID  withWidth: (float)lineWidth withCenterY: (float)lineCenterY{
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat lineBegin:time];
    
    [m_data appendFormat:@"%d\t%.3f\t%d\n", BEGIN_LINE, time, lineID];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Begin-line"];
    [event setLineID: lineID];
    [event setLineWidth: lineWidth];
    [event setLineCenterY: lineCenterY];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}


-(void) recordEndLine: (int)lineID  withWidth: (float)lineWidth withCenterY: (float)lineCenterY{
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    
    [Stat lineEnd:time];
    
    [m_data appendFormat:@"%d\t%.3f\t%d\n", END_LINE, time, lineID];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"End-line"];
    [event setLineID: lineID];
    [event setLineWidth: lineWidth];
    [event setLineCenterY: lineCenterY];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
    
    //[self saveToFile];
}

-(void) recordEndParagraph: (int)paraID withWidth: (float)lineWidth withCenterY: (float)lineCenterY {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat lineEnd:time];
    [m_data appendFormat:@"%d\t%.3f\t%d\n", END_PARAGRAPH, time, paraID];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"End-Paragraph"];
    [event setParaID: paraID];
    [event setLineID: State.lineID];
    [event setLineWidth: lineWidth];
    [event setLineCenterY: lineCenterY];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordSkipWord: (int)num {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [Stat lineEnd:time];
    [m_data appendFormat:@"%d\t%.3f\t%d\n", SKIP_WORD, time, num];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Skip-word"];
    [event setSkipNum: num];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordSpeakWord: (NSString*)word withSpeed: (float)speed {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.3f\t%@\t%.2f\n", SPEAK_WORD, time, word, speed];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Speak-word"];
    [event setWordText: word];
    [event setSpeed: speed];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

-(void) recordVerticalFeedback: (int)vibrationCommand withVibrationDistance: (float)power withAudioFrequency:(float)freq {
    ++m_numOfLogs;
    CGFloat time = CACurrentMediaTime();
    [m_data appendFormat:@"%d\t%.4f\t%d\t%.4f\t%.4f\n", VERTICAL_FEEDBACK, time, vibrationCommand, power, freq];
    
    NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
    [event setTime: time - m_startTime];
    [event setEvent:@"Vertical-feedback"];
    [event setVibrationCommand: vibrationCommand];
    [event setVibrationPower: power];
    [event setFrequency: freq];
    [m_queue addObject:event];
    [m_appendQueue addObject:event];
}

- (NSString*) dumpJson {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:m_queue options:NSJSONWritingPrettyPrinted error:&error];
    NSString* newStr = [NSString stringWithUTF8String:[jsonData bytes]];
    return newStr;
}

- (void) saveOtherFile{
    NSArray *array = [NSArray arrayWithObjects:m_data, nil];
    [File write:[NSString stringWithFormat:@"%@_log.data", [File userID]] dataArray:array];
    
    /*
    array = [NSArray arrayWithObjects:m_json, nil];
    [File write:[NSString stringWithFormat:@"%@_log.old", [File userID]] dataArray:array];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:m_queue options:NSJSONWritingPrettyPrinted error:&error];
    NSString* newStr = [NSString stringWithUTF8String:[jsonData bytes]];
    array = [NSArray arrayWithObjects:newStr, nil];
    [File write:[NSString stringWithFormat:@"%@_log.json", [File userID]] dataArray: array];
    
    
    array = [NSArray arrayWithObjects:m_txt, nil];
    [File write:[NSString stringWithFormat:@"%@_log.txt", [File userID]] dataArray:array];
     */
}

- (void) saveToFile {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:m_queue options:NSJSONWritingPrettyPrinted error:&error];
    NSString* newStr = [NSString stringWithUTF8String:[jsonData bytes]];
    NSArray *array = [NSArray arrayWithObjects:newStr, nil];
    [File write:[NSString stringWithFormat:@"%@_log.json", [File userID]] dataArray: array];
    
    [self saveOtherFile];
}

- (void) appendToFile {
    if (m_writeLock) return;
    m_writeLock = true;
    if ([m_appendQueue count] > 0) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:m_appendQueue options:NSJSONWritingPrettyPrinted error:&error];
        
        
        NSString* jsonString = [NSString stringWithUTF8String:[jsonData bytes]];
        [File append:[NSString stringWithFormat:@"%@_log_append.json", [File userID]] data:jsonString];
        [m_appendQueue removeAllObjects];
    }
    m_writeLock = false;
}

- (void) convert {
    if (!State.debugMode) return;
    [m_queue removeAllObjects];
    NSString *name =   @"1013_133924_log";
   //@"1009_122403_log";@"1014_111801_log"; //
    NSString *file = [[NSBundle mainBundle] pathForResource: name ofType:@"data"];
    NSString *str = [NSString stringWithContentsOfFile:file
                                              encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray* lines = [str componentsSeparatedByString:@"\n"];
    NSLog(@"Line 1: %@", [lines objectAtIndex:0]);
    
    int lineID = 0; float lineWidth = 0, lineCenterY = 0, cat = 0, doc = 1;
    
    for (NSString* line in lines) {
        NSString* aline = [line stringByReplacingOccurrencesOfString: @"   " withString: @"\t"];
        NSArray* words = [aline componentsSeparatedByString:@"\t"];
        int command = [[words objectAtIndex:0] intValue];
        NSMutableDictionary *event = [[NSMutableDictionary alloc] init];
        
        if ([words count] < 2) continue;
        
        if (command == SOFTWARE_STARTED) {
            m_startTime = [[words objectAtIndex:1] floatValue];
            [event setTime: m_startTime];
        } else {
            m_time = [[words objectAtIndex:1] floatValue] - m_startTime;
            [event setTime: m_time];
        }
        
        float pw1[18] = {747.5469, 792.582, 743.2915, 755.4219, 798.2627, 781.4565, 766.7729, 805.0918, 753.248, 764.2607, 739.7744, 784.1738, 788.7266, 767.1318, 801.0723, 770.7104, 799.8726, 123.3916 };
        float pw2[17] = {805.0918, 738.9951, 750.3257, 748.5825, 787.7832, 659.6196, 750.8691, 777.7754, 784.6558, 369.4443, 808.0654, 761.9434, 804.9995, 756.1807, 760.8359, 805.7993, 680.312};
        float mw1[23] = {387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 351.418, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 321.0972};
        
        float mw2[23] = {387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 299.4819, 387.5, 387.5, 387.5, 387.4999, 387.5, 387.5, 387.4999, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 387.5, 206.7866};
        
        float py1[18] = {85, 114, 143, 172, 230, 259, 288, 317, 346, 404, 433, 462, 491, 520, 578, 607, 636, 665};
        float py2[17] = {85, 114, 143, 172, 201, 230, 288, 317, 346, 375, 433, 462, 491, 520, 578, 607, 636};
        float my1[23] = {467, 496, 525, 554, 583, 612, 641, 670, 85, 114, 143, 172, 201, 230, 259, 288, 317, 346, 375, 404, 433, 462, 491};
        float my2[23] = {496, 525, 554, 583, 612, 641, 670, 85, 114, 143, 172, 201, 230, 259, 288, 317, 346, 375, 404, 433, 462, 491, 520};
        
        
        bool event_detected = true;
        
        switch (command) {
            case SOFTWARE_STARTED:
                [event setEvent:@"Software-start"];
                break;
                
            case TASK_ENDED:
                [event setEvent:@"Task-end"];
                break;
                
            case TRAINING:
                
                break;
                
            case TOUCH_DOWN:
                [event setEvent:@"Touch-down"];

            case TOUCH_MOVE:
                if (command == TOUCH_MOVE) [event setEvent:@"Touch-move"];
                
            case TOUCH_UP:
                if (command == TOUCH_UP) [event setEvent:@"Touch-up"];
                [event setX: [[words objectAtIndex:2] floatValue] ];
                [event setY: [[words objectAtIndex:3] floatValue] ];
                [event setLineID: [[words objectAtIndex:4] intValue] ];
                [event setWordID: [[words objectAtIndex:5] intValue] ];
                [event setWordText: [words objectAtIndex:6] ];
                break;
                
            case TRAIN_STEP_CHANGE:
                
            case CONTROL_PANEL:
                [event setEvent:@"Control-panel"];
                break;
                
            case RECORD_RESET:
                [event setEvent:@"Software-reset"];
                break;
                
            case FEEDBACK_TYPE:
                [event setEvent:@"Feedback-type"];
                [event setFeedback: [[words objectAtIndex:2] intValue] ];
                break;
                
            case VERTICAL_STOP:
                [event setEvent:@"Vertical-stop"];
                break;
                
            case CONVERT_MODE:
                [event setEvent:@"Convert-mode"];
                if ([[words objectAtIndex:2] intValue] == 1 ) {
                    [event setMode: @"Reading"];
                } else {
                    [event setMode: @"Exploration"];
                }
                break;
                
            case BEGIN_LINE:
                [event setEvent:@"Begin-line"];
                lineID += 1;
                
                if (cat == 0 && doc == 1) {
                    //if (lineID > 17) NSLog(@"Err01"); else
                    lineWidth = pw1[lineID];
                    lineCenterY = py1[lineID];
                } else
                if (cat == 0 && doc == 2){
                    
                    //if (lineID > 16) NSLog(@"Err02"); else
                        lineWidth = pw2[lineID];
                    lineCenterY = py2[lineID];
                } else
                if (cat == 1 && doc == 1) {
                    
                    //if (lineID > 22) NSLog(@"Err11"); else
                        lineWidth = mw1[lineID];
                    lineCenterY = my1[lineID];
                } else
                if (cat == 1 && doc == 2) {
                    
                    //if (lineID > 22) NSLog(@"Err12"); else
                        lineWidth = mw2[lineID];
                    lineCenterY = my2[lineID];
                }
                
                
            case END_LINE:
                if (command == END_LINE) [event setEvent:@"End-line"];
                [event setLineID: lineID];
                [event setLineWidth: lineWidth];
                [event setLineCenterY: lineCenterY];
                //[event setLineID: [[words objectAtIndex:2] intValue] ];
                break;
                
            case END_PARAGRAPH:
                [event setEvent:@"End-paragraph"];
                [event setLineWidth: lineWidth];
                [event setLineID: lineID];
                [event setLineCenterY: lineCenterY];
                [event setParaID: [[words objectAtIndex:2] intValue]];
                break;
                
            case SKIP_WORD:
                [event setSkipNum: [[words objectAtIndex:2] intValue] ];
                break;
                
            case SPEAK_WORD:
                [event setEvent:@"Speak-word"];
                [event setWordText: [words objectAtIndex:2]];
                [event setSpeed: [[words objectAtIndex:3] floatValue]];
                break;
                
            case VERTICAL_FEEDBACK:
                [event setEvent:@"Vertical-feedback"];
                if ([words count] < 5) NSLog(@"V F %@", words);
                [event setVibrationCommand:  [[words objectAtIndex:2] intValue]];
                [event setVibrationPower:  [[words objectAtIndex:3] floatValue]];
                [event setFrequency:  [[words objectAtIndex:4] floatValue]];
                break;
                
            case DOCUMENT_LOADED:
                [event setEvent:@"Document-Loaded"];
                lineID = -1;
                if ([words count] < 6) {
                    NSLog(@"Err %@", words);
                    NSLog(@" %d", [words count]);
                    break;
                }
                cat = [[words objectAtIndex:4] intValue];
                doc = [[words objectAtIndex:5] intValue];
                
                [event setMode: [[words objectAtIndex:2] intValue] != 1 ? @"Exploration" : @"Reading" ];
                [event setFeedback: [[words objectAtIndex:3] intValue]];
                [event setCatgory: [[words objectAtIndex:4] intValue]];
                [event setDocument: doc];
                if (doc == 1 || doc == 2) {
                    [event setTrain: 0];
                } else {
                    [event setTrain:1];
                }
                break;
                
            default:
                event_detected = false;
                
                break;
        }
        
        if (event_detected) [m_queue addObject:event];
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:m_queue options:NSJSONWritingPrettyPrinted error:&error];
    NSString* newStr = [NSString stringWithUTF8String:[jsonData bytes]];
    NSArray* array = [NSArray arrayWithObjects:newStr, nil];
    [File write:[NSString stringWithFormat:@"%@.json", name] dataArray: array];
    
    [self saveToFile];
}

@end
