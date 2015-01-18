//
//  HSMultiView.m
//  HandSight
//
//  Created by Ruofei Du on 7/24/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//
#import "HSMultiView.h"

@implementation HSMultiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)setTextStorage:(NSTextStorage *)textStorage {
    if ([Doc isLoaded]) return;
    NSLog(@"[MV] Set text storage");
    _textStorage = [[NSTextStorage alloc] initWithAttributedString:textStorage];
    [self.textStorage addLayoutManager:self.layoutManager];
    [self setNeedsDisplay];
}

/**
 * After creating columns, we add controls
 */
- (void)createColumns {
    // Remove any existing text containers, since we will recreate them.
    for (NSUInteger i = [self.layoutManager.textContainers count]; i > 0;) {
        [self.layoutManager removeTextContainerAtIndex:--i];
    }
    
    CGFloat x = m_left, y = m_top;
    
    // Calculate sizes for building a series of text containers.
    CGFloat totalMargin = m_columnSpacing * ([Doc numCols] - 1) + m_left + m_right;

    m_columnWidth = (m_width - totalMargin) / [Doc numCols];
    m_columnHeight = m_height - m_bottom - m_top;
    CGSize columnSize = CGSizeMake(m_columnWidth, m_columnHeight);
    
    NSMutableArray *containers = [NSMutableArray arrayWithCapacity: [Doc numCols]];
    NSMutableArray *origins = [NSMutableArray arrayWithCapacity: [Doc numCols]];
    
    for (NSUInteger i = 0; i < [Doc numCols]; i++) {
        // Create a new container of the appropriate size, and add it to our array.
        NSTextContainer *container = [[NSTextContainer alloc] initWithSize:columnSize];
         NSLog(@"[MV] Create column %lu: %@", (unsigned long)i, NSStringFromCGSize(columnSize));
        [containers addObject:container];
        
        // Create a new origin point for the container we just added.
        NSValue *originValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [origins addObject:originValue];
        
        
        [self.layoutManager addTextContainer:container];
        x += m_columnWidth + m_columnSpacing;
    }
    self.textOrigins = origins;
    [self addControls];
}

- (void) getStartedQuick {
    
    if (![State taskStarted]) {
        if (State.feedbackStepByStep != Step0) {
            [self taskStart];
            [self trainVerticalBox];
            State.taskStarted = true;
            State.waitLineBegin = false;
        }
    }
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"[MV] Draw Rects");
    
    if (State.feedbackStepByStep != Step0) {
        [self trainVerticalBox];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getStartedQuick) userInfo:nil repeats:NO];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(calcDocument) userInfo:nil repeats:NO];
        
        //if (State.categoryType == CT_MAGAZINE) {
            [self taskStart];
            State.taskStarted = true;
            State.waitLineBegin = false;
            State.waitLineEnd = false;
            [lblStart setHidden: YES];
            [lblLineBegin setHidden: YES];
        [self waitLineBegin]; 
        //}
        
        [lblTrainBG setHidden: YES]; 
    }

    for (NSUInteger i = 0; i < [Doc numCols]; i++) {
        NSTextContainer *container = self.layoutManager.textContainers[i];
        
        CGPoint origin = [self.textOrigins[i] CGPointValue];
        
        NSRange glyphRange = [self.layoutManager glyphRangeForTextContainer:container];
        [self.layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:origin];
    }
    
    //if ([State debugMode]) {
        [self addGestureRecognizer:m_doubleTap];
    //}
}

- (void)converMode: (UITapGestureRecognizer *)recognizer {
    if (State.debugMode) {
        [Feedback convertMode];
    } else {
        if (m_isSpeaking) {
            [Speech stopSpeaking];
        } else {
            [Speech speakText: m_text];
        }
        m_isSpeaking = !m_isSpeaking; 
        [lblNext setHidden: YES];
    }
}

- (void)hold: (UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:recognizer.view];
    [self handleSingleTouch: location];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([Doc isLoaded]) return;
    NSLog(@"[HS] Layout subviews & end loading documents");
    [self createColumns];
    [self setNeedsDisplay];
    [Doc setLoaded];
}

- (id)init
{
    self = [super init];
    
    self.layoutManager          =       [[NSLayoutManager alloc] init];
    self.textStorage            =       [[NSTextStorage alloc] initWithString:@""];
    m_arrControls               =       [[NSMutableArray alloc] init];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    m_textEnd = @" 　 \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n \n";
    [self reset];
    
    [self setFrame: CGRectMake(0, 0, m_width, m_height)];
    [self setMultipleTouchEnabled:YES];
    return self;
}

- (void)reset
{
    [super reset]; 
    [Doc reset];
    m_isSpeaking    =       false; 
    //[Log recordDocumentView];
    // the view bound
    m_left          =       120;
    m_top           =       70;
    
    m_columnSpacing =       40;
    
    m_bottom        =       70;
    m_right         =       100;
    
    
    m_width         =       1024;
    m_height        =       768;
    
    // the alpha
    m_alphaHint     =       0.2;
    m_alphaText     =       0.5;
    m_alphaViz      =       0.5; 
    m_alphaHide     =       0.0f;
    m_alphaShow     =       1.0f;
    
    // the text
    m_textFontName  =       @"Times New Roman";
    m_titleFontName =       @"Times New Roman";
    
    m_lineSpacing   =       6;
    m_lineHeight    =       m_textSize + m_lineSpacing;

    m_textSize      =       21.0f;
    m_titleSize     =       26.0f;
    m_pictureInset  =       10.0f;
    m_titleHeight   =       m_titleSize + 2;
    m_textHeight    =       m_textSize + 2;
    
    m_labelTextSize =       m_textSize / 2; 
    m_titleSymbol   =       @"*";
    m_imgSymbol     =       @"~";
    m_paraSymbol    =       @"%";
    
    m_arrLblPara    =       [[NSMutableArray alloc] init];

    
    m_arrImg        =       [[NSMutableArray alloc] init];
    INVISIBLE_RECT  =       CGRectMake(0, 0, 0, 0);
    DEFAULT_RECT    =       CGRectMake(1, 1, 1, 1);
    
    m_doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(converMode:)];
    m_hold = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hold:)];

    m_doubleTap.numberOfTapsRequired = 2;
    m_doubleTap.numberOfTouchesRequired = 2;
    
    m_hold.numberOfTouchesRequired = 1;
    
    m_titleStyle = [[NSMutableParagraphStyle alloc] init];
    m_titleStyle.headIndent = 0;
    m_titleStyle.firstLineHeadIndent = 0;
    m_titleStyle.lineSpacing = m_lineSpacing;
    m_titleStyle.minimumLineHeight = m_titleHeight;
    m_titleStyle.maximumLineHeight = m_titleHeight;
    m_titleStyle.alignment = NSTextAlignmentJustified;
    
    
    m_textStyle = [[NSMutableParagraphStyle alloc] init];
    m_textStyle.headIndent = 0;
    m_textStyle.firstLineHeadIndent = 0;
    m_textStyle.lineSpacing = m_lineSpacing;
    m_textStyle.minimumLineHeight = m_textHeight;
    m_textStyle.maximumLineHeight = m_textHeight;
    
    if (State.categoryType == CT_MAGAZINE) {
        m_textStyle.alignment = NSTextAlignmentJustified;
    }
    
    m_wordMargin    =       CGRectMake(m_textSize / 2, m_lineSpacing + 2, m_textSize * 2, m_lineSpacing * 2);
}

