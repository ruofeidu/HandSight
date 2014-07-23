//
//  ViewController.h
//  HandSight
//
//  Created by Ruofei Du on 7/9/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextController.h"
#import "CommonController.h"
#import "MenuController.h"

#import "HSUtils.h"
#import "HSFeedback.h"

@interface ViewController : CommonController {
    UILabel *lblTitle, *lblFeedbackType, *lblDocument, *lblAudioType, *lblAudioPitch, *lblMaxVolume, *lblHapticType,
            *lblMaxVibration, *lblLineHeight, *lblHapticThres, *lblInsTTS, *lblReadTTS, *lblReadSpeed, *lblReadPitch,
            *lblLineSpacing, *lblAudioThreshold, *lblVisualization,
            *lblDebug, *lblLog, *lblDemo;
    
    UIButton *btnReset, *btnResume, *btnStart,
             *btnTaskStart, *btnLineBegin, *btnLineEnd, *btnParaEnd, *btnTextEnd, *btnAboveLine, *btnBelowLine;
    
    UISegmentedControl *segFeedback, *segDocument, *segAudioType, *segHapticType, *segLineHeight, *segInsTTS, *segReadingTTS,
                       *segReadingPitch, *segGuidance, *segDebug, *segVisualization, *segLeftResion, *segLog, *segCategory;
    
    UISwitch *swcAudioPitch, *swcReadPitch, *swcGuidance, *swcShowDebug, *swcShowLog, *swcLeftRegion, *swcVisualization;
    
    UISlider *sldMaxVolume, *sldMaxVibration, *sldReadingSpeed, *sldLineHeight, *sldHapticThres, *sldLineSpacing, *sldAudioThreshold,
             *sldAboveLine, *sldBelowLine;
    
    CGFloat m_inset, m_titleFontSize, m_textFontSize, m_titleHeight, m_textHeight, m_titleWidth, m_textWidth, m_segWidth, m_segHeight, m_segInset,
            m_btnLeft, m_btnTop;
    
    NSString *m_titleFontName, *m_textFontName;
    
    UIColor *m_textColor;
    
    HSFeedback *Feedback;
    HSSpeech *Speech;
    HSState *State;
    HSLog *Log;
}

- (void)addControls;
- (void) reset;
- (void) switchView;


@end
