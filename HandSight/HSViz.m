//
//  HSViz.m
//  HandSight
//
//  Created by Ruofei Du on 8/14/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSViz.h"

@implementation HSViz

+ (HSViz*) sharedInstance
{
    static  HSViz* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self alloc] init];
    });
    return  sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)reset {
    NSLog(@"[Viz] Reset");
    
    m_curveLength       =           0.0f;
    m_lineWidth         =           3.0f;
    m_width             =           1024.0f;
    m_height            =           768.0f;
    self.frame          =           CGRectMake(0, 0, m_width, m_height);
    self.alpha          =           1.0f;
    
    State               =           [HSState sharedInstance];
    return;
    [self setHidden: YES]; 
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void) touchDown: (CGPoint) point {
    return;
    m_prevPoint = point;
    [self render: point];
}

- (void) touchUp: (CGPoint) point {
    return;
    [self render: point];
    m_prevPoint = point;
}

- (void) touchMove: (CGPoint) point {
    return;
    [self render: point];
    m_prevPoint = point;
}

- (void) render: (CGPoint) point {
    return;
    if ([State waitLineBegin] || [State waitLineEnd] || [State waitParaEnd]) return;
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 4.0);
    
    CGContextSetRGBStrokeColor(ctx, 1.0f, 0.0f, 0.0f, 1.0f);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, m_prevPoint.x, m_prevPoint.y);
    CGContextAddLineToPoint(ctx, point.x, point.y);
    m_curveLength += sqrtf((m_prevPoint.x - point.x) * (m_prevPoint.x - point.x) + (m_prevPoint.y - point.y) * (m_prevPoint.y - point.y) );
    
    CGContextStrokePath(ctx);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