- (NSAttributedString*) getAttributedString {
    [Feedback handsightText]; 
    int c = [State sightedReading] ? 2 : [State categoryType];
    NSString* textContent = [File readTxt: [NSString stringWithFormat:@"%d%d", c, [State documentType]]];
    NSString* text = [textContent stringByReplacingOccurrencesOfString:@"\n" withString:@" \n "];
    
    if (State.documentType == DT_A && State.categoryType == CT_PLAIN) {
        
        m_text = @"People have used coins as a means of exchange for thousands of years. Valued for their craftsmanship and purchasing power, coins have been collected in great numbers throughout history and buried for safekeeping. Because stores of coins gathered and hidden in this manner lie untouched for many years, they can reveal a great deal about a given culture. Coins are useful in revealing many aspects of a culture. They can provide clues about when a given civilization was wealthy and when it was experiencing a depression. Wealthy nations tend to produce a greater number of coins made from richer materials. The distribution of coins can also reflect the boundaries of an empire and the trade relationships within it. Roman imperial gold coins found in India, indicate the Romans purchased goods from the East. The way the coins themselves are decorated sometimes provides key information about a culture. Many coins are stamped with a wealth of useful historical evidence, including portraits of political leaders, important buildings and sculptures, mythological and religious figures, and useful dates. Some coins, such as many from ancient Greece, can be considered works of art themselves and reflect the artistic achievement of the civilization as a whole. Information gathered from old coins by historians is most useful when placed alongside other historical documents, such as written accounts or data from archeological digs. Combined with these other pieces of information, coins can help historians reconstruct the details of lost civilizations.";
        
    } else
        if (State.documentType == DT_B && State.categoryType == CT_PLAIN) {
            
            
            m_text = @"Born in Spanish Harlem in the late 1950s, Raphael Sanchez learned at an early age to listen to the many voices of the city. It was as a boy in Harlem that he developed the powers of observation that would later make his writing truly great. In the 1970s, Raphael went to Columbia University, where he was exposed to a literary tradition. While his university education gave his writing new depth, the raw energy of the streets has always served as the primary fuel for his writing. This is what gives his works passion and power. Raphael once told me that in order to escape from life he turns to books, and in order to escape from books he turns to life. It is this balance of the sights, sounds, and smells of the street with the perspective gained from his formal education that has made Raphael popular with both critics and regular readers alike. For those of us who have read and admired his work, it seems natural that Raphael has won so many awards. He deserves them, and his humility in accepting them has been refreshing. When he received the Writer’s Quill Award two weeks ago, for example, he told the audience, This award is not really mine. It belongs to all the million things that have inspired me. That is the kind of man I am introducing to you this evening. He is a man who has been inspired by a million things, and he is a man who has provided inspiration to a million people. Ladies and gentlemen, it is my great honor to present to you, Raphael Sanchez. ";
            
        } else
            if (State.documentType == DT_A && State.categoryType == CT_MAGAZINE) {
                
                
                m_text = @"Despite the stubborn, widespread opinion that animals don’t feel emotions in the same way that humans do, many animals have been observed to demonstrate a capacity for joy. People have often seen animals evincing behavior that can only be taken to mean they are pleased with what life has brought them in that particular moment. A chimpanzee named Nim was raised by a human family for the first year and a half of his life. After that time, Nim was separated from them for two and a half years. On the day that Nim was reunited with his human family, he smiled, shrieked, pounded the ground, and looked from one member of the family to the next. Still smiling and shrieking, Nim went around hugging each member of the family. He played with and groomed each member of the family for almost an hour before the family had to leave. People who were familiar with Nim’s behavior said they had never seen him smile for such a long period of time.";
                
            } else
                if (State.documentType == DT_B && State.categoryType == CT_MAGAZINE) {
                    
                    
                    m_text = @"In the 1800s, most geologists thought the sea floor was a lifeless expanse of mud, sediment, and the decaying remains of dead organisms. They thought that, with the exception of some volcanic islands, the bottom of the sea had no major geographic features, such as peaks or valleys. In the mid-nineteenth century, ships depth- sounding the ocean floor with sonar for a transatlantic telegraph cable made some interesting discoveries. To geologists’ surprise, the ocean floor was found to be made up of long mountain ranges and deep valleys and troughs. Another surprise finding in the Atlantic was the existence of basalt, a volcanic rock thought only to exist in the Pacific Ocean. The presence of basalt in the Atlantic was a clue that volcanic activity occurs at the bottom of the sea. This and other discoveries, many of them accidental in the beginning, were signals to geologists that their knowledge of the sea floor was very limited.";
                    
                }
                 
    Doc.arrWord = [[text componentsSeparatedByString:@" "] mutableCopy];
    [m_arrImg removeAllObjects]; 
    [Doc clear];
    
    NSMutableAttributedString *ans = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[UIFont fontWithName:m_titleFontName size:m_titleSize]}];
    NSUInteger lengthCount = 0;
    
    bool lineBreak = false;
    bool isTitle = false;
    
    
    for (int i = 0; i < [Doc numWords]; ++i) {
        NSString *strData = [NSString stringWithFormat:@"%@ ", Doc.arrWord[i]];

        if ([strData hasPrefix:m_titleSymbol]) {
            isTitle = true;
            [Doc setTitle];
        } else
        if ([strData hasPrefix:m_imgSymbol])
        {
            // deal with images
            strData = [strData stringByReplacingOccurrencesOfString:m_imgSymbol withString:@""];
            
            int p = i;
            float col = [Doc.arrWord[p+2] floatValue];
            float top = [Doc.arrWord[p+4] floatValue];
            float lines = [Doc.arrWord[p+6] floatValue];
            
            
            float y = m_top;
            if ([Doc hasTitle] && col == 1) {
                //y += (m_titleHeight + m_lineSpacing) * m_dict
                //TODO
                y += (m_textHeight + m_lineSpacing) * top;
            } else {
                y += (m_textHeight + m_lineSpacing) * top;
            }
            CGFloat totalMargin = m_columnSpacing * ([Doc numCols] - 1) + m_left + m_right;
            float w = (m_width - totalMargin) / [Doc numCols];
            float x = (col == 1) ? m_left : m_left + w + m_columnSpacing;
            float h = (m_textHeight + m_lineSpacing) * lines;
            
            NSString* fileName = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            {
                UIImageView* v = [[UIImageView alloc] initWithImage: [UIImage imageNamed:fileName]];
                [v setFrame: CGRectMake(x+m_pictureInset, y+m_pictureInset, w-m_pictureInset*2, h-m_pictureInset*2)];
                [m_arrImg addObject:v];
                [self addSubview:v];
                [m_arrControls addObject:v];
            }

            i += [Doc numPicParas];
            Doc.numImages = 1;
             
            continue;
        } else
        if ([strData  hasPrefix:m_paraSymbol])
        {
            int p = i + 1;  // title lines
            
            [Doc.dictParaLine setObject:[NSNumber numberWithInt:[Doc.arrWord[p] intValue] ] forKey: [NSNumber numberWithInt: 0] ];
            ++p;    // forpara:
            ++p;    // how many paras
            Doc.numPara = [Doc.arrWord[p] intValue];
            for (int i = 0; i < [Doc numPara]; ++i) {
                ++p;
                [Doc.dictParaLine setObject:[NSNumber numberWithInt:[Doc.arrWord[p] intValue] ] forKey: [NSNumber numberWithInt: i+1]];
            }
            i += [Doc numPara] + 3;
            NSLog(@"[MV] Document's title has %@ lines and %lu paragraphs.", Doc.dictParaLine[[NSNumber numberWithInt: 0]], (unsigned long)[Doc numPara] );
            continue;
        }
        
        NSString *strKey = [Doc.arrWord[i] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        strData = [strData stringByReplacingOccurrencesOfString:m_titleSymbol withString:@""];
        
        if ([Doc.arrWord[i] isLineBreak]) {
            strKey = @"";
            strData = @"\n";
            lineBreak = true;
        }
        
        NSMutableAttributedString* tmp = [[NSMutableAttributedString alloc] initWithString:strData
                                                                                attributes:@{@"tappable":@(YES),
                                                                                             @"key": strKey,
                                                                                             @"before": [NSNumber numberWithInteger:lengthCount],
                                                                                             @"length": [NSNumber numberWithInteger:[Doc.arrWord[i] length]],
                                                                                             @"column": [NSNumber numberWithInteger:0],
                                                                                             @"para": [NSNumber numberWithInteger:0],
                                                                                             @"line": [NSNumber numberWithInteger:0],
                                                                                             @"id": [NSNumber numberWithInteger: [Doc.arrWordDict count] ],
                                                                                             NSFontAttributeName:!isTitle ? [UIFont fontWithName:m_textFontName size:m_textSize] : [UIFont fontWithName:m_titleFontName size:m_titleSize],
                                                                                             NSParagraphStyleAttributeName: !isTitle ? m_textStyle : m_titleStyle }
                                          ];
        
        if ([strKey hasSuffix: m_titleSymbol]) {
            isTitle = false;
        }

        if (![strData isEmpty]) {
            [Doc.arrWordDict addObject: [[tmp attributesAtIndex:0 effectiveRange:NULL] mutableCopy]];
            [Doc.arrWordStartIndex addObject:[NSNumber numberWithUnsignedInteger:lengthCount]];
        }
        
        //NSLog(@"%d\t%lu\t[%@]\t[%@]", i, (unsigned long)lengthCount, strKey, strData);
        lengthCount += strData.length;
        
        [ans appendAttributedString:tmp];
    }
    Doc.textEndID = (int)[Doc.arrWordStartIndex count];
    NSLog(@"[DC] Total words %lu", (unsigned long)Doc.textEndID);
    return ans;
}

