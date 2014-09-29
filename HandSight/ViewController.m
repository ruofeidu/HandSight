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

- (void)addControls
{
    x = m_inset, y = m_inset; m_render = YES;
    
    lblExplorationStudy =   [self allocTitle:lblExplorationStudy withText:@"HandSight Exploration Study"];
    [self lineBreak];
    
    lblExpCues          =   [self allocLabel:lblExpCues withText:@"Cues:"];
    btnExpText          =   [self allocHoldButton:btnExpText text:@"Text" touchDown:@selector(btnExpTextDown:) touchUp:@selector(btnExpUp:)];   [self addSpace];
    btnExpPicture       =   [self allocHoldButton:btnExpPicture text:@"Picture" touchDown:@selector(btnExpPicture:) touchUp:@selector(btnExpUp:)]; x = m_inset + m_textWidth + m_segWidth; [self addSpace];
    [self lineBreak];
    
    lblExpDoc           =   [self allocLabel:lblExpDoc withText:@"Document:"];
    segExpDoc           =   [self allocSegmentation:segExpDoc arr:[NSArray arrayWithObjects:@"1: Plain", @"2: Magazine", nil] select:[State expDocType] action:@selector(segExpDocChanged:)];
    [self lineBreak];
    
    y                  +=   m_inset;
    lblReadingStudy     =   [self allocTitle:lblReadingStudy withText:@"HandSight Reading Study"];
    [self lineBreak];
    
    lblFeedbackType     =   [self allocLabel:lblFeedbackType withText:@"Feedback Type: "];
    segFeedback         =   [self allocSegmentation:segFeedback arr:[NSArray arrayWithObjects:@"Audio", @"Haptio", nil] select:[State feedbackType] action: @selector(segFeedbackChanged:)]; [self addSpace];
    segBluetoothState   =   [self allocSegmentation:segBluetoothState arr:[NSArray arrayWithObjects:@"BT Off", @"Connecting", @"BT On", nil] select:[State bluetoothState] action:nil];
    [self lineBreak];
    
    [self allocLabel:lblDemo withText:@"Cues:"];
    x -= 30;
    btnTaskStart        =   [self allocButton:btnTaskStart text:@"Task Start" action:@selector(btnTaskStartTouched)];
    btnLineBegin        =   [self allocButton:btnLineBegin text:@"Line Begin" action:@selector(btnLineBeginTouched)];
    btnLineEnd          =   [self allocButton:btnLineEnd text:@"Line End" action:@selector(btnLineEndTouched)]; x += 20;
    btnParaEnd          =   [self allocButton:btnParaEnd text:@"End of Paragraph" action:@selector(btnParagraphEndTouched)]; x += 20;
    btnTextEnd          =   [self allocButton:btnTextEnd text:@"End of Text" action:@selector(btnTextEndTouched)]; x += 20;
    
    [self lineBreak];
    x += m_textWidth;
    lblAboveLine        =   [self allocLabel:lblAboveLine withText:@"Above the line"]; y += 8;
    sldAboveLine        =   [self allocSlider:sldAboveLine min:0.0f max:State.maxFeedbackValue down:@selector(sldAboveLineTouched) up:@selector(sldAboveLineTouchCanceled)]; y -= 8; [self addSpace];
    lblBelowLine        =   [self allocLabel:lblBelowLine withText:@"Below the line"]; y += 8;
    sldBelowLine        =   [self allocSlider:sldBelowLine min:0.0f max:State.maxFeedbackValue down:@selector(sldBelowLineTouched) up:@selector(sldBelowLineTouchCanceled)]; y -= 8;
    [self lineBreak];
    
    lblFeedbackTrain    =   [self allocLabel:lblFeedbackTrain withText:@"Feedback:"];
    segFeedbackStep    =   [self allocSegmentation:segPlainDoc arr:[NSArray arrayWithObjects:@"Feedback Training Step by Step", nil] select:[State feedbackTrainType] action: @selector(segFeedbackStepChanged:)]; [self addSpace]; [self addSpace];
    segFeedbackTrain    =   [self allocSegmentation:segPlainDoc arr:[NSArray arrayWithObjects:@"Feedback Training Document", nil] select:[State feedbackTrainType] action: @selector(segFeedbackTrainChanged:)]; [self addSpace];
    [self lineBreak];
    
    
    lblPlainDoc         =   [self allocLabel:lblPlainDoc withText:@"Plain:"];
    segPlainDoc         =   [self allocSegmentation:segPlainDoc arr:[NSArray arrayWithObjects:@"1", @"2", nil] select:[State plainDocType] action: @selector(segPlainDocChanged:)]; [self addSpace];
    [self lineBreak];
    
    lblMagDoc           =   [self allocLabel:lblMagDoc withText:@"Magazine:"];
    segMagDoc           =   [self allocSegmentation:segMagDoc arr:[NSArray arrayWithObjects:@"1", @"2", nil] select:[State magDocType] action: @selector(segMagDocChanged:)]; [self addSpace];
    [self lineBreak];

    //m_render = NO;
    y += m_inset;
    lblSpeedTest        =   [self allocTitle:lblAdvanced withText:@"Speed Test"];
    [self lineBreak];
    
    lblSpeed            =   [self allocLabel:lblSpeed withText:@"Document"];
    segSpeed            =   [self allocSegmentation:segSpeed arr:[NSArray arrayWithObjects:@"Train", @"1", @"2", @"3", @"4", nil] select:[State speedType] action: @selector(segSpeedChanged:)];  [self addSpace];
    lblSpeech           =   [self allocLabel:lblSpeech withText:@"Speech:"];
    swcSpeech           =   [self allocSwitch:swcSpeech isOn:State.speechOn action:@selector(swcSpeechChanged:)];
    
    [self lineBreak];
    
    y += m_inset;
    m_render = YES;
    lblAdvanced         =   [self allocTitle:lblAdvanced withText:@"Advanced Debug Panel"];
    [self lineBreak];
    
    lblDocument         =   [self allocLabel:lblDocument withText:@"Document:"];
    segCategory         =   [self allocSegmentation:segCategory arr:[NSArray arrayWithObjects:@"Plain", @"Magazine", nil] select:[State categoryType] action: @selector(segCateboryChanged:)]; [self addSpace];
    segDocument         =   [self allocSegmentation:segDocument arr:[NSArray arrayWithObjects:@"Train", @"1", @"2", @"3", @"4", nil] select:[State documentType] action: @selector(segDocumentChanged:)];
    x = m_inset + m_textWidth;
    [segCategory setFrame:CGRectMake(x, y + m_segInset, m_segWidth / 5 * 2 - m_inset / 2, m_segHeight)]; x += m_segWidth / 3 + m_inset;
    [segDocument setFrame:CGRectMake(x, y + m_segInset, m_segWidth / 5 * 3, m_segHeight)]; x += segDocument.frame.size.width; [self addSpace];
    
    segMode             =   [self allocSegmentation:segMode arr:[NSArray arrayWithObjects:@"Exploration", @"Reading", @"Sighted", nil] select:[State mode] action:@selector(modeChanged:)];
    [self lineBreak];
    
    m_render = NO;
    lblInsTTS           =   [self allocLabel:lblInsTTS withText:@"Ins/Read TTS:"];
    segInsTTS           =   [self allocSegmentation:segInsTTS arr:[NSArray arrayWithObjects:@"Male", @"Female", nil] select:[State instructionGender] action: @selector(segInsTTSChanged:)]; [self addSpace];
    [self lineBreak];
    m_render = YES;
    
    lblDebug            =   [self allocLabel:lblDebug withText:@"Debug:"];
    swcShowDebug        =   [self allocSwitch:swcShowDebug isOn:State.debugMode action:@selector(swcShowDebugChanged:)];
    
    x = m_inset * 2 + m_textWidth + m_segWidth;
    lblLog              =   [self allocLabel:lblLog withText:@"Show Log & Stat:"];
    swcShowLog          =   [self allocSwitch:swcShowLog isOn:State.showLog action:@selector(swcShowLogChanged:)];
    swcShowStat         =   [self allocSwitch:swcShowStat isOn:State.showStat action:@selector(swcShowStatChanged:)];
    txtLog              =   [self allocTextView:txtLog rect: CGRectMake(m_inset, m_titleHeight + m_inset, (1024-m_inset) / 2, y - m_titleHeight)];
    txtStat             =   [self allocTextView:txtStat rect: CGRectMake(m_inset + (1024-m_inset) / 2, m_titleHeight + m_inset, (1024-m_inset) / 2, y - m_titleHeight)];
    
    m_render            =   YES; 
    btnReset            =   [self allocButton:btnReset text:@"Reset" action:@selector(reset)];
    btnStart            =   [self allocButton:btnStart text:@"Start" action:@selector(switchView)];
    
    [btnReset setFrame: CGRectMake(m_btnLeft + m_inset * 2, m_btnTop, m_textWidth, m_textHeight)];
    [btnStart setFrame: CGRectMake(m_btnLeft + m_textWidth / 2 + m_inset * 2, m_btnTop, m_textWidth, m_textHeight)];
    
    [self updateDocuments];
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
    [Feedback verticalFeedback: [sldAboveLine value]];
}

