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
    NSLog(@"[CP] Exit to Control Panel");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommonController *viewController = (CommonController *)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSArray*) keyCommands {
    UIKeyCommand *esc = [UIKeyCommand keyCommandWithInput: UIKeyInputEscape modifierFlags: 0 action: @selector(esc:)];
    UIKeyCommand *down = [UIKeyCommand keyCommandWithInput: UIKeyInputDownArrow modifierFlags: 0 action: @selector(down:)];
    UIKeyCommand *up = [UIKeyCommand keyCommandWithInput: UIKeyInputUpArrow modifierFlags: 0 action: @selector(up:)];
    UIKeyCommand *left = [UIKeyCommand keyCommandWithInput: UIKeyInputLeftArrow modifierFlags: 0 action: @selector(left:)];
    UIKeyCommand *right = [UIKeyCommand keyCommandWithInput: UIKeyInputRightArrow modifierFlags: 0 action: @selector(right:)];
    
    
    UIKeyCommand *k0 = [UIKeyCommand keyCommandWithInput: @"0" modifierFlags: 0 action: @selector(k0:)];
    UIKeyCommand *k1 = [UIKeyCommand keyCommandWithInput: @"1" modifierFlags: 0 action: @selector(k1:)];
    UIKeyCommand *k2 = [UIKeyCommand keyCommandWithInput: @"2" modifierFlags: 0 action: @selector(k2:)];
    UIKeyCommand *k3 = [UIKeyCommand keyCommandWithInput: @"3" modifierFlags: 0 action: @selector(k3:)];
    UIKeyCommand *k4 = [UIKeyCommand keyCommandWithInput: @"4" modifierFlags: 0 action: @selector(k4:)];
    UIKeyCommand *kspace = [UIKeyCommand keyCommandWithInput: @" " modifierFlags: 0 action: @selector(kspace:)];
    UIKeyCommand *kenter = [UIKeyCommand keyCommandWithInput: @"\r" modifierFlags: 0 action: @selector(kenter:)];
    
    
    
    return [[NSArray alloc] initWithObjects: esc, down, up, left, right, k0, k1, k2, k3, k4, kspace, kenter, nil];
}



- (void) esc: (UIKeyCommand *) keyCommand {
    [self switchView];
    NSLog(@"KeyDown");
}


- (void) kspace: (UIKeyCommand *) keyCommand {
    [Feedback convertMode];
}

- (void) k0: (UIKeyCommand *) keyCommand {
    // Your custom code goes here.
    
    NSLog(@"KeyDown");
}

- (void) k1: (UIKeyCommand *) keyCommand {
    // Your custom code goes here.
    
    NSLog(@"KeyDown");
    if ([State isTrainingMode]) {
        State.feedbackStepByStep = StepVertical;
        [m_text trainVerticalBox];
        [m_seg setSelectedSegmentIndex: State.feedbackStepByStep - 1];
    }
    
    [Log recordTrainStepChange: State.feedbackStepByStep];
}

- (void) k2: (UIKeyCommand *) keyCommand {
    // Your custom code goes here.
    NSLog(@"KeyDown");
    if ([State isTrainingMode]) {
        [m_text trainElse];
        State.feedbackStepByStep = StepVerticalText;
        [m_seg setSelectedSegmentIndex: State.feedbackStepByStep - 1];
    }
    
    [Log recordTrainStepChange: State.feedbackStepByStep];
}

- (void) k3: (UIKeyCommand *) keyCommand {
    // Your custom code goes here.
    NSLog(@"KeyDown");
    if ([State isTrainingMode]) {
        [m_text trainElse];
        State.feedbackStepByStep = StepLine;
        [m_seg setSelectedSegmentIndex: State.feedbackStepByStep - 1];
    }
    
    [Log recordTrainStepChange: State.feedbackStepByStep];
}


- (void) k4: (UIKeyCommand *) keyCommand {
    // Your custom code goes here.
    if ([State isTrainingMode]) {
        [m_text trainElse];
        State.feedbackStepByStep = StepAll;
        [m_seg setSelectedSegmentIndex: State.feedbackStepByStep - 1];
    }
    
    [Log recordTrainStepChange: State.feedbackStepByStep];
}

- (void) kenter: (UIKeyCommand *) keyCommand {
    [Speech speakText: [State insEndPlain]];
}

- (void) left: (UIKeyCommand *) keyCommand {
    [Feedback lineBeginOnly];
}

- (void) down: (UIKeyCommand *) keyCommand {
    [Feedback paraEndOnly];
}

- (void) right: (UIKeyCommand *) keyCommand {
    [Feedback lineEndOnly];
}


- (void) up: (UIKeyCommand *) keyCommand {
    
}

@end
