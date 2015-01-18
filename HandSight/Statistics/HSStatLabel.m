//
//  HSStatLabel.m
//  HandSight
//
//  Created by Ruofei Du on 8/28/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSStatLabel.h"

@implementation HSStatLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        Stat = [HSStat sharedInstance];
        State = [HSState sharedInstance];
        
        self.frame = CGRectMake(0, 0, 1024, 50);
        if (m_timer == nil) {
            m_timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(check:) userInfo:nil repeats:YES];
        }
        
        [self setHidden: YES];
        if ([[HSState sharedInstance] debugMode]) [self setHidden:NO];
        
        [self setHidden: NO];
        [self setFont: [UIFont fontWithName:@"Times New Roman" size:16.0]];
    }
    return self;
}

- (void) check: (NSTimer*) timer {
    [self setText:[Stat dumpRealtime]];
}

+(HSStatLabel*) sharedInstance
{
    static  HSStatLabel* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self  alloc] init];
    });
    return  sharedInstance;
}


@end
