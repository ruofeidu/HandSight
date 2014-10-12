//
//  MenuController.m
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "MenuController.h"

@interface MenuController ()

@end

@implementation MenuController

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
    // Do any additional setup after loading the view.
}

- (void)reset
{
    NSLog(@"[MC] Reset");
    m_btnLeft = 800, m_btnTop = 720;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 15;
    paragraphStyle.firstLineHeadIndent = 15;
    paragraphStyle.lineSpacing = 7;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addControls
{
    
}

- (void)switchView
{
    if (State.debugMode) {
        NSLog(@"[CP] Switch View");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MenuController *viewController = (MenuController *)[storyboard instantiateViewControllerWithIdentifier:@"MenuController"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}


@end
