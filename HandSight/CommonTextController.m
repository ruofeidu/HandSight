//
//  CommonTextController.m
//  HandSight
//
//  Created by Ruofei Du on 8/12/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "CommonTextController.h"

@interface CommonTextController ()

@end

@implementation CommonTextController

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
    [self addControls];
}

- (void)reset
{
    NSLog(@"[CTC] Reset");
    [super reset];
    m_btnLeft = 800, m_btnTop = 720;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addControls
{
    if (m_btnBack != nil) {
        [m_btnBack removeFromSuperview];
    }
    m_btnBack = ({
        UIButton *b = [UIButton buttonWithType: UIButtonTypeSystem];
        [b setFrame: CGRectMake(m_btnLeft + m_textWidth / 2 + m_inset * 2, m_btnTop, m_textWidth, m_textHeight)];
        [b setTitle:@"Back" forState: UIControlStateNormal];
        [[b titleLabel] setFont:[UIFont fontWithName:m_textFontName size:m_textFontSize]];
        [b addTarget:self action:@selector(switchView) forControlEvents:UIControlEventTouchUpInside];
        [b setTitleColor:m_textColor forState: UIControlStateNormal ];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        b;
    }); [self.view addSubview:m_btnBack];
    
}

- (void)switchView
{
    NSLog(@"[CP] Switch View");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommonController *viewController = (CommonController *)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
