//
//  HSLabel.m
//  HandSight
//
//  Created by Ruofei Du on 7/29/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSLabel.h"

@implementation UILabel (HandSight)

- (BOOL) contains:(CGPoint)point {
    return CGRectContainsPoint(self.frame, point);
}

@end
