//
//  ViewController.m
//  HandSight
//
//  Created by Ruofei Du on 7/9/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)blueToothTimer: (NSTimer*) timer
{
    [segBluetoothState setSelectedSegmentIndex: State.bluetoothState];
    if (State.bluetoothState == BT_OFF) {
        if (State.feedbackType != FT_NONE) {
            State.feedbackType = FT_AUDIO;
            [segFeedback setSelectedSegmentIndex:State.feedbackType]; 
        }
    }
}

- (void) segAudioTypeChanged:(id)sender {
    
}

- (void) sldMaxVolumeChanged:(id)sender {
    State.maxVolume = [sldMaxVolume value];
    [numMaxVolume setText: [NSString stringWithFormat:@"%.0f", [sldMaxVolume value]]];
}

- (void) swcReadPitchChanged:(id)sender {
    
    [numLineHeights setText: [NSString stringWithFormat:@"%.0f", [sldLineHeight value]]];
}

- (void) segHapticTypeChanged:(id)sender {
    [numLineHeights setText: [NSString stringWithFormat:@"%.0f", [sldLineHeight value]]];
    
}

- (void) sldFeedbackThresChanged:(id)sender {
    State.maxFeedbackValue = [sldHapticThres value];
    [numHapticThres setText: [NSString stringWithFormat:@"%.0f", [sldHapticThres value]]];
    
}

