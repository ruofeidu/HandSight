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
    
    m_timerStart = 0;
    m_timerTime = 0;
}

- (void)add: (CGFloat)value {
    [m_arr addObject: [NSNumber numberWithFloat: value]];
    if (value > m_max) m_max = value;
    if (value < m_min) m_min = value;
}

- (CGFloat)average {
    return [self sum] / [self count];
}

- (CGFloat)sum {
    if ([self count] == 0) return 0;
    CGFloat sum = 0.0f;
    
    for (NSNumber *value in m_arr) {
        sum += [value floatValue];
    }
    return sum;
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

// add signal
- (void)flip {
    if ([self count] == 0) {
        [self add:1.0];
    } else {
        if ([self last] != 1.0) {
            [self add:1.0];
        }
    }
}

- (void)start: (CGFloat)value {
    if (m_timerStart == 0) {
        m_timerStart = value;
    }
}

- (void)end: (CGFloat)value {
    
    if (m_timerStart != 0) {
        m_timerTime += value - m_timerStart;
        m_timerStart = 0;
    }
}

- (CGFloat)timeCount {
    return m_timerTime;
}

// remove signal
- (void)flop {
    if ([self count] == 0) return;
    
    if ([self last] != 0.0) {
        [self add:0.0];
    }
}

- (float)last {
    if ([self count] == 0) return -1.0; else return [[m_arr objectAtIndex: [self count] - 1 ] floatValue];
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
