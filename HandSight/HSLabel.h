//
//  HSLabel.h
//  HandSight
//
//  Created by Ruofei Du on 7/29/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UILabel (HandSight)

-(BOOL) contains: (CGPoint) point;

@end


// Detail Mode
/*
 CGPoint offset =
 point.x -= offset.x;        point.y -= offset.y;
 
 NSTextContainer* container = [[self.layoutManager textContainers] objectAtIndex:col];
 CGFloat dist;
 NSRange range;
 NSUInteger characterIndex = [self.layoutManager characterIndexForPoint:point inTextContainer:container fractionOfDistanceBetweenInsertionPoints:&dist];
 
 [self.textStorage attributesAtIndex:characterIndex effectiveRange:&range];
 
 CGRect rect = [self.layoutManager boundingRectForGlyphRange:range inTextContainer:container];
 //[self.layoutManager layoutRectForTextBlock: range];
 rect.origin.x += offset.x + m_wordMargin.origin.x;
 rect.origin.y += offset.y + m_wordMargin.origin.y;
 
 rect.size.width -= m_wordMargin.size.width;
 rect.size.height -= m_wordMargin.size.height;
 
 
 NSLog(@"[ST] C%d-%lu ~%.2f %@", col, (unsigned long)characterIndex, dist, NSStringFromCGRect(rect));
 
 [lblCurrent setFrame:rect];
 [lblCurrent setHidden:NO];
 */


/*
 CGRect frame = [self frameOfTextRange:range inTextView:view];
 NSLog(@"[ST] text view frame: %@", NSStringFromCGRect([view frame]));
 
 NSLog(@"[ST] C%d-%lu ~%.2f %@", col, (unsigned long)characterIndex, dist, NSStringFromCGRect(frame));
 
 [lblCurrent setFrame:frame];
 */

/*
 
 
 /*
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
 */

