//
//  HSFile.h
//  HandSight
//
//  Created by Ruofei Du on 7/21/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSFile : NSObject {
    NSString* m_fileName; 
}


+ (HSFile*) sharedInstance;
- (NSString *)read: (NSString *)fileName;
- (NSString *)readTxt: (NSString *)fileName; 
- (void) write:(NSString *)fileName data:(id)data;
- (void)write:(NSString *)fileName dataArray:(NSArray *)data;

- (NSString*) fileName;
- (NSString*) userID;

@end