- (CGPoint) getTheBestPoint {
    if ([State.activeTouches count] == 0) return CGPointMake(0, 0);
    CGPoint point = [[State.activeTouches objectAtIndex:0] locationInView: self];
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[[State.activeTouches objectAtIndex:0] hash]];
    int hand = [[State.touchDict objectForKey:key] intValue];
    

    BOOL multiTouch = [State.activeTouches count] > 1;
    
    if (multiTouch) {
        point.x = -1; 
        hand = 2;
        
        /**
         Whenever there are exactly two touch locations, set the rightmost touch location as the right finger and the leftmost touch location as the left finger
         This could occasionally result in the fingers being swapped, if for example the right finger moves past the left when searching for the start of the line. However, it should automatically correct itself in this case, since the right finger will move rightwards along the line and the left will stay in place.
         **/
        
        if ([State.activeTouches count] == 2) {
            CGPoint p1 = [[State.activeTouches objectAtIndex:0] locationInView: self];
            NSString *k1 = [NSString stringWithFormat:@"%lu", (unsigned long)[[State.activeTouches objectAtIndex:0] hash]];
            
            CGPoint p2 = [[State.activeTouches objectAtIndex:1] locationInView: self];
            NSString *k2 = [NSString stringWithFormat:@"%lu", (unsigned long)[[State.activeTouches objectAtIndex:1] hash]];
            
            if (p1.x > p2.x) {
                [State.touchDict setValue:[NSNumber numberWithInt: TH_LEFT] forKey:k2];
                [State.touchDict setValue:[NSNumber numberWithInt: TH_RIGHT] forKey:k1];
                return p1;
            } else {
                [State.touchDict setValue:[NSNumber numberWithInt: TH_RIGHT] forKey:k2];
                [State.touchDict setValue:[NSNumber numberWithInt: TH_LEFT] forKey:k1];
                return p2;
            }
        }
        
        for (UITouch *aTouch in State.activeTouches) {
            NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[aTouch hash]];
            int hand = [[State.touchDict objectForKey:key] intValue];
            if ((State.mode == MD_READING && hand == TH_LEFT) || hand == TH_EXTRA) continue;
            
            if (hand == TH_UNKNOWN) {
                [State.touchDict setValue:[NSNumber numberWithInt: TH_LEFT] forKey:key];
            }

            CGPoint aPoint = [aTouch locationInView: self];
            if (aPoint.x > point.x) {
                point = aPoint;
            }
        }
        
        for (UITouch *aTouch in State.activeTouches) {
            CGPoint aPoint = [aTouch locationInView: self];
            if (aPoint.x == point.x) {
                NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[aTouch hash]];
                
                [State.touchDict setValue:[NSNumber numberWithInt:TH_RIGHT] forKey:key];
                
                break;
            }

        }
    }
    
    if (hand == TH_LEFT && State.mode == MD_READING) return CGPointMake(0, 0);
    
    
    return point;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        if (![State.activeTouches containsObject:touch]) {
            [State.activeTouches addObject:touch];
            NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[touch hash]];
            
            if ([State.activeTouches count] > 2) {
                [State.touchDict setValue:[NSNumber numberWithInt:TH_EXTRA] forKey:key];
            } else {
                [State.touchDict setValue:[NSNumber numberWithInt:TH_UNKNOWN] forKey:key];
            }
        
        }
    }
    
    
    int count = [event.allTouches count];
    if (count != [State.activeTouches count]) {
        NSLog(@"Touch Missync");
        [State.activeTouches removeAllObjects];
        for (UITouch *touch in event.allTouches) {
            if (![State.activeTouches containsObject:touch]) {
                [State.activeTouches addObject:touch];
            }
        }
    }
    
    CGPoint point = [self getTheBestPoint];
    
    
    //[Viz touchDown: point];
    [self handleSingleTouch: point];
    
    if (point.x != 0)
    [Log recordTouchDown:point.x withY:point.y withLineIndex:State.lineID withWordIndex:State.currentWordID withWordText:[Doc getKeyFromWordIndex:State.currentWordID]];
    
    [self updateTouchLog];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [self getTheBestPoint];
    //[Viz touchMove: point];
    [self handleSingleTouch: point];
    
    if (point.x != 0)
    [Log recordTouchMove:point.x withY:point.y withLineIndex:State.lineID withWordIndex:State.currentWordID withWordText:[Doc getKeyFromWordIndex:State.currentWordID]];
    
    [self updateTouchLog];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [State.activeTouches removeObject:touch];
        
        NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[touch hash]];
        [State.touchDict removeObjectForKey:key];
    }
    CGPoint point = [self getTheBestPoint];
    //[Viz touchUp: point];
    
    if (point.x != 0)
    [Log recordTouchUp:point.x withY:point.y withLineIndex:State.lineID withWordIndex:State.currentWordID withWordText:[Doc getKeyFromWordIndex:State.currentWordID]];
    
    if (State.mode == MD_EXPLORATION_TEXT || (State.automaticMode && State.automaticExploration)) [Feedback overSpacing];
    [lblCurrent setHidden: YES];
    [Feedback verticalStop];
    
    [self updateTouchLog];
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [State.activeTouches removeObject:touch];
        
        NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[touch hash]];
        [State.touchDict removeObjectForKey:key];
    }
    
    CGPoint point = [self getTheBestPoint];
    [Viz touchUp: point];
    [self handleSingleTouch: point];
    
    [Log recordTouchUp:point.x withY:point.y withLineIndex:State.lineID withWordIndex:State.currentWordID withWordText:[Doc getKeyFromWordIndex:State.currentWordID]];
    if (State.mode == MD_EXPLORATION_TEXT || (State.automaticMode && State.automaticExploration)) [Feedback overSpacing];
    [lblCurrent setHidden: YES];
    [Feedback verticalStop];
    
    [self updateTouchLog];
    
}

