//
//  CommonController.m
//  HandSight
//
//  Created by Ruofei Du on 7/16/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "CommonController.h"

@interface CommonController ()

@end

@implementation CommonController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideStatusBar];
    [self reset];
}

- (void)reset
{
    //NSLog(@"[CC] Reset");
    m_inset = 20;
    m_titleFontSize = 38, m_textFontSize = 17;
    m_titleHeight = 44, m_textHeight = 38, m_titleWidth = 360, m_textWidth = 140, m_segWidth = 360, m_segHeight = 26, m_segInset = 5, m_swcWidth = 60;
    m_btnLeft = 800, m_btnTop = 720;
    m_titleFontName = @"Savoye LET", m_textFontName = @"Palatino";
    m_textColor = [UIColor colorWithRed:(CGFloat)86/256 green:(CGFloat)138/256 blue:(CGFloat)251/256 alpha:1.0];
    
    Feedback = [HSFeedback sharedInstance];
    Speech = [HSSpeech sharedInstance];
    State = [HSState sharedInstance];
    Log = [HSLog sharedInstance];
    Stat = [HSStat sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void) hideStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}


- (void) addControls
{


}

- (void)switchView
{
}


@end
