//
//  HSMultiView.h
//  HandSight
//
//  Created by Ruofei Du on 7/24/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSCommonView.h"

@interface HSMultiView : HSCommonView {
    
    NSString *m_textEnd, *m_titleFontName,
             *m_titleSymbol, *m_imgSymbol, *m_paraSymbol;
        
    NSMutableParagraphStyle *m_titleStyle, *m_textStyle;
    
    bool m_controlAdded;
}

@property (copy, nonatomic) NSTextStorage *textStorage;
@property (strong, nonatomic) NSArray *textOrigins;
@property (strong, nonatomic) NSLayoutManager *layoutManager;
@property (strong, nonatomic) NSArray *images;

-(id) init;
-(void) reset;
- (void) createColumns;
- (void) layoutSubviews;
- (NSAttributedString*) getAttributedString;
- (void) clearViews;
- (void) getStartedQuick;
- (void)handleSingleTouch:(CGPoint) point;

@end
