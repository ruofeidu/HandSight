//
//  HSDebug.h
//  HandSight
//
//  Created by Ruofei Du on 7/11/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define Debug(...) NSLog(@"[Debug] %s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define DebugUI(...) NSLog(@"[UI] %s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define DebugTouch(...) NSLog(@"[Touch] %s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define DebugPara(...) NSLog(@"[Para] %s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define DebugFeedback(...) NSLog(@"[Feedback] %s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define Debug(...) do { } while (0)
#define DebugUI(...) do { } while (0)
#define DebugTouch(...) do { } while (0)
#define DebugPara(...) do { } while (0)
#define DebugFeedback(...) do { } while (0)
#endif

@interface HSDebug : NSObject {
    
}

+ (void)Print:(NSString *)str;
@end
