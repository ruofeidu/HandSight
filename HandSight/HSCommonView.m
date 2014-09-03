//
//  HSCommonView.m
//  HandSight
//
//  Created by Ruofei Du on 7/22/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSCommonView.h"

@implementation HSCommonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    NSLog(@"[Common View] Inited");
    Feedback        =       [HSFeedback sharedInstance];
    Speech          =       [HSSpeech sharedInstance];
    State           =       [HSState sharedInstance];
    Log             =       [HSLog sharedInstance];
    File            =       [HSFile sharedInstance];
    Doc             =       [HSDocument sharedInstance];
    Viz             =       [HSViz sharedInstance];
    Stat            =       [HSStat sharedInstance];
    
    m_textFontName  =       @"Times New Roman";
    self = [super init];
    [self reset];
    return self;
}

- (void)reset
{
    m_lblLineBeginX =       100; 
}


/**
 * Add indicators, labels to the view
 */
- (void) addControls {
    NSLog(@"[MV] Add controls");
    float y = m_top + m_lineSpacing + m_lineSpacing;
    float h = y;
    float l = 0;
    float x = m_left;
    
    if ([Doc hasTitle]) h += m_titleSize; else h += m_textSize;
    
    m_lblStartX     =       0;
    lblStart = ({
        CGFloat y = 0;
        if ([State categoryType] == CT_MAGAZINE) {
            switch ([State documentType]) {
                case DT_TRAIN:
                    y = 429.21;
                    break;
                case DT_A:
                    y = 343.2124; //581.78491; //483.2124;
                    break;
                case DT_B:
                    y = 269;
                    break;
                case DT_C:
                    y = 539;
                    break;
                case DT_D:
                    y = 539; 
            }
        }
        y += 70;
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_lblStartX, y, m_left, h)];
        [l setText:@"Start Region"];
        [l setTextColor:[UIColor blackColor]];
        [l setTextAlignment:NSTextAlignmentCenter];
        [l setBackgroundColor:[UIColor orangeColor]];
        [l setAlpha: m_alphaHint];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textSize / 2]];
        [self addSubview:l];
        [m_arrControls addObject:l];
        
        l;
    });
    
    lblLeft = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, h, m_left, m_height - h)];
        [l setText:@"Left Region"];
        [l setTextColor:[UIColor blackColor]];
        [l setTextAlignment:NSTextAlignmentCenter];
        [l setBackgroundColor:[UIColor yellowColor]];
        [l setAlpha: m_alphaHint];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textSize / 2]];
        [self addSubview:l];
        if (!State.debugMode) [l setHidden:YES];
        [m_arrControls addObject:l];
        l;
    });
    
    lblTop = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_left, 0, m_width - m_left, m_top)];
        [l setText:@"Top Region"];
        [l setTextColor:[UIColor blackColor]];
        [l setTextAlignment:NSTextAlignmentCenter];
        [l setBackgroundColor:[UIColor blueColor]];
        [l setAlpha: m_alphaHint];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textSize / 2]];
        if (!State.debugMode) [l setHidden:YES];
        [self addSubview:l];
        [m_arrControls addObject:l];
        l;
    });
    
    lblBottom = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_left, m_height-m_bottom, m_width - m_left, m_bottom)];
        [l setText:@"Bottom Region"];
        [l setTextColor:[UIColor blackColor]];
        [l setTextAlignment:NSTextAlignmentCenter];
        [l setBackgroundColor:[UIColor blueColor]];
        [l setAlpha: m_alphaHint];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textSize / 2]];
        [self addSubview:l];
        if (!State.debugMode) [l setHidden:YES];
        [m_arrControls addObject:l];
        l;
    });
    
    lblRight = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_width - m_right, m_top, m_right, m_height - m_top - m_bottom)];
        [l setText:@"Bottom Region"];
        [l setTextColor:[UIColor blackColor]];
        [l setTextAlignment:NSTextAlignmentCenter];
        [l setBackgroundColor:[UIColor blueColor]];
        [l setAlpha: m_alphaHint];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textSize / 2]];
        if (!State.debugMode) [l setHidden:YES];
        [self addSubview:l];
        [m_arrControls addObject:l];
        l;
    });
    
    lblLeft = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, h, m_left, m_height - h)];
        [l setText:@"Left Region"];
        [l setTextColor:[UIColor blackColor]];
        [l setTextAlignment:NSTextAlignmentCenter];
        [l setBackgroundColor:[UIColor yellowColor]];
        [l setAlpha: m_alphaHint];
        if (!State.debugMode) [l setHidden:YES];
        [l setFont: [UIFont fontWithName:m_textFontName size:m_textSize / 2]];
        [self addSubview:l];
        [m_arrControls addObject:l];
        l;
    });
    
    y = m_top;
    l = [Doc.dictParaLine[[NSNumber numberWithInt:0]] floatValue];
    [m_arrLblPara removeAllObjects];
    
    if (Doc.hasTitle)
    {
        h = m_titleHeight * l + m_lineSpacing * l;
        lblTitle = ({
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_left, y, m_columnWidth, h)];
            [l setText:@"Title Region"];
            [l setTextColor:[UIColor blackColor]];
            [l setTextAlignment:NSTextAlignmentCenter];
            [l setBackgroundColor:[UIColor yellowColor]];
            [l setAlpha: m_alphaHint];
            if (!State.debugMode) [l setHidden:YES];
            [l setFont: [UIFont fontWithName:m_textFontName size:m_textSize / 2]];
            [self addSubview:l];
            [m_arrControls addObject:l];
            [m_arrLblPara addObject:l];
            l;
        });
    }
    
    lblCurrent = ({
        UILabel *l = [[UILabel alloc] initWithFrame:INVISIBLE_RECT];
        [l setBackgroundColor:[UIColor orangeColor]];
        [l setAlpha: m_alphaText];
        [self addSubview:l];
        [m_arrControls addObject:l];
        l;
    });
    
    lblNext = ({
        UILabel *l = [[UILabel alloc] initWithFrame:INVISIBLE_RECT];
        [l setBackgroundColor:[UIColor greenColor]];
        [l setAlpha: m_alphaText];
        [self addSubview:l];
        [m_arrControls addObject:l];
        [m_arrControls addObject:l];
        l;
    });
    
    lblLineEnd = ({
        UILabel *l = [[UILabel alloc] initWithFrame:INVISIBLE_RECT];
        [l setBackgroundColor:[UIColor greenColor]];
        [l setAlpha: m_alphaText];
        [self addSubview:l];
        [m_arrControls addObject:l];
        l;
    });
    
    lblLineBegin = ({
        UILabel *l = [[UILabel alloc] initWithFrame:INVISIBLE_RECT];
        [l setBackgroundColor:[UIColor greenColor]];
        [l setAlpha: m_alphaText];
        [self addSubview:l];
        [m_arrControls addObject:l];
        l;
    });
    
    lblLast = ({
        UILabel *l = [[UILabel alloc] initWithFrame:INVISIBLE_RECT];
        [l setBackgroundColor:[UIColor yellowColor]];
        [l setAlpha: m_alphaText];
        [self addSubview:l];
        [m_arrControls addObject:l];
        l;
    });
    
    
    // breaking between title and contents
    if ([Doc hasTitle]) {
        y += h;
        h = (m_textHeight + m_lineSpacing);
        if ([State documentType] == 0) {
            h += (m_textHeight + m_lineSpacing);
        }
        
        ({
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(m_left, y, m_columnWidth, h)];
            [l setText:@"break region"];
            [l setTextColor:[UIColor blackColor]];
            [l setTextAlignment:NSTextAlignmentCenter];
            [l setBackgroundColor:[UIColor blueColor]];
            [l setAlpha: m_alphaHint];
            if (!State.debugMode) [l setHidden:YES];
            [l setFont: [UIFont fontWithName:m_textFontName size:m_textSize / 2]];
            [self addSubview:l];
            [m_arrControls addObject:l];
        });
        
        y += h;
    }
    
    x = m_left;
    int para = 0;
    
    for (para = 1; para <= Doc.numPara; ++para) {
        l = [Doc.dictParaLine[[NSNumber numberWithInt:para]] floatValue];
        
        if (l == 0) {
            x += m_columnWidth + m_columnSpacing;
            y = m_top;
            
            lblColumn = ({
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x - m_columnSpacing, m_top, m_columnSpacing, m_height - m_top - m_bottom)];
                [l setText:@"Column Spacing"];
                [l setTextColor:[UIColor blackColor]];
                [l setTextAlignment:NSTextAlignmentCenter];
                [l setBackgroundColor:[UIColor blueColor]];
                [l setAlpha: m_alphaHint];
                if (!State.debugMode) [l setHidden:YES];
                [l setFont: [UIFont fontWithName:m_textFontName size:m_textSize / 2]];
                [self addSubview:l];
                [m_arrControls addObject:l];
                l;
            });
            continue;
        } else
            if (l > Doc.lineSymImg){
                // image spacing
                l -= Doc.lineSymImg;
                y += (m_textHeight + m_lineSpacing) * l;
                continue;
            }
        h = (m_textHeight + m_lineSpacing) * l;
        ({
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x, y, m_columnWidth, h)];
            [l setText:[NSString stringWithFormat:@"Paragraph %lu Region", (unsigned long)[m_arrLblPara count] ]];
            [l setTextColor:[UIColor blackColor]];
            [l setTextAlignment:NSTextAlignmentCenter];
            [l setBackgroundColor:[UIColor yellowColor]];
            [l setAlpha: m_alphaHint];
            [l setFont: [UIFont fontWithName:m_textFontName size:m_textSize / 2]];
            if (!State.debugMode) [l setHidden:YES];
            [self addSubview:l];
            [m_arrControls addObject:l];
            [m_arrLblPara addObject:l];
        });
        y += h + m_textHeight + m_lineSpacing;
    }
}

- (void) clearViews {
    if (lblStart != nil) {
        for (UIView* subview in m_arrControls) {
            [subview removeFromSuperview];
        }
        [m_arrControls removeAllObjects];
    }
    [State reset]; 
}


- (void) hideLineLabels {
    [lblLineBegin setHidden:YES];
    [lblLineEnd setHidden:YES];
}



@end
