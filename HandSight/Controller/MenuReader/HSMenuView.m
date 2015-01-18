//
//  HSTextView.m
//  HandSight2.0
//
//  Created by Ruofei Du on 6/16/14.
//  Copyright (c) 2014 RedBearLab. All rights reserved.
//

#import "HSMenuView.h"

@implementation HSMenuView

- (void) reset {
    [super reset];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (HSMenuView*) sharedInstance
{
    static  HSMenuView* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self  alloc] init];
    });
    return  sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        Doc.numCols = 1;
        /*
         m_textSize += 4;
         m_titleSize += 4;
         m_lineSpacing += 4;
         */
        NSLog(@"[MV] Inited");
    }
    
    return self;
}

- (void) addControls {
    [super addControls];
}

- (void)loadDocument {
    Doc.numCols = 1;
    [self clearViews];
    NSLog(@"[MV] PlainView Load Document");
    Doc.isLoaded = false;
    [[self textStorage] setAttributedString:[self getAttributedString]];
}

@end