- (void)sldAboveLineTouchCanceled
{
    [Feedback verticalStop];
}

- (void)sldBelowLineTouched
{
    [Feedback verticalFeedback: -[sldBelowLine value]];
}

- (void)sldBelowLineTouchCanceled
{
    [Feedback verticalStop];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


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
    [self updateDocuments];
}

- (void)segSpeedChanged: (id)sender
{
    NSInteger index = [segSpeed selectedSegmentIndex];
    if (index == 0) State.documentType = DT_D; else State.documentType = (enum DocumentType) (index - 1);
    
    State.categoryType = CT_PLAIN;
    State.mode = MD_SIGHTED;
    
    [self updateDocuments];
}

- (void)segDocumentChanged: (id)sender
{
    State.documentType = (enum DocumentType) [segDocument selectedSegmentIndex];
    [self updateDocuments];
}

- (void)segExpDocChanged: (id)sender
{
    State.mode = MD_EXPLORATION_TEXT;
    State.expDocType =  (enum ExpDocType) [segExpDoc selectedSegmentIndex];
    
    switch (State.expDocType) {
        case ED_1:
            State.categoryType = CT_PLAIN;
            break;
        case ED_2:
            State.categoryType = CT_MAGAZINE;
        default:
            break;
    }
    State.documentType = DT_TRAIN;
    [self updateDocuments];
}


