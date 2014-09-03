//
//  HSMeasure.m
//  
//
//  Created by Ruofei Du on 8/19/14.
//
//

#import "HSMeasure.h"

@implementation HSMeasure

- (id)init {
    self = [super init];
    if (self) {
        m_arr = [NSMutableArray array];
        [self reset];
    }
    return self;
}

- (void)reset {
    [m_arr removeAllObjects];
    m_min = 65536.0f;
    m_max = -m_min;
}

- (void)add: (CGFloat)value {
    [m_arr addObject: [NSNumber numberWithFloat: value]];
    if (value > m_max) m_max = value;
    if (value < m_min) m_min = value;
}

- (CGFloat)average {
    if ([self count] == 0) return 0;
    CGFloat sum = 0.0f;
    
    for (NSNumber *value in m_arr) {
        sum += [value floatValue];
    }
    
    return sum / [self count];
}

- (CGFloat)stddev {
    if ([self count] == 0) return 0;
    CGFloat avg = [self average];
    CGFloat sum = 0.0f;
    
    for (NSNumber *value in m_arr) {
        sum += ([value floatValue] - avg) * ([value floatValue] - avg);
    }
    
    return sqrt(sum / [self count]);
}

- (int)count {
    return (int)[m_arr count];
}

- (CGFloat)avg {
    return [self average];
}

- (CGFloat)std {
    return [self stddev]; 
}

- (CGFloat)max {
    return m_max;
}

- (CGFloat)min {
    return m_min; 
}


@end
