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
    UILabel *lblTitle, *lblFeedbackType, *lblDocument, *lblAudioType, *lblAudioPitch, *lblMaxVolume, *lblHapticType,
            *lblMaxVibration, *lblLineHeight, *lblHapticThres, *lblInsTTS, *lblReadTTS, *lblReadSpeed, *lblReadPitch,
            *lblLineSpacing, *lblAudioThreshold, *lblVisualization,
            *lblDebug, *lblLog, *lblDemo, *lblSightedReading, *lblAudioVolume, *numHapticThres, *lblBluetooth;
    
    UIButton *btnReset, *btnResume, *btnStart,
             *btnTaskStart, *btnLineBegin, *btnLineEnd, *btnParaEnd, *btnTextEnd, *btnAboveLine, *btnBelowLine;
    
    UISegmentedControl *segFeedback, *segDocument, *segAudioType, *segHapticType, *segLineHeight, *segInsTTS, *segReadingTTS,
                       *segReadingPitch, *segGuidance, *segDebug, *segVisualization, *segLeftResion, *segLog, *segCategory, *segExploration, *segBluetoothState;
    
    UISwitch *swcAudioPitch, *swcAudioVolume, *swcReadPitch, *swcGuidance, *swcShowDebug, *swcShowLog, *swcLeftRegion, *swcVisualization, *swcShowStat, *swcSightedReading;
    
    UISlider *sldMaxVolume, *sldMaxVibration, *sldReadingSpeed, *sldLineHeight, *sldHapticThres, *sldLineSpacing, *sldAudioThreshold,
             *sldAboveLine, *sldBelowLine;
    
    UITextView *txtLog, *txtStat;
}

- (void) addControls;
- (void) switchView;


- (void)segFeedbackChanged: (id)sender;
- (void)segCateboryChanged: (id)sender;
- (void)segDocumentChanged: (id)sender;
- (void)modeChanged: (id)sender;
- (void)segInsTTSChanged: (id)sender;


@end
