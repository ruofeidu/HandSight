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
}

- (void)reset;
- (void)add: (CGFloat)value;
- (CGFloat)average;
- (CGFloat)avg;
- (CGFloat)stddev;
- (CGFloat)std;
- (CGFloat)max;
- (CGFloat)min; 
- (int)count;

@end
