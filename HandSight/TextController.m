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
    
    [super addControls];
}

@end