/*
y += m_textHeight;

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
    UILabel *l = [[UILabel alloc] initWithFrame: CGRectMake(m_inset, y, m_textWidth, m_textHeight)];
    [l setText:@"Max Vibration:"];
    [l setTextColor: m_textColor];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    [self.view addSubview: l];
    l;
});

numMaxVibration = ({
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset + m_textWidth, y, m_swcWidth, m_textHeight)];
    [l setText: [NSString stringWithFormat:@"%.0f", State.maxFeedbackValue] ];
    [l setTextColor: m_textColor];
    [l setTextAlignment: NSTextAlignmentCenter];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    [self.view addSubview:l];
    l;
});

sldMaxVibration = ({
    UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(m_inset + m_textWidth + m_swcWidth, y + m_segInset, m_segWidth - m_swcWidth, m_segHeight)];
    [s setMinimumValue: 0.1f];
    [s setMaximumValue: 1.0f];
    [s setValue: State.maxVibration];
    
    [s addTarget:self action:@selector(sldLineHeightChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: s];
    s;
});

y += m_textHeight;

lblLineHeight = ({
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, y, m_textWidth, m_textHeight)];
    [l setText:@"Line Height:"];
    [l setTextColor: m_textColor];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    l;
}); [self.view addSubview:lblLineHeight];

numLineHeights = ({
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset + m_textWidth, y, m_swcWidth, m_textHeight)];
    [l setText: [NSString stringWithFormat:@"%.0f", State.lineHeight] ];
    [l setTextColor: m_textColor];
    [l setTextAlignment: NSTextAlignmentCenter];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    [self.view addSubview:l];
    l;
});

sldLineHeight = ({
    UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(m_inset + m_textWidth + m_swcWidth, y + m_segInset, m_segWidth - m_swcWidth, m_segHeight)];
    [s setMinimumValue: 8.0f];
    [s setMaximumValue: 32.0f];
    [s setValue:State.lineHeight];
    [s setEnabled: NO];
    [s addTarget:self action:@selector(sldLineHeightChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: s];
    s;
});

y += m_textHeight;

lblHapticThres = ({
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, y, m_textWidth, m_textHeight)];
    [l setText:@"Feedback Thres:"];
    [l setTextColor: m_textColor];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    [self.view addSubview:l];
    l;
});

numHapticThres = ({
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset + m_textWidth, y, m_swcWidth, m_textHeight)];
    [l setText: [NSString stringWithFormat:@"%.0f", State.maxFeedbackValue] ];
    [l setTextColor: m_textColor];
    [l setTextAlignment: NSTextAlignmentCenter];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    [self.view addSubview:l];
    l;
});

sldHapticThres = ({
    UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(m_inset + m_textWidth + m_swcWidth, y + m_segInset, m_segWidth - m_swcWidth, m_segHeight)];
    [s setMinimumValue: 100.0f];
    [s setMaximumValue: 127.0f];
    [s setValue: State.maxFeedbackValue];
    [s addTarget:self action:@selector(sldFeedbackThresChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:s];
    s;
});

y += m_textHeight;

lblInsTTS = ({
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, y, m_textWidth, m_textHeight)];
    [l setText:@"Instruction TTS:"];
    [l setTextColor: m_textColor];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    [self.view addSubview: l];
    l;
});

segInsTTS =  ({
    NSArray *a = [NSArray arrayWithObjects:@"Male", @"Female", nil];
    UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems:a];
    [s setFrame:CGRectMake(m_inset + m_textWidth, y + m_segInset, m_segWidth, m_segHeight)];
    [s setSelectedSegmentIndex: State.instructionGender];
    [s addTarget:self action:@selector(segInsTTSChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: s];
    s;
});

y += m_textHeight;

lblReadTTS = ({
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, y, m_textWidth, m_textHeight)];
    [l setText:@"Reading TTS:"];
    [l setTextColor: m_textColor];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    [self.view addSubview: l];
    l;
});

segReadingTTS =  ({
    NSArray *a = [NSArray arrayWithObjects:@"Male", @"Female", nil];
    UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems:a];
    [s setFrame:CGRectMake(m_inset + m_textWidth, y + m_segInset, m_segWidth, m_segHeight)];
    [s setSelectedSegmentIndex: State.readingGender];
    [s addTarget:self action:@selector(segReadingTTSChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: s];
    s;
});

y += m_textHeight;

lblReadSpeed = ({
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, y, m_textWidth, m_textHeight)];
    [l setText:@"Reading Speed:"];
    [l setTextColor: m_textColor];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    [self.view addSubview: l];
    l;
});

sldReadingSpeed = ({
    UISlider *s = [[UISlider alloc] initWithFrame: CGRectMake(m_inset + m_textWidth, y + m_segInset, m_segWidth, m_segHeight)];
    [s setMinimumValue: 16.0f];
    [s setMaximumValue: 32.0f];
    [s setValue:32.0f];
    [s addTarget:self action:@selector(sldReadingSpeedChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: s];
    s;
});

y += m_textHeight;

lblReadPitch = ({
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, y, m_textWidth, m_textHeight)];
    [l setText:@"Reading Pitch:"];
    [l setTextColor: m_textColor];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    [self.view addSubview: l];
    l;
});

swcReadPitch = ({
    UISwitch *s = [[UISwitch alloc] initWithFrame: CGRectMake(m_inset + m_textWidth, y + m_segInset, m_segWidth, m_segHeight) ];
    [s setOn: YES];
    [s addTarget:self action:@selector(swcReadPitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: s];
    s;
}); ;

y += m_textHeight;

lblDebug = ({
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset, y, m_textWidth, m_textHeight)];
    [l setText:@"Debug:"];
    [l setTextColor: m_textColor];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    l;
}); [self.view addSubview:lblDebug];

swcShowDebug = ({
    UISwitch *s = [[UISwitch alloc] initWithFrame: CGRectMake(m_inset + m_textWidth, y + m_segInset, m_segWidth, m_segHeight) ];
    [s setOn: State.debugMode];
    [self.view addSubview: s];
    [s addTarget:self action:@selector(swcShowDebugChanged:) forControlEvents:UIControlEventValueChanged];
    s;
});

txtLog = ({
    UITextView *v = [[UITextView alloc] initWithFrame: CGRectMake(m_inset, m_titleHeight + m_inset, (1024-m_inset) / 2, y - m_titleHeight)];
    [v setHidden: YES];
    [v setEditable: NO];
    [v setSelectable: NO];
    [self.view addSubview:v];
    v;
});

txtStat = ({
    UITextView *v = [[UITextView alloc] initWithFrame: CGRectMake(m_inset + (1024-m_inset) / 2, m_titleHeight + m_inset, (1024-m_inset) / 2, y - m_titleHeight)];
    [v setHidden: YES];
    [v setEditable: NO];
    [v setSelectable: NO];
    [self.view addSubview:v];
    v;
});

lblLog = ({
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_inset + m_textWidth + m_segWidth, y, m_textWidth, m_textHeight)];
    [l setText:@"Show Log & Stat:"];
    [l setTextColor: m_textColor];
    [l setFont: [UIFont fontWithName:m_textFontName size:m_textFontSize]];
    l;
}); [self.view addSubview:lblLog];

swcShowLog = ({
    UISwitch *s = [[UISwitch alloc] initWithFrame: CGRectMake(m_inset + m_textWidth + m_segWidth + m_textWidth, y + m_segInset, m_segWidth, m_swcWidth) ];
    [s setOn: NO];
    [s addTarget:self action:@selector(swcShowLogChanged:) forControlEvents:UIControlEventValueChanged];
    s;
}); [self.view addSubview:swcShowLog];

swcShowStat = ({
    UISwitch *s = [[UISwitch alloc] initWithFrame: CGRectMake(m_inset*2 + m_textWidth + m_segWidth + m_textWidth + m_swcWidth, y + m_segInset, m_segWidth, m_swcWidth) ];
    [s setOn: NO];
    [s addTarget:self action:@selector(swcShowStatChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: s];
    s;
});

y += m_textHeight;

*/