- (void) sldLineHeightChanged:(id)sender {
    [numLineHeights setText: [NSString stringWithFormat:@"%.0f", [sldLineHeight value]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_timer                 =       [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(blueToothTimer:) userInfo:nil repeats:YES];
    
    [self hideStatusBar];
    [self addControls];
    NSLog(@"[CP] Inited");
}

- (void)segFeedbackChanged: (id)sender
{
    State.feedbackType = (enum FeedbackType) [segFeedback selectedSegmentIndex];
    [Feedback changed]; 
}

- (void)segCateboryChanged: (id)sender
{
    State.categoryType = (enum CategoryType) [segCategory selectedSegmentIndex];
}

- (void)segDocumentChanged: (id)sender
{
    State.documentType = (enum DocumentType) [segDocument selectedSegmentIndex];
}

- (void)modeChanged: (id)sender
{
    State.mode = (enum ModeType) [segExploration selectedSegmentIndex];
}

- (void)segInsTTSChanged: (id)sender
{
    State.instructionGender = (enum SpeechGender) [segInsTTS selectedSegmentIndex];
}

- (void)segReadingTTSChanged: (id)sender
{
    State.readingGender = (enum SpeechGender) [segReadingTTS selectedSegmentIndex];
}

- (void)sldReadingSpeedChanged: (id)sender
{
    State.readingSpeed = [sldReadingSpeed value];
}

- (void)swcShowLogChanged: (id)sender
{
    [txtLog setText: [Log dumpJson]];
    [txtLog setHidden: ![swcShowLog isOn]];
}

- (void)swcSightedReadingChanged: (id)sender
{
    State.sightedReading = [swcSightedReading isOn];
    if (State.sightedReading) {
        [segDocument setTitle:@"1" forSegmentAtIndex:0];
        [segDocument setTitle:@"2" forSegmentAtIndex:1];
        [segDocument setTitle:@"3" forSegmentAtIndex:2];
        [segDocument setTitle:@"4" forSegmentAtIndex:3];
        [segDocument setTitle:@"Train" forSegmentAtIndex:4];
        [segDocument setEnabled:YES forSegmentAtIndex:4];
    } else {
        [segDocument setTitle:@"Train" forSegmentAtIndex:0];
        [segDocument setTitle:@"A" forSegmentAtIndex:1];
        [segDocument setTitle:@"B" forSegmentAtIndex:2];
        [segDocument setTitle:@"C" forSegmentAtIndex:3];
        [segDocument setTitle:@"D" forSegmentAtIndex:4];
        [segDocument setEnabled:NO forSegmentAtIndex:4];
    }
}

- (void)swcShowDebugChanged: (id)sender
{
    State.debugMode = [swcShowDebug isOn];
}

- (void)swcAudioPitchChanged: (id)sender
{
    State.audioPitch = [swcAudioPitch isOn];
}

- (void)swcAudioVolumeChanged: (id)sender
{
    State.audioVolume = [swcAudioVolume isOn];
}


- (void)swcShowStatChanged: (id)sender
{
    [txtStat setText: [Stat dumpCSV]];
    [txtStat setHidden: ![swcShowStat isOn]];
}

- (void)addControls
{
    CGFloat verticalInset = m_inset;
    
    if (lblTitle == nil) {
        [Log recordSoftwareStart];
    }
    
    lblTitle = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, m_inset, m_titleWidth, m_titleHeight)];
        [l setText:@"HandSight Control Panel"];
        [l setFont: [UIFont fontWithName:m_titleFontName size:m_titleFontSize]];
         [self.view addSubview: l];
        l;
    });
    
    verticalInset += m_titleHeight;
    
    lblFeedbackType = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Feedback Type: "];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview: l];
        l;
    });
    
    segFeedback =  ({
        NSArray *a = [NSArray arrayWithObjects:@"Audio", @"Haptic", @"Hybrid", @"Haptio", nil];
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems:a];
        [s setFrame:CGRectMake(m_inset + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight)];
        [s setSelectedSegmentIndex: [State feedbackType]];
        [s addTarget:self action:@selector(segFeedbackChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    segExploration =  ({
        NSArray *a = [NSArray arrayWithObjects:@"Explore-Text", @"Reading", nil];
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems:a];
        [s setFrame:CGRectMake(m_inset + m_textWidth + m_segWidth + m_inset, verticalInset + m_segInset, m_segWidth, m_segHeight)];
        [s setSelectedSegmentIndex: [State mode]];
        [s setEnabled:NO forSegmentAtIndex:MD_EXPLORATION_TEXT];
        [s addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    
    
    verticalInset += m_textHeight;
    
    lblDocument = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Document:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview: l];
        l;
    });
    
    segCategory =  ({
        NSArray *a = [NSArray arrayWithObjects:@"Plain", @"Magazine", nil]; //, @"Menu"
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems:a];
        [s setFrame:CGRectMake(m_inset + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight)];
        [s setSelectedSegmentIndex: [State categoryType]];
        [s addTarget:self action:@selector(segCateboryChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    segDocument =  ({
        NSArray *a = [State sightedReading] ? [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"Train", nil] : [NSArray arrayWithObjects:@"Train", @"A", @"B", @"C", @"D", nil];
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems:a];
        [s setFrame:CGRectMake(m_inset + m_textWidth + m_segWidth + m_inset, verticalInset + m_segInset, m_segWidth, m_segHeight)];
        [s setSelectedSegmentIndex: [State documentType]];
        [s addTarget:self action:@selector(segDocumentChanged:) forControlEvents:UIControlEventValueChanged];
        [s setEnabled:NO forSegmentAtIndex:4];
        [self.view addSubview: s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblBluetooth = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Bluetooth State:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview:l];
        l;
    });
    
    segBluetoothState =  ({
        NSArray *a = [NSArray arrayWithObjects:@"Off", @"Connecting", @"On", nil];
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems:a];
        [s setFrame:CGRectMake(m_inset + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight)];
        [s setSelectedSegmentIndex: 0];
        [s setUserInteractionEnabled: NO];
        [self.view addSubview:s];
        s;
    });
    
    lblSightedReading = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset * 2 + m_textWidth + m_segWidth, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Sighted Reading:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview:l];
        l;
    });
    
    swcSightedReading = ({
        UISwitch *s = [[UISwitch alloc] initWithFrame: CGRectMake(m_inset * 2 + m_textWidth + m_segWidth + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight) ];
        [s setOn: State.sightedReading];
        [s addTarget:self action:@selector(swcSightedReadingChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblAudioType = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Audio Type:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview: l];
        l;
    });
    
    segAudioType =  ({
        NSArray *a = [NSArray arrayWithObjects:@"Beep", @"Piano", @"Flute", nil];
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems:a];
        [s setFrame:CGRectMake(m_inset + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight)];
        [s setSelectedSegmentIndex: 0];
        [s setEnabled:NO];
        [s addTarget:self action:@selector(segAudioTypeChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    lblAudioPitch = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset * 2 + m_textWidth + m_segWidth, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Audio Pitch:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview:l];
        l;
    });
    
    swcAudioPitch = ({
        UISwitch *s = [[UISwitch alloc] initWithFrame: CGRectMake(m_inset * 2 + m_textWidth + m_segWidth + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight) ];
        [s setOn: YES];
        [self.view addSubview: s];
        [s addTarget:self action:@selector(swcAudioPitchChanged:) forControlEvents:UIControlEventValueChanged];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblMaxVolume = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Max Volume:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        l;
    }); [self.view addSubview:lblMaxVolume];
    
    numMaxVolume = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset + m_textWidth, verticalInset, m_swcWidth, m_textHeight)];
        [l setText: [NSString stringWithFormat:@"%.0f", State.maxFeedbackValue] ];
        [l setTextColor: m_textColor];
        [l setTextAlignment: NSTextAlignmentCenter];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview:l];
        l;
    });
    
    sldMaxVolume = ({
        UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(m_inset + m_textWidth + m_swcWidth, verticalInset + m_segInset, m_segWidth - m_swcWidth, m_segHeight)];
        [s setMinimumValue: 0.1f];
        [s setMaximumValue: 1.0f];
        [s setEnabled: NO];
        [s addTarget:self action:@selector(sldMaxVolumeChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblHapticType = ({
        UILabel *l = [[UILabel alloc] initWithFrame: CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Haptic Type:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview: l];
        l;
    });
    
    segHapticType =  ({
        NSArray *a = [NSArray arrayWithObjects:@"Constant", @"Pulse", nil];
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems:a];
        [s setFrame:CGRectMake(m_inset + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight)];
        [s setSelectedSegmentIndex:0];
        [s setEnabled:NO];
        [s addTarget:self action:@selector(segHapticTypeChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblMaxVibration = ({
        UILabel *l = [[UILabel alloc] initWithFrame: CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Max Vibration:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview: l];
        l;
    });
    
    numMaxVibration = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset + m_textWidth, verticalInset, m_swcWidth, m_textHeight)];
        [l setText: [NSString stringWithFormat:@"%.0f", State.maxFeedbackValue] ];
        [l setTextColor: m_textColor];
        [l setTextAlignment: NSTextAlignmentCenter];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview:l];
        l;
    });
    
    sldMaxVibration = ({
        UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(m_inset + m_textWidth + m_swcWidth, verticalInset + m_segInset, m_segWidth - m_swcWidth, m_segHeight)];
        [s setMinimumValue: 0.1f];
        [s setMaximumValue: 1.0f];
        [s setValue: State.maxVibration];
        
        [s addTarget:self action:@selector(sldLineHeightChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblLineHeight = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Line Height:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        l;
    }); [self.view addSubview:lblLineHeight];

    numLineHeights = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset + m_textWidth, verticalInset, m_swcWidth, m_textHeight)];
        [l setText: [NSString stringWithFormat:@"%.0f", State.lineHeight] ];
        [l setTextColor: m_textColor];
        [l setTextAlignment: NSTextAlignmentCenter];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview:l];
        l;
    });
    
    sldLineHeight = ({
        UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(m_inset + m_textWidth + m_swcWidth, verticalInset + m_segInset, m_segWidth - m_swcWidth, m_segHeight)];
        [s setMinimumValue: 8.0f];
        [s setMaximumValue: 32.0f];
        [s setValue:State.lineHeight];
        [s setEnabled: NO]; 
        [s addTarget:self action:@selector(sldLineHeightChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblHapticThres = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Feedback Thres:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview:l];
        l;
    });
    
    numHapticThres = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset + m_textWidth, verticalInset, m_swcWidth, m_textHeight)];
        [l setText: [NSString stringWithFormat:@"%.0f", State.maxFeedbackValue] ];
        [l setTextColor: m_textColor];
        [l setTextAlignment: NSTextAlignmentCenter];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview:l];
        l;
    });
    
    sldHapticThres = ({
        UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(m_inset + m_textWidth + m_swcWidth, verticalInset + m_segInset, m_segWidth - m_swcWidth, m_segHeight)];
        [s setMinimumValue: 100.0f];
        [s setMaximumValue: 127.0f];
        [s setValue: State.maxFeedbackValue];
        [s addTarget:self action:@selector(sldFeedbackThresChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblInsTTS = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Instruction TTS:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview: l];
        l;
    });
    
    segInsTTS =  ({
        NSArray *a = [NSArray arrayWithObjects:@"Male", @"Female", nil];
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems:a];
        [s setFrame:CGRectMake(m_inset + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight)];
        [s setSelectedSegmentIndex: State.instructionGender];
        [s addTarget:self action:@selector(segInsTTSChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblReadTTS = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Reading TTS:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview: l];
        l;
    });
    
    segReadingTTS =  ({
        NSArray *a = [NSArray arrayWithObjects:@"Male", @"Female", nil];
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems:a];
        [s setFrame:CGRectMake(m_inset + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight)];
        [s setSelectedSegmentIndex: State.readingGender];
        [s addTarget:self action:@selector(segReadingTTSChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblReadSpeed = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Reading Speed:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview: l];
        l;
    });
    
    sldReadingSpeed = ({
        UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(m_inset + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight)];
        [s setMinimumValue: 16.0f];
        [s setMaximumValue: 32.0f];
        [s setValue:32.0f];
        [s addTarget:self action:@selector(sldReadingSpeedChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblReadPitch = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Reading Pitch:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview: l];
        l;
    });
    
    swcReadPitch = ({
        UISwitch *s = [[UISwitch alloc] initWithFrame: CGRectMake(m_inset + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight) ];
        [s setOn: YES];
        [s addTarget:self action:@selector(swcReadPitchChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    }); ;
    
    verticalInset += m_textHeight;
    
    lblDebug = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Debug:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        l;
    }); [self.view addSubview:lblDebug];
    
    swcShowDebug = ({
        UISwitch *s = [[UISwitch alloc] initWithFrame: CGRectMake(m_inset + m_textWidth, verticalInset + m_segInset, m_segWidth, m_segHeight) ];
        [s setOn: State.debugMode];
        [self.view addSubview: s];
        [s addTarget:self action:@selector(swcShowDebugChanged:) forControlEvents:UIControlEventValueChanged];
        s;
    });
    
    txtLog = ({
        UITextView *v = [[UITextView alloc] initWithFrame: CGRectMake(m_inset, m_titleHeight + m_inset, (1024-m_inset) / 2, verticalInset - m_titleHeight)];
        [v setHidden: YES];
        [v setEditable: NO];
        [v setSelectable: NO];
        [self.view addSubview:v];
        v;
    });
    
    txtStat = ({
        UITextView *v = [[UITextView alloc] initWithFrame: CGRectMake(m_inset + (1024-m_inset) / 2, m_titleHeight + m_inset, (1024-m_inset) / 2, verticalInset - m_titleHeight)];
        [v setHidden: YES];
        [v setEditable: NO];
        [v setSelectable: NO];
        [self.view addSubview:v];
        v;
    });
    
    lblLog = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset + m_textWidth + m_segWidth, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Show Log & Stat:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        l;
    }); [self.view addSubview:lblLog];
    
    swcShowLog = ({
        UISwitch *s = [[UISwitch alloc] initWithFrame: CGRectMake(m_inset + m_textWidth + m_segWidth + m_textWidth, verticalInset + m_segInset, m_segWidth, m_swcWidth) ];
        [s setOn: NO];
        [s addTarget:self action:@selector(swcShowLogChanged:) forControlEvents:UIControlEventValueChanged];
        s;
    }); [self.view addSubview:swcShowLog];
    
    swcShowStat = ({
        UISwitch *s = [[UISwitch alloc] initWithFrame: CGRectMake(m_inset*2 + m_textWidth + m_segWidth + m_textWidth + m_swcWidth, verticalInset + m_segInset, m_segWidth, m_swcWidth) ];
        [s setOn: NO];
        [s addTarget:self action:@selector(swcShowStatChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview: s];
        s;
    });
    
    verticalInset += m_textHeight;
    
    lblDemo = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, verticalInset, m_textWidth, m_textHeight)];
        [l setText:@"Demo:"];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self.view addSubview: l];
        l;
    });
    
    CGFloat m_horizontalInset = m_inset + m_textWidth - 30;
    
    btnTaskStart = ({
        UIButton *b = [UIButton buttonWithType: UIButtonTypeSystem];
        [b setFrame: CGRectMake(m_horizontalInset, verticalInset + m_segInset, m_textWidth, m_textHeight)];
        
        [b setTitle:@"Task Start" forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(btnTaskStartTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: b];
        b;
    });
    
    m_horizontalInset += m_textWidth - 20;
    
    btnLineBegin = ({
        UIButton *b = [UIButton buttonWithType: UIButtonTypeSystem];
        [b setFrame: CGRectMake(m_horizontalInset, verticalInset + m_segInset, m_textWidth, m_textHeight)];
        [b setTitle:@"Line Begin" forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(btnLineBeginTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: b];
        b;
    });
    
    m_horizontalInset += m_textWidth - 20;
    
    btnLineEnd = ({
        UIButton *b = [UIButton buttonWithType: UIButtonTypeSystem];
        [b setFrame: CGRectMake(m_horizontalInset, verticalInset + m_segInset, m_textWidth, m_textHeight)];
        [b setTitle:@"Line End" forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(btnLineEndTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: b];
        b;
    });
    
    m_horizontalInset += m_textWidth;
    
    btnParaEnd = ({
        UIButton *b = [UIButton buttonWithType: UIButtonTypeSystem];
        [b setFrame: CGRectMake(m_horizontalInset, verticalInset + m_segInset, m_textWidth, m_textHeight)];
        [b setTitle:@"End of Paragraph" forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(btnParagraphEndTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:b];
        [self.view addSubview: b];
        b;
    });
    
    m_horizontalInset += m_textWidth;
    
    btnTextEnd = ({
        UIButton *b = [UIButton buttonWithType: UIButtonTypeSystem];
        [b setFrame: CGRectMake(m_horizontalInset, verticalInset + m_segInset, m_textWidth, m_textHeight)];
        [b setTitle:@"End of Text" forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(btnTextEndTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: b];
        b;
    });
    
    m_horizontalInset = m_inset + m_textWidth - 5;
    verticalInset += m_textHeight;
    
    btnAboveLine = ({
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(m_horizontalInset, verticalInset + m_segInset, m_textWidth, m_textHeight)];
        [b setTitle:@"Above the Line" forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.view addSubview: b];
        b;
    });
    
    m_horizontalInset += m_textWidth;
    
    sldAboveLine = ({
        UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(m_horizontalInset, verticalInset + m_segInset * 2, m_segWidth - m_textWidth, m_segHeight)];
        [s setMinimumValue: 0.0f];
        [s setMaximumValue: [State maxFeedbackValue]];
        [s addTarget:self action:@selector(sldAboveLineTouched) forControlEvents:UIControlEventValueChanged];
        [s addTarget:self action:@selector(sldAboveLineTouchCanceled) forControlEvents:UIControlEventTouchUpInside];
        [s addTarget:self action:@selector(sldAboveLineTouchCanceled) forControlEvents:UIControlEventTouchUpOutside];
        [s addTarget:self action:@selector(sldAboveLineTouchCanceled) forControlEvents:UIControlEventTouchCancel];
        [self.view addSubview: s];
        s;
    });
    
    m_horizontalInset = m_inset*2 + m_textWidth + m_segWidth;
    
    btnBelowLine = ({
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(m_horizontalInset, verticalInset + m_segInset, m_textWidth, m_textHeight)];
        [b setTitle:@"Below the Line" forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.view addSubview: b];
        b;
    });
    
    m_horizontalInset += m_textWidth;
    
    sldBelowLine = ({
        UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(m_horizontalInset, verticalInset + m_segInset * 2, m_segWidth - m_textWidth, m_segHeight)];
        [s setMinimumValue: 0.0f];
        [s setMaximumValue: [State maxFeedbackValue]];
        [s addTarget:self action:@selector(sldBelowLineTouched) forControlEvents:UIControlEventValueChanged];
        [s addTarget:self action:@selector(sldBelowLineTouchCanceled) forControlEvents:UIControlEventTouchUpInside];
        [s addTarget:self action:@selector(sldBelowLineTouchCanceled) forControlEvents:UIControlEventTouchUpOutside];
        [s addTarget:self action:@selector(sldBelowLineTouchCanceled) forControlEvents:UIControlEventTouchCancel];
        [self.view addSubview: s];
        s;
    });
    
    // Buttons
    btnReset = ({
        UIButton *b = [UIButton buttonWithType: UIButtonTypeSystem];
        [b setFrame: CGRectMake(m_btnLeft + m_inset * 2, m_btnTop, m_textWidth, m_textHeight)];
        
        [b setTitle:@"Reset" forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.view addSubview: b];
        b;
    });
    
    btnStart = ({
        UIButton *b = [UIButton buttonWithType: UIButtonTypeSystem];
        [b setFrame: CGRectMake(m_btnLeft + m_textWidth / 2 + m_inset * 2, m_btnTop, m_textWidth, m_textHeight)];
        [b setTitle:@"Start" forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b addTarget:self action:@selector(switchView) forControlEvents:UIControlEventTouchUpInside];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
         [self.view addSubview: b];
        b;
    });
    
}

