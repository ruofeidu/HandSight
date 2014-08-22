//
//  HSMagView.h
//  HandSight
//
//  Created by Ruofei Du on 7/22/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCommonView.h"
#import "HSMultiView.h"

@interface HSMagView : HSMultiView {
    
}

+ (HSMagView*) sharedInstance;
- (void)loadDocument;
- (void) addControls;

@end
