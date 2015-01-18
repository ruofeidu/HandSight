//
//  HSString.h
//  HandSight
//
//  Created by Ruofei Du on 7/18/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HandSight)

-(BOOL) isEnded;
-(BOOL) isEmpty;
-(BOOL) isSpoken;

-(BOOL) isLineBreak; 
-(BOOL) isNotAWord;

@end
