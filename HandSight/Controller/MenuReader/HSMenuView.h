//
//  HSTextView.h
//  HandSight2.0
//
//  Created by Ruofei Du on 6/16/14.
//  Copyright (c) 2014 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCommonView.h"
#import "HSMultiView.h"

@interface HSMenuView : HSMultiView {
}

+ (HSMenuView*) sharedInstance;
- (void)loadDocument;

@end