- (void)segPlainDocChanged: (id)sender {
    State.plainDocType = (enum PlainDocType) ([segPlainDoc selectedSegmentIndex] + 1);
    State.documentType = (enum DocumentType) ([segPlainDoc selectedSegmentIndex] + 1);
    State.categoryType = CT_PLAIN;
    State.mode = MD_READING;
    [self updateDocuments];
}

- (void)segMagDocChanged: (id)sender {
    State.magDocType = (enum MagazineDocType) ([segMagDoc selectedSegmentIndex] + 1);
    State.documentType = (enum DocumentType) ([segMagDoc selectedSegmentIndex] + 1);
    State.categoryType = CT_MAGAZINE;
    State.mode = MD_READING;
    [self updateDocuments];
}

- (void)segFeedbackTrainChanged: (id)sender {
    State.documentType = DT_D;
    State.categoryType = CT_PLAIN;
    State.mode = MD_READING;
     State.feedbackStepByStep = Step0;
    [self updateDocuments];
}

- (void) segFeedbackStepChanged:(id)sender {
    State.documentType = DT_D;
    State.categoryType = CT_PLAIN;
    State.mode = MD_READING;
    State.feedbackStepByStep = StepVertical;
    [self updateDocuments];
    State.feedbackStepByStep = StepVertical;
}

- (void)btnExpTextDown: (id)sender
{
    [Feedback overTitle];
}

- (void)btnExpUp: (id)sender
{
    [Feedback overSpacing];
}

- (void)btnExpPicture: (id)sender
{
    [Feedback overPicture];
}

