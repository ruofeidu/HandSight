//
//  HSString.m
//  HandSight
//
//  Created by Ruofei Du on 7/18/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSString.h"

@implementation NSString (HandSight)

- (BOOL) isEnded {
    return [self rangeOfString:@","].location != NSNotFound || [self rangeOfString:@"."].location != NSNotFound || [self rangeOfString:@"!"].location != NSNotFound;
}

- (BOOL) isEmpty {
    return [self isEqualToString:@""] ;
}

- (BOOL) isSpoken {
    return [self hasSuffix:@"$$$"];
}

- (BOOL) isLineBreak {
    return [self isEqualToString:@"\n"] || [self isEqualToString:@"\r"];
}

- (BOOL) isNotAWord {
    for (int i = 0; i < self.length; ++i){
        unichar c = [self characterAtIndex:i];
        if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) return NO;
    }
    return YES;
}

@end
