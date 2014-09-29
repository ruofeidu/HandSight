//
//  HSTextView.m
//  HandSight2.0
//
//  Created by Ruofei Du on 6/16/14.
//  Copyright (c) 2014 RedBearLab. All rights reserved.
//

#import "HSTextView.h"

@implementation HSTextView

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

+ (HSTextView*) sharedInstance
{
    static  HSTextView* sharedInstance = nil ;
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
        //[self enlargeTextFont];
        NSLog(@"[MV] Inited");
    }
    
    return self;
}

- (void) addControls {
    Doc.numCols = 1;
    [super addControls];
}

- (void)loadDocument {
    Doc.numCols = 1;
    [Doc reset];
    [Log recordDocumentLoaded]; 
    [self clearViews];
    NSLog(@"[MV] PlainView Load Document");
    [[self textStorage] setAttributedString:[self getAttributedString]];
}

- (void)enlargeTextFont {
    m_textSize += 4;
    m_titleSize += 4;
    m_lineSpacing += 4;
}

@end