- (void) setLabelVisibility: (BOOL) visibility {
    
}

/**
 * get column id from point in the screen
 */
- (int) getColumnFromPoint: (CGPoint) point {
    if (Doc.numCols == 1) return 0;
    return (point.x < m_left + m_columnWidth + m_columnSpacing / 2) ? 0 : 1;
}

/**
 * get offset from column id
 */
- (CGPoint) getOffsetFromColumn: (int) columnID {
    return [[self.textOrigins objectAtIndex: columnID] CGPointValue];
}

/**
 * Relocate the point in subview of main layout 
 * The coordinate system differs
 */
- (CGPoint) getPointInTextContainer: (CGPoint) point {
    int col = [self getColumnFromPoint: point];
    CGPoint offset = [self getOffsetFromColumn: col];
    return CGPointMake(point.x - offset.x, point.y - offset.y);
}

/**
 * 1st column, double column case
 */
- (BOOL) isLeftColumn {
    if (State.nextWordID < 0) return YES;
    NSMutableDictionary *dict = [Doc getWordDict: State.nextWordID];
    return [dict isFirstColumn] && Doc.numCols > 1;
}

/**
 * 2nd column, double column case
 */
- (BOOL) isRightColumn {
    if (State.nextWordID < 0) return NO;
    NSMutableDictionary *dict = [Doc getWordDict: State.nextWordID];
    return [dict isSecondColumn] && Doc.numCols > 1;
}

- (BOOL) enterLineBeginRegion: (CGPoint) point {
    return [lblLineBegin contains: point];
    /*
    if ([self isRightColumn]) {
        return point.x <= m_left + m_columnWidth + m_columnSpacing && point.x >= m_left + m_columnWidth + m_columnSpacing - 20;
    } else {
        return point.x <= m_left && point.x >= m_left - 20;
    }
     */
}

/**
 * If point.x is greater than the last word in the same line's right boundary, return true
 */
- (BOOL) enterLineEndRegion: (CGPoint) point {
    if (!State.thisLineHasAtLeastOneWordSpoken) return NO;
    
    int i = [Doc getTheLastWordIDInTheSameLine];
    CGRect rect = [self getWordRect: i];
    
    if (point.x > rect.origin.x + rect.size.width && i - [State lastWordID] > 0) {
        [Log recordSkipWord: i - [State lastWordID]];
    }
    
    return point.x > rect.origin.x + rect.size.width;
}

/**
 * If point.x is greater than the last word in the same line's right boundary, return true
 */
- (BOOL) enterParaEndRegion: (CGPoint) point {
    if (!State.thisLineHasAtLeastOneWordSpoken) return NO;
    
    int i = [Doc getTheLastWordIDInTheSameLine];
    int j = [Doc getNextWordID:i];
    int k = State.nextWordID;
    
    if ([Doc getColFromWordIndex:k] != [Doc getColFromWordIndex:i] && State.hasEndColume) {
        return NO;
    }
    
    if ([Doc getParaFromWordIndex:i] == [Doc getParaFromWordIndex:j]) return NO;
    
    
    CGRect rect = [self getWordRect: i];
    float parabd = rect.origin.x + rect.size.width;
    
    
    if (point.x >= parabd && [Doc getColFromWordIndex:k] != [Doc getColFromWordIndex:i]) {
        State.hasEndColume = YES;
    }
    
    if (point.x >= parabd && i - [State lastWordID] > 0) {
        [Log recordSkipWord: i - [State lastWordID]];
    }
    
    return point.x >= parabd;
}

