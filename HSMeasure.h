//
//  HSMeasure.h
//  
//
//  Created by Ruofei Du on 8/19/14.
//
//

#import <Foundation/Foundation.h>

@interface HSMeasure : NSObject {
    NSMutableArray* m_arr;
    CGFloat m_average;
    CGFloat m_stddev;
    CGFloat m_max;
    CGFloat m_min;
    
    CGFloat m_timerStart;
    CGFloat m_timerTime;
}

- (void)reset;
- (void)add: (CGFloat)value;
- (CGFloat)average;
- (CGFloat)avg;
- (float)sum;
- (CGFloat)stddev;
- (CGFloat)std;
- (CGFloat)max;
- (CGFloat)min;

- (void)start: (CGFloat)value;
- (void)end: (CGFloat)value;
- (CGFloat)timeCount;

- (CGFloat)last;
- (int)count;

- (void)flip;
- (void)flop;


@end