- (void)switchView
{
    NSLog(@"[CP] Switch View to %d", State.categoryType);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CommonTextController *viewController;
    
    switch (State.categoryType) {
        case CT_PLAIN:
            viewController = (CommonTextController *)[storyboard instantiateViewControllerWithIdentifier:@"TextController"];
            break;
        case CT_MAGAZINE:
            viewController = (CommonTextController *)[storyboard instantiateViewControllerWithIdentifier:@"MagController"];
            break;
        case CT_MENU:
            viewController = (CommonTextController *)[storyboard instantiateViewControllerWithIdentifier:@"MenuController"];
            break;
    }
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)btnTaskStartTouched
{
    [Speech speakText: [State insStartPlain]];
}

- (void)btnLineBeginTouched
{
    [Feedback lineBegin];
}

- (void)btnLineEndTouched
{
    State.thisLineHasAtLeastOneWordSpoken = true;
    [Feedback lineEnd];
}

- (void)btnParagraphEndTouched
{
    [Feedback paraEnd];
}

- (void)btnTextEndTouched
{
    [Speech speakText: [State insEndPlain]];
    
}

- (void)sldAboveLineTouched
{
    [Feedback verticalStart: [sldAboveLine value]];
}

- (void)sldAboveLineTouchCanceled
{
    [Feedback verticalStop];
}

- (void)sldBelowLineTouched
{
    [Feedback verticalStart: -[sldBelowLine value]];
}

- (void)sldBelowLineTouchCanceled
{
    [Feedback verticalStop];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