/**
 * Whether the point enters the next word region
 */
- (BOOL) enterNextWordRegion: (CGPoint) point {
    switch (State.mode) {
        case MD_SIGHTED:
            return (point.x > lblNext.frame.origin.x && point.x <= lblNext.frame.origin.x + lblNext.frame.size
                    .width + 50) || (point.x < lblNext.frame.origin.x && point.x >= lblNext.frame.origin.x - 10);
        default:
             return [lblNext contains: point];
    }
}

-(CGRect) getWordRectFromRange: (NSRange)range inColumn: (int) col {
    if (col > 0) {
        if (Doc.firstColumnCharacters == -1) {
            Doc.firstColumnCharacters = (int)range.location;
        }
        //range.location -= m_firstColumnCharacters;
        //lengthBefore = [[[self.layoutManager textContainers] objectAtIndex:0] text];
    }
        
    NSTextContainer* container = [[self.layoutManager textContainers] objectAtIndex:col];
    CGRect rect = [self.layoutManager boundingRectForGlyphRange:range inTextContainer:container];
    CGPoint offset = [self getOffsetFromColumn: col];
    rect.origin.x += offset.x + m_wordMargin.origin.x;
    rect.origin.y += offset.y + m_wordMargin.origin.y;
    rect.size.width -= m_wordMargin.size.width;
    rect.size.height -= m_wordMargin.size.height;
    
    // field of view modification
    if (State.mode != MD_SIGHTED) {
        CGFloat h = rect.size.height * State.fieldOfView;
        CGFloat center = rect.origin.y + rect.size.height / 2;
        rect.origin.y = center - h / 2;
        rect.size.height = h;
    } else {
        rect.origin.y -= 2;
        rect.size.height += 2;
    }
    
    return rect;
}

- (int) getWordIDFromPoint: (CGPoint) point {
    int col = [self getColumnFromPoint:point];
    
    NSTextContainer* container = [[self.layoutManager textContainers] objectAtIndex:col];
    CGPoint offset = [self getOffsetFromColumn: col];
    point.x -= offset.x;
    point.y -= offset.y;
    NSUInteger characterIndex = [self.layoutManager characterIndexForPoint:point inTextContainer:container fractionOfDistanceBetweenInsertionPoints:NULL];
    NSMutableDictionary* dict = [[self.textStorage attributesAtIndex:characterIndex effectiveRange:NULL] mutableCopy];

    if (dict == nil) {
        NSLog(@"Catch a bug!!!! %@", NSStringFromCGPoint(point));
        return 0;
    }
    int ans = [dict getID];
    if (ans < 0 || ans >= [Doc numActualWords] ) {
        NSLog(@"Catch a bug beyond!!!! %@", NSStringFromCGPoint(point));
        ans = State.currentWordID; 
    }
    return ans;
}

-(CGRect) getWordRect: (int) wordIndex {
    NSUInteger characterIndex = [[Doc.arrWordStartIndex objectAtIndex:wordIndex] intValue];
    if (characterIndex < self.textStorage.length) {
        NSRange range;
        [self.textStorage attributesAtIndex:characterIndex effectiveRange:&range];
        return [self getWordRectFromRange:range inColumn: [Doc getColFromWordIndex: wordIndex]];
    } else {
        return INVISIBLE_RECT;
    }
}

- (void) copyLastWordRegion {
    lblLast.frame = lblCurrent.frame;
}

/**
 * Current = Previous next
 */
- (void) setupCurrentWordID {
    State.currentWordID = State.nextWordID;
}

- (void) setupNextWordID {
    State.nextWordID = [Doc getNextWordID:[State currentWordID]];
}

- (void) waitTaskEnd {
    State.waitTaskEnd = YES;
}

/**
 * Setup Next Word Region
 */
- (void) setupNextWordRegion {
    lblNext.frame = [self getWordRect: State.nextWordID];
    [self setupRectVisibility];
}

/**
 * Setup line state
 */
- (void) setupLineState {
    NSMutableDictionary* a = [Doc getWordDict:State.currentWordID];
    NSMutableDictionary* b = [Doc getWordDict:State.nextWordID];
    if (a == nil || b == nil) return;
    
    if ([b getPara] != [a getPara]) {
        [self waitParaEnd];
    } else
    if ([b getLine] != [a getLine]){
        [self waitLineEnd];
    }
}

/**
 * Test if current word has skipped the next word
 */
- (BOOL) skipNextWord: (CGPoint) point {
    if (State.currentWordID == -1 || State.lastWordID == -1) return NO;
    if (State.currentWordID <= State.lastWordID) return NO;
    //int wid = [self getWordIDFromPoint: point];
    NSMutableDictionary* a = [Doc getWordDict: State.lastWordID];
    NSMutableDictionary* b = [Doc getWordDict: State.currentWordID];
    
    /*
    if ([a getLine] == [b getLine] && [a getColumn] == [b getColumn] && [a getPara] == [b getPara]) {
        NSLog(@"Skip words");
    }
     */
    return [a getLine] == [b getLine] && [a getColumn] == [b getColumn] && [a getPara] == [b getPara];
}

- (BOOL) inTwoLines: (CGRect)a aboveOn:(CGRect)b {
    return a.origin.y + a.size.height < b.origin.y + b.size.height - m_lineSpacing;
}

- (BOOL) inTwoColumns: (CGRect)a leftOn:(CGRect)b {
    return a.origin.y > b.origin.y + m_textHeight * 10;
}

/**
 * Calculate the attributes of each word.
 */
