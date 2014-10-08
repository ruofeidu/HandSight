//
//  TextController.m
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "TextController.h"
#import "HSMagView.h"
#import "AFNetworking.h"

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
        UISegmentedControl *s = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects: @"Vertical Box", @"Vertical Text", @"Line/Para Signal", @"Speech", nil]];
        [s setFrame: CGRectMake(m_inset * 2, m_btnTop, m_segWidth * 1.5, m_textHeight)];
        [s setSelectedSegmentIndex: State.feedbackStepByStep - 1];
        [self.view addSubview:s];
        [s addTarget:self action: @selector(segChanged:) forControlEvents: UIControlEventValueChanged];
        [s setEnabled: NO]; 
        s;
    });
    
    if (State.feedbackStepByStep == Step0) {
        [m_seg setHidden: YES];
    } else {
        [m_seg setHidden: NO];
        [m_label setHidden: YES];
        //[self sendData: 1]; // Make the "Training Session" set to "Vertical Box" state by default.
        //m_timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getData:) userInfo:nil repeats:YES];
    }

    [super addControls];
}

- (void)segChanged: (id)sender
{
    enum FeedbackStepByStep shouldChange = [m_seg selectedSegmentIndex] + 1;
    
    if ([State isTrainingMode]) {
        if (shouldChange == StepVertical) {
            State.feedbackStepByStep = shouldChange;
            [m_text trainVerticalBox];
            [m_seg setSelectedSegmentIndex: State.feedbackStepByStep - 1];
        } else {
            State.feedbackStepByStep = shouldChange;
            [m_text trainElse];
            [m_seg setSelectedSegmentIndex: State.feedbackStepByStep - 1];
        }
    }
}

/*
- (void)getData :(NSTimer *)timer {
    if (State.feedbackStepByStep == Step0) return;
    
    NSString* BaseURLString = @"http://duruofei.com/HandSight/";
    
    NSString *string = [NSString stringWithFormat:@"%@?get=1", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* msg = operation.responseString;
        enum FeedbackStepByStep shouldChange = State.feedbackStepByStep;
        
        if ([msg characterAtIndex:0] == '1') {
            shouldChange = StepVertical;
        } else
            if ([msg characterAtIndex:0] == '2')
            {
                shouldChange = StepVerticalText;
            } else
                if ([msg characterAtIndex:0] == '3')
                {
                    shouldChange = StepLine;
                }
                else
                if ([msg characterAtIndex:0] == '4')
                {
                    shouldChange = StepAll;
                }
        
        if (shouldChange != State.feedbackStepByStep) {
            [Feedback verticalStop];
            State.feedbackStepByStep = shouldChange;
            [m_text handleSingleTouch: State.lastPoint];
        }
        [m_seg setSelectedSegmentIndex: State.feedbackStepByStep - 1];
        
        
        //NSLog(@"%@", operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Anyway we send the data");
    }];
    
    [operation start];
}

- (void)sendData :(int) val {
    NSString* BaseURLString = @"http://duruofei.com/HandSight/";
    
    NSString *string = [NSString stringWithFormat:@"%@?set=%d", BaseURLString, val];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@", operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Anyway we send the data");
    }];
    
    [operation start];
}
*/




@end