- (void)modeChanged: (id)sender
{
    State.mode = (enum ModeType) [segMode selectedSegmentIndex];
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


- (void)swcSpeechChanged: (id)sender
{
    State.speechOn = [swcSpeech isOn];
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

- (void) addView: (UIView*) v {
    if (!m_render) [v setHidden: YES];
    [self.view addSubview: v];
}

/**
 * Alloc a label
 * Factory method
 */
- (UILabel*) allocLabel: (UILabel*) label  withText: (NSString*) text {
    if (label != nil) return label;
    label = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, m_textWidth, m_textHeight)];
        x += m_textWidth;
        [l setText: text];
        [l setTextColor: m_textColor];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [self addView: l];
        l;
    });
    return label;
}

- (UILabel*) allocTitle: (UILabel*)label withText:(NSString*) text{
    if (label != nil) return label;
    label = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, m_titleWidth, m_titleHeight)];
        x += m_textWidth;
        [l setText: text];
        [l setTextColor: [UIColor blackColor]];
        [l setFont: [UIFont fontWithName:m_titleFontName size:m_titleFontSize]];
        [self addView: l];
        l;
    });
    return label;
}

- (UISegmentedControl*) allocSegmentation: (UISegmentedControl*) seg  arr:(NSArray*)arr select:(NSInteger)index action:(SEL)action {
    if (seg != nil) {
        [seg setSelectedSegmentIndex:index];
        return seg;
    }
    seg = ({
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems: arr];
        [s setFrame:CGRectMake(x, y + m_segInset, m_segWidth, m_segHeight)];
        x += m_segWidth;
        [s setSelectedSegmentIndex: index];
        if (action != nil) [s addTarget:self action:action forControlEvents: UIControlEventValueChanged];
        [self addView: s];
        s;
    });
    return seg;
}

- (UIButton*) allocButton:(UIButton*)btn  text:(NSString*)text action:(SEL)action {
    if (btn != nil) return btn;
    
    btn = ({
        UIButton *b = [UIButton buttonWithType: UIButtonTypeSystem];
        [b setFrame: CGRectMake(x, y, m_textWidth, m_textHeight)];
        x += m_textWidth - 20;
        [b setTitle:text forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [self addView: b];
        b;
    });
    
    return btn;
}

- (UIButton*) allocHoldButton:(UIButton*)btn  text:(NSString*)text touchDown:(SEL)down touchUp:(SEL)up {
    if (btn != nil) return btn;
    
    btn = ({
        UIButton *b = [UIButton buttonWithType: UIButtonTypeSystem];
        [b setFrame: CGRectMake(x, y, m_textWidth, m_textHeight)];
        x += m_textWidth;
        [b setTitle:text forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:down forControlEvents:UIControlEventTouchDown];
        [b addTarget:self action:up forControlEvents:UIControlEventTouchUpInside];
        [b addTarget:self action:up forControlEvents:UIControlEventTouchUpOutside];
        [b addTarget:self action:up forControlEvents:UIControlEventTouchCancel];
        [self addView: b];
        b;
    });
    return btn;
}

- (UISlider*) allocSlider:(UISlider*)sld min:(CGFloat)min max:(CGFloat)max down:(SEL)down up:(SEL)up {
    if (sld != nil) return sld;
    
    sld = ({
        UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(x, y, m_segWidth - m_textWidth, m_segHeight)];
        x += m_segWidth - m_textWidth;
        [s setMinimumValue: min];
        [s setMaximumValue: max];
        [s setValue: max]; 
        [s addTarget:self action:down forControlEvents:UIControlEventTouchDown];
        [s addTarget:self action:down forControlEvents:UIControlEventValueChanged];
        [s addTarget:self action:up forControlEvents:UIControlEventTouchUpInside];
        [s addTarget:self action:up forControlEvents:UIControlEventTouchUpOutside];
        [s addTarget:self action:up forControlEvents:UIControlEventTouchCancel];
        [self addView: s];
        s;
        
    });
    return sld;
}