- (void) addAttributes {
    int i = -1;
    int lastID = i;
    NSMutableDictionary* dict;
    CGRect rect = [self getWordRect:0];
    CGRect lastRect = rect; 
    int para = 0;
    int line = 0;
    int totalLines = 1;
    int col = 0;
    
    for (int i = 0; i < Doc.textEndID; ++i) {
        dict = [Doc getWordDict:i];
        [dict setLine: -1];
        [dict setPara: -1];
        [dict setColumn: 0];
        
    }
    [Doc.lineWidth removeAllObjects];
    [Doc.lineCenterY removeAllObjects];
    
    while (i < Doc.textEndID) {
        
        lastID = i;
        i = [Doc getNextWordID:i];
        if (i >= [Doc.arrWordDict count] - 1) {
            
            if (col == 0) {
                [Doc.lineWidth addObject: [NSNumber numberWithFloat:rect.origin.x + rect.size.width - m_left]];
                [Doc.lineCenterY addObject: [NSNumber numberWithInt: rect.origin.y + rect.size.height / 2 ] ];
            } else
                if (col == 1) {
                    [Doc.lineWidth addObject: [NSNumber numberWithFloat:rect.origin.x + rect.size.width - m_left - m_columnWidth - m_columnSpacing]];
                    [Doc.lineCenterY addObject: [NSNumber numberWithInt: rect.origin.y + rect.size.height / 2 ] ];
                }
            break; // No next word though
        }

        int previousCol = col;
        
        if (i != lastID + 1) {
            ++para;
            ++line;
            //line = 1;
            ++totalLines;
            if (totalLines > 20) {
                col = 1;
            }
            
            if ((State.documentType == DT_B) && State.categoryType == CT_MAGAZINE) {
                if (totalLines > 13) {
                    col = 1;
                }
            }
        }
        
        lastRect = rect;
        dict = [Doc getWordDict:i];
        [dict setColumn: col];
        rect = [self getWordRect:i];
        
        [self setupRectVisibility];
        
        lblLast.frame = lastRect;
        lblCurrent.frame = rect;
        
        
        if ([self inTwoLines:lastRect aboveOn:rect] || (previousCol == 0 && col == 1))
        {
            if (previousCol == 0) {
                [Doc.lineWidth addObject: [NSNumber numberWithFloat:lastRect.origin.x + lastRect.size.width - m_left]];
                [Doc.lineCenterY addObject: [NSNumber numberWithInt: lastRect.origin.y + lastRect.size.height / 2 ] ];
            } else
            if (previousCol == 1) {
                [Doc.lineWidth addObject: [NSNumber numberWithFloat:lastRect.origin.x + lastRect.size.width - m_left - m_columnWidth - m_columnSpacing]];
                [Doc.lineCenterY addObject: [NSNumber numberWithInt: lastRect.origin.y + lastRect.size.height / 2 ] ];
            }
            
            ++line;
            ++totalLines;
        }
        
        [dict setLine: line];
        [dict setPara: para];
        
        // print every line
        //NSLog(@"%d|%@:\t%d,%d,%d; %@, %@", i, [dict getKey], [dict getLine], [dict getPara], [dict getColumn], NSStringFromCGRect(lastRect), NSStringFromCGRect(rect) );
        NSLog(@"\"%d\", \"%@\", \"%d\", \"%d\" , \"%d\"", [dict getID], [dict getKey], [dict getLine], [dict getPara], [dict getColumn] );
        //NSLog(@"How many lines in total: %d", [Doc.lineWidth count]);}
    }
    
    int lid = 0;
    for (NSNumber *num in Doc.lineWidth) {
        NSLog(@"%d | LineWidth: %.1f", lid++, [num floatValue]);
    }
    //NSLog(@"How many lines in total: %d", [Doc.lineWidth count]);
    //NSLog(@"Linewidth: %@", Doc.lineWidth);
    NSLog(@"LineCenterY: %@", Doc.lineCenterY);

    NSLog(@"========= Add attributes end =============");
    State.numWords = (int)[Doc numActualWords];
}

- (void) setupLineEndRegion {
    if ([self isLeftColumn]) {
        [lblLineEnd setFrame: CGRectMake(m_left + m_columnWidth, 0, m_columnSpacing, m_height)];
    } else {
        [lblLineEnd setFrame: CGRectMake(m_width - m_right, 0, m_right, m_height)];
    }
    [lblLineEnd setHidden: NO];
}

- (void) setupLineBeginRegion {
    if ([self isRightColumn]) {
        [lblLineBegin setFrame: CGRectMake(m_left + m_columnWidth + m_columnSpacing - 40, 0, 60, m_height)];
    } else {
        [lblLineBegin setFrame: CGRectMake(m_left - 40, 0, 60, m_height)];
    }
    [lblLineBegin setHidden: NO];
    

}

- (void) moveToBeginningOfNextLine {
    int i = State.lastWordID;
    int j = State.lastWordID;
    
    do {
        j = [Doc getNextWordID:j];
    } while ([Doc inTheSameLine:i with:j]|| j >= [Doc.arrWordDict count] );
    
    State.nextWordID = j; 
    [lblNext setFrame: [self getWordRect:j]];
}

- (void) waitLineEnd {
    [self setupLineEndRegion];
    [self moveToBeginningOfNextLine];
    State.waitLineEnd = YES;
    State.waitParaEnd = NO;
    State.waitLineBegin = NO;
    [lblLineBegin setHidden:YES];
    [Feedback verticalStop];
}

- (void) cancelWaitLineBegin {
    State.waitLineBegin = NO;
    [lblLineBegin setHidden: YES];
}

- (void) waitLineBegin {
    State.waitLineEnd = NO;
    State.waitParaEnd = NO;
    State.waitLineBegin = YES;
    [lblLineEnd setHidden:YES];
    [self setupLineBeginRegion];
    [Feedback verticalStop];
}

- (void) waitParaEnd {
    [self setupLineEndRegion];
    [self moveToBeginningOfNextLine];

    State.waitLineEnd = NO;
    State.waitParaEnd = YES;
    State.waitLineBegin = NO;
    
    [lblLineBegin setHidden:YES];
    [lblCurrent setHidden:YES];
    [Feedback verticalStop];
}

/**
 * Feedback Value
 * ++++++++++
 *  The Line
 * ----------
 **/
- (CGFloat) getFeedbackValueFromPoint: (CGPoint) point {
    CGFloat y = point.y;
    CGFloat center = lblNext.frame.origin.y + lblNext.frame.size.height / 2;
    CGFloat delta = center - y;
    
    [Stat distance:point.x withY: delta];
    
    if (fabs(delta) <= m_lineHeight / 2) delta = 0;
    if (delta > State.maxFeedbackValue) delta = State.maxFeedbackValue; else if (delta < State.minFeedbackValue) delta = State.minFeedbackValue;
    return delta;
}

- (void) calcDocument {
    if (State.softwareStarted) return;
    
    [self addAttributes];
    State.lastWordID = -1; //195; //108;
    
    if ([State categoryType] == CT_MAGAZINE) {
        switch ([State documentType]) {
            case DT_TRAIN:
                State.lastWordID = 28+13+1+4+4+4+2+2-1-1;
                break;
            case DT_A:
                State.lastWordID = 74-2;
                break;
            case DT_B:
                State.lastWordID = 51-15-1+6;
                break;
            case DT_C:
                State.lastWordID = 65-1;
                break;
            case DT_D:
                State.lastWordID = 65;
                break;
            default:
                break;
        }
        State.waitLineBegin = false; 
    }
    
    State.currentWordID = State.lastWordID;
    State.nextWordID = State.currentWordID + 1;
    
    State.softwareStarted = true;
}

