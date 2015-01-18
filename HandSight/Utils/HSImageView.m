//
//  HSImageView.m
//  HandSight
//
//  Created by Ruofei Du on 7/29/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSImageView.h"

@implementation UIImageView (HandSight)

- (BOOL) contains:(CGPoint)point {
    return CGRectContainsPoint(self.frame, point);
}


@end
