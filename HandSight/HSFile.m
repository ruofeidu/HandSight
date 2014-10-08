//
//  HSFile.m
//  HandSight
//
//  Created by Ruofei Du on 7/21/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSFile.h"

@implementation HSFile


- (id)init
{
    self = [super init];
    
    if (self) {
        NSLog(@"[FI] Inited");
        NSDateFormatter *formatter;
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMdd_HHmmss"];
        m_fileName = [formatter stringFromDate:[NSDate date]];
    }
    
    return self;
}

+ (HSFile*) sharedInstance
{
    static  HSFile* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self  alloc] init];
    });
    return  sharedInstance;
}

- (NSString *)readTxt:(NSString *)fileName {
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: fileName ofType: @"txt"] usedEncoding:nil error:nil];
}

- (NSString *)read:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:appFile])
    {
        NSError *error= NULL;
        
        id resultData=[NSString stringWithContentsOfFile:appFile encoding:NSUTF8StringEncoding error:&error];
        
        if (error != NULL) return resultData; else NSLog(@"[FI] Error reading %@", fileName);
    }
    return NULL;
}

- (NSString*) fileName {
    return m_fileName; 
}

- (NSString*) userID {
    return m_fileName;
}

// write data to file
- (void) write:(NSString *)fileName data:(id)data
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSError *error = NULL;
    
    
    [data writeToFile:appFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error != NULL)
    {
        NSLog(@"[FI] Error writing to file %@", fileName);
    }
}


- (void)write:(NSString *)fileName dataArray:(NSArray *)data
{
    NSMutableString *dataString=[NSMutableString stringWithString:@""];
    for (int i = 0; i < [data count]; i++)
    {
        if (i == [data count]-1)
        {
            [(NSMutableString *)dataString appendFormat:@"%@",[data objectAtIndex:i]];
        }
        else
        {
            [(NSMutableString *)dataString appendFormat:@"%@\n",[data objectAtIndex:i]];
        }
    }
    [self write:fileName data:dataString];
}


-(void) append:(NSString *)fileName data:(NSString*) savedString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:appFile];
    [myHandle seekToEndOfFile];
    [myHandle writeData:[savedString dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