/**
 * Task Start
 * 1. Calculate the attributes of each word
 * 2. Setup next word region = 0
 */
- (void) taskStart {
    [self calcDocument];
    [lblStart setHidden: YES];
    [self setupNextWordRegion];
    
}

- (void) setupCurrentWordRect: (CGPoint) point {
    State.currentWordID = [self getWordIDFromPoint: point];
    State.paraID = [Doc getParaFromWordIndex: State.currentWordID];
    
    [lblCurrent setFrame: [self getWordRect: State.currentWordID] ];
    
    if (lblCurrent.frame.origin.x == lblNext.frame.origin.x) {
        [lblCurrent setHidden: YES];
    } else
    if (lblCurrent.frame.origin.x == lblLast.frame.origin.x) {
        [lblCurrent setHidden: YES];
    } else {
        [lblCurrent setHidden: NO];
    }
    
    if ([[Doc getKeyFromWordIndex: State.currentWordID] isNotAWord]) {
        [lblCurrent setHidden: YES];
    }
}

- (void) speakCurrentWord {
    State.lastWordID = State.currentWordID;
    lblLast.frame = lblCurrent.frame;
    [self speakWord:State.currentWordID];
}

- (void) speakWord: (int)wordID {
    //State.lineID = [Doc getLineFromWordIndex: wordID];
    //State.paraID = [Doc getParaFromWordIndex: wordID];
    
    [Feedback verticalStop];
    [Feedback speekCurrentWord: [[Doc getWordDict:wordID] getKey]];
    State.thisLineHasAtLeastOneWordSpoken = true;
}

- (void) sightedReading: (CGPoint) point {
    if ([self enterNextWordRegion:point]) {
        // speak next word
        {
            State.lastWordID = State.nextWordID;
            lblLast.frame = lblNext.frame;
            [Feedback speekCurrentWord: [[Doc getWordDict:State.lastWordID] getKey]];
        }
        
        // setup next word id
        State.nextWordID = [Doc getNextWordID:[State lastWordID]];
        
        // see if exceed
        if (State.nextWordID >= [Doc.arrWordDict count] - 1) {
            lblNext.frame = INVISIBLE_RECT;
            [Feedback paraEnd];
            [Feedback taskEnd];
            State.taskEnded = YES;
            return;
        }
        
        // setup next word region
        lblNext.frame = [self getWordRect: State.nextWordID];
        [self setupRectVisibility];
        
        // clear the rest frames if overlaped
        if (lblNext.frame.origin.x == lblLast.frame.origin.x) [lblLast setHidden:YES];
    }
    
    return;
}

- (void) trainVerticalBox {
    if (State.feedbackStepByStep == StepVertical) {
        [lblTrainBG setHidden: NO];
        [lblTrain setHidden: NO];
        [lblCurrent setHidden: YES];
        [lblNext setHidden: YES];
        [lblStart setHidden: YES];
        State.mode = MD_READING;
    }
}

- (void) trainElse {
    if (State.isTrainingMode) {
        [lblStart setHidden: YES];
        [lblTrainBG setHidden: YES];
        [lblTrain setHidden: YES];
        [lblCurrent setHidden: YES];
        [lblNext setHidden: NO];
        State.mode = MD_READING;
    }
}

- (void) gotoBeginning {
    
}

- (void) gotoNextLine {
    
}

- (void) exploreText: (CGPoint) point {
    if ((State.automaticMode && State.automaticExploration)) {
        if ([self enterLineBeginRegion:point]) {
            [self cancelWaitLineBegin];
            return [Feedback lineBegin];
        }
    }
    
    if (Doc.hasTitle && [lblTitle contains:point]) {
        return [Feedback overTitle];
    }
    
    for (int i = (Doc.hasTitle ? 1 : 0); i < [m_arrLblPara count]; ++i) {
        if ([ [m_arrLblPara objectAtIndex:i] contains: point ] ) {
            return [Feedback overParagraph: (Doc.hasTitle ? i : i+1) ];
        }
    }
    
    for (UIImageView* v in m_arrImg) {
        if ([v contains:point]) {
            return [Feedback overPicture];
        }
    }
    
    return [Feedback overSpacing];
}

/**
 * Handle Single Touch
 *
 * A. See if it's started or not
 * B. Exploration
 *    1. title
 *    2. paragraph
 *    3. image
 * C. Details
 *    1. waitLineBegin
 *    2. waitLineEnd / ParaEnd / ColEnd
 *    3. get current word
 *    4. if next Word, speak current word, find the next word
 *    5. if in the same line but further, skip word, speak current word, find the next word
 *    6. whenever reached the end of line / para, wait line end.
 */
