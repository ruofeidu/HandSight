//
//  DesignPattern.h
//  HandSight
//
//  Created by Ruofei Du on 7/17/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

// A better version of NSLog
#define NSLog(format, ...) do {                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
        __LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \

