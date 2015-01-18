//
//  HSStatLabel.h
//  HandSight
//
//  Created by Ruofei Du on 8/28/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSStat.h"
#import "HSState.h"

@interface HSStatLabel : UILabel {
    HSStat *Stat;
    HSState *State;
    NSTimer *m_timer; 
}

+ (HSStatLabel*) sharedInstance;


@end
