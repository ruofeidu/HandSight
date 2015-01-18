//
//  HSMagView.m
//  HandSight
//
//  Created by Ruofei Du on 7/22/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSMagView.h"

@implementation HSMagView

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

+ (HSMagView*) sharedInstance
{
    static  HSMagView* sharedInstance = nil ;
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
        Doc.numCols = 2;
        NSLog(@"[MV] MagView Inited");
    }
    
    return self;
}

- (void) addControls {
    Doc.numCols = 2;
    [super addControls];
}


- (void)loadDocument {
    Doc.numCols = 2;
    [self clearViews];
    [Log recordDocumentLoaded];
    NSLog(@"[MV] MagView Load Document");
    Doc.isLoaded = false;
    [[self textStorage] setAttributedString:[self getAttributedString]];
}

@end
