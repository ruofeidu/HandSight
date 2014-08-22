//
//  HSViz.h
//  HandSight
//
//  Created by Ruofei Du on 8/14/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSState.h"

@interface HSViz : UIImageView {
    CGPoint m_prevPoint;
    
    CGFloat m_lineWidth, m_width, m_height, m_curveLength;
    
    HSState* State; 
}


+ (HSViz *) sharedInstance;
- (void) reset; 

- (void) touchDown: (CGPoint) point;
- (void) touchUp: (CGPoint) point;
- (void) touchMove: (CGPoint) point;

@end
