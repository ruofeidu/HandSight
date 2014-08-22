//
//  MagController.m
//  HandSight
//
//  Created by Ruofei Du on 7/17/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "MagController.h"

@interface MagController ()

@end

@implementation MagController

- (void)reset
{
    [super reset];
}

- (void)addControls
{
    
    if (m_text != nil) [m_text removeFromSuperview];
    if (m_viz != nil) [m_viz removeFromSuperview];
    
    m_text = ({
        HSMagView *t = [HSMagView sharedInstance];
        [t loadDocument];
        [self.view addSubview:t];
        t;
    });
    
    
    m_viz = ({
        HSViz *v = [HSViz sharedInstance];
        [v reset];
        v;
    });
    
    [super addControls];
}

@end