- (UISwitch*) allocSwitch:(UISwitch*)swc isOn:(BOOL)isOn action:(SEL)action{
    if (swc != nil) return swc;
    
    swc = ({
        UISwitch *s = [[UISwitch alloc] initWithFrame: CGRectMake(x, y, m_swcWidth, m_swcWidth) ];
        x += m_swcWidth;
        [s setOn: isOn];
        [s addTarget:self action:action forControlEvents:UIControlEventValueChanged];
        [self addView: s];
        s;
    });
    return swc;
}


- (UITextView*) allocTextView:(UITextView*)view rect:(CGRect)rect{
    if (view != nil) return view;
    
    view = ({
        UITextView *v = [[UITextView alloc] initWithFrame:rect];
        [v setHidden: YES];
        [v setEditable: NO];
        [v setSelectable: NO];
        [self addView: v];
        v;
    });
    return view;
}

- (void) lineBreak {
    if (m_render) y += m_titleHeight; x = m_inset;
}

- (void) addSpace {
    x += m_inset;
}

- (void) updateDocuments {
    switch (State.mode) {
        case MD_EXPLORATION_TEXT:
            State.feedbackTrainType = FTT_NONE;
            if (State.documentType == DT_TRAIN) {
                State.plainDocType = PD_NONE;
                State.magDocType = MD_NONE;
                
                if (State.categoryType == CT_PLAIN) {
                    State.expDocType = ED_1;
                } else
                    if (State.categoryType == CT_MAGAZINE) {
                        State.expDocType = ED_2;
                    }
                [segExpDoc setSelectedSegmentIndex: State.expDocType];
            }
            break;
            
        case MD_READING:
            State.expDocType = ED_NONE;
            
            if (State.categoryType == CT_PLAIN) {
                if (State.documentType == DT_D) {
                    State.feedbackTrainType = FTT_TRAIN;
                    State.plainDocType = PD_NONE;
                } else {
                    State.feedbackTrainType = FTT_NONE;
                    State.plainDocType = (enum PlainDocType) State.documentType;
                }
                State.magDocType = MD_NONE;
            } else
                State.feedbackTrainType = FTT_NONE;
                if (State.categoryType == CT_MAGAZINE) {
                    State.plainDocType = PD_NONE;
                    State.magDocType = (enum MagazineDocType) State.documentType;
                }
            break;
            
        case MD_SIGHTED:
            State.feedbackTrainType = FTT_NONE;
            State.expDocType = ED_NONE;
            State.plainDocType = PD_NONE;
            State.magDocType = MD_NONE;
            State.categoryType = CT_PLAIN;
            if (State.documentType == DT_D) {
                State.speedType = ST_TRAIN;
            } else {
                State.speedType = (enum SpeedType) (State.documentType + 1);
            }
            break;
            
        default:
            break;
    }
    
    [segExpDoc setSelectedSegmentIndex: State.expDocType];
    [segMagDoc setSelectedSegmentIndex: State.magDocType - 1];
    [segPlainDoc setSelectedSegmentIndex: State.plainDocType - 1];
    [segSpeed setSelectedSegmentIndex: State.speedType];
    [segFeedbackTrain setSelectedSegmentIndex: State.feedbackTrainType];
    
    
    if (State.feedbackTrainType == FTT_NONE) [segFeedbackTrain setSelectedSegmentIndex: UISegmentedControlNoSegment];
    
    if (State.feedbackStepByStep == Step0) [segFeedbackStep setSelectedSegmentIndex: UISegmentedControlNoSegment]; else {
        [segFeedbackStep setSelectedSegmentIndex: 0];
        [segFeedbackTrain setSelectedSegmentIndex: UISegmentedControlNoSegment];
    }
    if (State.expDocType == ED_NONE) [segExpDoc setSelectedSegmentIndex: UISegmentedControlNoSegment];
    if (State.magDocType == MD_NONE) [segMagDoc setSelectedSegmentIndex: UISegmentedControlNoSegment];
    if (State.plainDocType == PD_NONE) [segPlainDoc setSelectedSegmentIndex: UISegmentedControlNoSegment];

    [segCategory setSelectedSegmentIndex:State.categoryType];
    [segDocument setSelectedSegmentIndex:State.documentType];
    [segMode setSelectedSegmentIndex:State.mode];
    
    State.feedbackType = Step0;
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

@end