- (void)handleSingleTouch:(CGPoint) point {
    if ([State isTrainingMode]) State.mode = MD_READING;
    if (point.x == 0 && point.y == 0) return;
    
    if ([State isExplorationTextMode]) {
        return [self exploreText: point];
    }
    
    if ([State taskEnded]) return;
    
    if (![State isTrainingMode] && ![State taskStarted]) {
        if ([lblStart contains:point] || [State sightedReading]) {
            [self taskStart];
            return [Feedback taskStart];
        }
        return;
    }
    
    if (![State softwareStarted]) return;
    
    if (State.feedbackStepByStep == StepVertical) {
        [lblTrain setHidden: NO];
        
        CGFloat y = point.y;
        CGFloat center = lblTrain.frame.origin.y + m_lineHeight / 2;
        CGFloat delta = center - y;
        
        if (fabs(delta) <= m_lineHeight / 2) delta = 0;
        if (delta > State.maxFeedbackValue) delta = State.maxFeedbackValue; else if (delta < State.minFeedbackValue) delta = State.minFeedbackValue;

        if (delta == 0) {
            [Feedback verticalStop];
        } else {
            [Feedback verticalFeedback: delta];
        }
        return;
    } else {
        [lblTrain setHidden: YES];
    }
    
    /*
    if (!State.hasEndColume) {
        if (point.x < m_left - 10) return;
    } else {
        if (point.x < m_left + m_columnWidth + m_columnSpacing - 10) return;
    }
     */
    
    if ([State sightedReading]) return [self sightedReading: point];
    
    if ([State waitLineBegin]) {
        if ([self enterLineBeginRegion:point]) {
            [self cancelWaitLineBegin];
            
            
            State.lineID = [Doc getLineFromWordIndex: State.nextWordID];
            if (State.lineID < [Doc.lineWidth count]) {
                State.lineWidth = [[Doc.lineWidth objectAtIndex:State.lineID] intValue];
            }
            State.lineCenterY = lblNext.frame.origin.y + lblNext.frame.size.height / 2;
            
            return [Feedback lineBegin];
        }
        return;
    }
    
    /*
    if (point.x < m_lblLineBeginX) {
        return; 
    }
     */
    
    if ([State waitParaEnd]) {
        if ([self enterParaEndRegion:point]) {
            [self waitLineBegin];
            [Feedback paraEnd];
        }
        return;
    }
    
    if ([State waitLineEnd]) {
        if ([self enterLineEndRegion:point]) {
            [self waitLineBegin];
            return [Feedback lineEnd];
        }
        return;
    }
    
    if ([State waitTaskEnd]) {
        if (point.x > lblNext.frame.origin.x + lblNext.frame.size.width) {
            State.waitTaskEnd = NO;
            State.softwareStarted = NO;
            [Feedback paraEnd];
            return [Feedback taskEnd];
        }
    }
    
    [self setupCurrentWordRect: point];
    [self hideLineLabels];
    
    if ([self enterNextWordRegion:point]) {
        State.lastWordID = State.nextWordID;
        lblLast.frame = lblNext.frame;
        
        State.lineID = [Doc getLineFromWordIndex: State.lastWordID];
        if (State.lineID < [Doc.lineWidth count]) {
            State.lineWidth = [[Doc.lineWidth objectAtIndex:State.lineID] intValue];
        }
        State.lineCenterY = lblLast.frame.origin.y + lblLast.frame.size.height / 2;
        
        [self speakWord: State.lastWordID];

        //setup next word id
        State.nextWordID = [Doc getNextWordID:[State lastWordID]];
        
        NSLog(@"State current %d, lastWordID %d, nextWordID %d", [State currentWordID], [State lastWordID], [State nextWordID]);
        
        if (State.nextWordID >= [Doc.arrWordDict count] - 1) {
            lblNext.frame = INVISIBLE_RECT;
            return [self waitTaskEnd];
        }
        
        if (State.documentType == DT_B && State.categoryType == CT_MAGAZINE) {
            if (State.nextWordID >= 200) {
                lblNext.frame = INVISIBLE_RECT;
                [Feedback paraEnd];
                [Feedback taskEnd];
                State.taskEnded = YES;
                return;
            }
        }
        
        [self setupNextWordRegion];
        
        // setup line state
        NSMutableDictionary* a = [Doc getWordDict:State.lastWordID];
        NSMutableDictionary* b = [Doc getWordDict:State.nextWordID];
        if (a == nil || b == nil) return;
        
        if ([b getPara] != [a getPara]) {
            [self waitParaEnd];
        } else
        if ([b getLine] != [a getLine]){
            [self waitLineEnd];
        }
        
        if ([a getColumn] != [b getColumn]) {
            [self waitLineBegin];
            [Feedback paraEnd];
        }
        
        [self setupRectVisibility];
        return;
    }
    
    if ([self enterLineEndRegion:point]) {
        [self waitLineEnd];
        return;
    }
    
    // enable to enter para end before saying the last word in the paragraph
    
    if ([self enterParaEndRegion:point]) {
        NSLog(@"[Reading] Enter Para End Region");
        [self waitParaEnd];
        return;
    }
    
    if ([self skipNextWord:point]) {
        NSLog(@"Skip next word! State currentword %d lastWordID %d, nextWordID %d", [State currentWordID], [State lastWordID], [State nextWordID]);
        [Stat skipWord: [State currentWordID] - [State lastWordID] - 1];
        [Log recordSkipWord: [State currentWordID] - [State lastWordID] - 1];
        [self speakCurrentWord];
        
        State.lineID = [Doc getLineFromWordIndex: State.currentWordID];
        if (State.lineID < [Doc.lineWidth count]) {
            State.lineWidth = [[Doc.lineWidth objectAtIndex:State.lineID] intValue];
        }
        State.lineCenterY = lblCurrent.frame.origin.y + lblCurrent.frame.size.height / 2;
        
        [self setupNextWordID];
        if (State.nextWordID >= [Doc.arrWordDict count] - 1) {
            return [self waitTaskEnd];
        }
        
        [self setupNextWordRegion];
        [self setupLineState];
        return;
    }
    
    CGFloat delta = [self getFeedbackValueFromPoint:point];
    
    if (delta == 0) {
        [Feedback verticalStop];
    } else {
        [Feedback verticalFeedback: delta];
    }
}

- (void) setupRectVisibility {
    [lblNext setHidden: NO];
    
    if ([State debugMode]) {
        [lblLast setHidden: NO];
        [lblCurrent setHidden: NO];
        
        // clear the rest frames if overlaped
        if (lblNext.frame.origin.x == lblLast.frame.origin.x) [lblLast setHidden:YES];
        if (lblNext.frame.origin.x == lblCurrent.frame.origin.x) [lblCurrent setHidden:YES];
    } else {
        [lblLast setHidden: YES];
        [lblCurrent setHidden: YES];
    }
}

- (void) clearViews {
    [super clearViews];
}


- (void) updateTouchLog {
    
    NSString *res = [NSString stringWithFormat:@"%lu touches:", (unsigned long)[State.activeTouches count] ];
    NSString *log = @"";
    for (UITouch *touch in State.activeTouches) {
        
        NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[touch hash]];
        int hand = [[State.touchDict objectForKey:key] intValue];
        NSString *type = @"Single";
        if (hand == 1) type = @"Left"; else if (hand==2) type=@"Right"; else if (hand==3) type=@"Extra";
        
        NSValue *touchValue = [NSValue valueWithPointer:(__bridge const void *)(touch)];
        NSString *touchID = [NSString stringWithFormat:@"%@", touchValue];
        
        res = [NSString stringWithFormat:@"%@\t[%@-%@]%@", res, type, touchID, NSStringFromCGPoint([touch locationInView:self])];
        log = [NSString stringWithFormat:@"%@\t%@\t%@\t%@", log, type, touchID, NSStringFromCGPoint([touch locationInView:self])];
    }
    
    if (State.debugMode) {
        [lblPointLog setText:res];
    }
    [Log recordTouchLog: log withNumTouches: [State.activeTouches count]];
}




@end

