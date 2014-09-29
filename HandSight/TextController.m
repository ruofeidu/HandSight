//
//  TextController.m
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "TextController.h"
#import "HSMagView.h"

@interface TextController ()

@end

@implementation TextController

- (void)reset
{
    [super reset];
}

- (void)addControls
{
    if (m_text != nil) [m_text removeFromSuperview];
    if (m_viz != nil) [m_viz removeFromSuperview];
    if (m_label != nil) [m_label removeFromSuperview];
    if (m_seg != nil) [m_seg removeFromSuperview];
    
    m_text = ({
        HSTextView *t = [HSTextView sharedInstance];
        [t loadDocument];
        [self.view addSubview:t];
        t;
    });
    
    m_viz = ({
        HSViz *v = [HSViz sharedInstance];
        [v reset];
        [self.view addSubview:v];
        v;
    });
    
    m_label = ({
        HSStatLabel *l = [HSStatLabel sharedInstance];
        [self.view addSubview:l];
        l;
    });
    
    m_seg = ({
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:@"Off", @"Vertical Respond", @"Line Signal", @"Paragraph", @"Speech", nil]];
        [s setFrame: CGRectMake(m_inset * 2, m_btnTop, m_segWidth * 1.5, m_textHeight)];
        [s setSelectedSegmentIndex: State.feedbackStepByStep];
        [self.view addSubview:s];
        [s addTarget:self action: @selector(segChanged:) forControlEvents: UIControlEventValueChanged];

        s;
    });
    
    if (State.feedbackStepByStep == Step0) {
        [m_seg setHidden: YES];
    } else {
        [m_seg setHidden: NO];
        [m_label setHidden: YES]; 
    }

    [super addControls];
}

- (void)segChanged: (id)sender
{
    State.feedbackStepByStep = [m_seg selectedSegmentIndex]; 
}


@end
