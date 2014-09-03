//
//  HSCommonView.h
//  HandSight
//
//  Created by Ruofei Du on 7/22/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSUtils.h"
#import "HSFeedback.h"
#import "HSDocument.h"
#import "HSViz.h"

@interface HSCommonView : UIView {
    CGRect INVISIBLE_RECT, DEFAULT_RECT, m_wordMargin;
    
    NSMutableArray *m_arrImg, *m_arrLblPara, *m_arrBlanks, *m_arrControls;
    
    UILabel* lblLeft, *lblStart, *lblCurrent, *lblNext, *lblLast, *lblTitle, *lblColumn, *lblRight, *lblTop, *lblBottom, *lblLineEnd, *lblLineBegin;
    
    NSString* m_textFontName; 
    
    CGFloat m_left, m_top, m_bottom, m_right, m_width, m_height,
    m_alphaHint, m_alphaText, m_alphaViz, m_alphaShow, m_alphaHide, m_titleSize, m_columnWidth, m_columnHeight, m_titleHeight, m_textHeight, m_pictureInset,
    m_textSize, m_labelTextSize, m_lineHeight, m_lineSpacing, m_columnSpacing, m_lblStartX, m_lblLineBeginX;
    
    HSFeedback *Feedback;
    HSSpeech *Speech;
    HSState *State;
    HSLog *Log;
    HSFile *File;
    HSDocument *Doc;
    HSViz *Viz;
    HSStat *Stat; 
    
    UITapGestureRecognizer *m_doubleTap, *m_tripleTap;
}


- (id) init;
- (void) reset;
- (void) addControls;
- (void) clearViews;
- (void) hideLineLabels;

@end
