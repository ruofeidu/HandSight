//
//  CommonController.h
//  HandSight
//
//  Created by Ruofei Du on 7/16/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSUtils.h"
#import "HSFeedback.h"

@interface CommonController : UIViewController {
    CGFloat m_btnLeft, m_btnTop;
    
    CGFloat m_inset, m_titleFontSize, m_textFontSize, m_titleHeight, m_textHeight, m_titleWidth, m_textWidth, m_segWidth, m_segHeight, m_segInset, m_swcWidth;
    
    UIColor *m_textColor;
    
    NSString *m_titleFontName, *m_textFontName;
    
    HSFeedback *Feedback;
    HSSpeech *Speech;
    HSState *State;
    HSLog *Log;
    HSStat *Stat;
}

- (void) hideStatusBar;
- (void) reset; 

@end
