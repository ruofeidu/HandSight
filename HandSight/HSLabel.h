//
//  HSLabel.h
//  HandSight
//
//  Created by Ruofei Du on 7/29/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UILabel (HandSight)

-(BOOL) contains: (CGPoint) point;

@end


// Detail Mode
/*
 CGPoint offset =
 point.x -= offset.x;        point.y -= offset.y;
 
 NSTextContainer* container = [[self.layoutManager textContainers] objectAtIndex:col];
 CGFloat dist;
 NSRange range;
 NSUInteger characterIndex = [self.layoutManager characterIndexForPoint:point inTextContainer:container fractionOfDistanceBetweenInsertionPoints:&dist];
 
 [self.textStorage attributesAtIndex:characterIndex effectiveRange:&range];
 
 CGRect rect = [self.layoutManager boundingRectForGlyphRange:range inTextContainer:container];
 //[self.layoutManager layoutRectForTextBlock: range];
 rect.origin.x += offset.x + m_wordMargin.origin.x;
 rect.origin.y += offset.y + m_wordMargin.origin.y;
 
 rect.size.width -= m_wordMargin.size.width;
 rect.size.height -= m_wordMargin.size.height;
 
 
 NSLog(@"[ST] C%d-%lu ~%.2f %@", col, (unsigned long)characterIndex, dist, NSStringFromCGRect(rect));
 
 [lblCurrent setFrame:rect];
 [lblCurrent setHidden:NO];
 */


/*
 CGRect frame = [self frameOfTextRange:range inTextView:view];
 NSLog(@"[ST] text view frame: %@", NSStringFromCGRect([view frame]));
 
 NSLog(@"[ST] C%d-%lu ~%.2f %@", col, (unsigned long)characterIndex, dist, NSStringFromCGRect(frame));
 
 [lblCurrent setFrame:frame];
 */
