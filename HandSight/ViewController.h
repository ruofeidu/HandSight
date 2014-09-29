//
//  ViewController.h
//  HandSight
//
//  Created by Ruofei Du on 7/9/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonController.h"
#import "CommonTextController.h"

@interface ViewController : CommonController {
    UILabel *lblTitle, *lblAdvanced, *lblFeedbackType, *lblDocument, *lblAudioType, *lblAudioPitch, *lblMaxVolume, *lblHapticType, *lblExpCues, *lblSighted, *lblExplorationStudy, *lblReadingStudy,
            *lblMaxVibration, *lblLineHeight, *lblHapticThres, *lblInsTTS, *lblReadTTS, *lblReadSpeed, *lblReadPitch, *lblAboveLine, *lblBelowLine, *lblSpeed, *lblSpeedTest, *lblSpeech,
            *lblLineSpacing, *lblAudioThreshold, *lblVisualization, *lblDebug, *lblLog, *lblDemo, *lblSightedReading, *lblAudioVolume, *lblBluetooth, *lblExpDemo, *lblExpDoc, *lblPlainDoc, *lblMagDoc, *lblFeedbackTrain;
    
    UILabel *numHapticThres, *numLineHeights, *numMaxVolume, *numReadingSpeed, *numMaxVibration;
    
    UIButton *btnReset, *btnResume, *btnStart,
             *btnTaskStart, *btnLineBegin, *btnLineEnd, *btnParaEnd, *btnTextEnd, *btnAboveLine, *btnBelowLine, *btnExpText, *btnExpPicture, *btnExpSpacing;
    
    UISegmentedControl *segFeedback, *segDocument, *segAudioType, *segHapticType, *segLineHeight, *segInsTTS, *segReadingTTS, *segSpeed,
                       *segReadingPitch, *segGuidance, *segDebug, *segVisualization, *segLeftResion, *segLog, *segCategory, *segMode, *segBluetoothState, *segExpDemo, *segExpDoc, *segPlainDoc, *segMagDoc, *segFeedbackTrain, *segFeedbackStep;
    
    UISwitch *swcAudioPitch, *swcAudioVolume, *swcReadPitch, *swcGuidance, *swcShowDebug, *swcShowLog, *swcLeftRegion, *swcVisualization, *swcShowStat, *swcSightedReading, *swcSpeech;
    
    UISlider *sldMaxVolume, *sldMaxVibration, *sldReadingSpeed, *sldLineHeight, *sldHapticThres, *sldLineSpacing, *sldAudioThreshold,
             *sldAboveLine, *sldBelowLine;
    
    UITextView *txtLog, *txtStat;
    
    CGFloat x, y;
    BOOL m_render;
    
    NSTimer                 *m_timer;
}

- (void) addControls;
- (void) switchView;


- (void)segFeedbackChanged: (id)sender;
- (void)segFeedbackStepChanged: (id)sender;
- (void)segCateboryChanged: (id)sender;
- (void)segDocumentChanged: (id)sender;
- (void)modeChanged: (id)sender;
- (void)segInsTTSChanged: (id)sender;
- (void)swcReadPitchChanged: (id)sender;
- (void)sldFeedbackThresChanged: (id)sender;
- (void)segHapticTypeChanged: (id)sender;
- (void)segReadingTTSChanged: (id)sender;
- (void)sldReadingSpeedChanged: (id)sender;
- (void)sldLineHeightChanged: (id)sender;
- (void)segAudioTypeChanged: (id)sender;
- (void)sldMaxVolumeChanged: (id)sender;

@end
