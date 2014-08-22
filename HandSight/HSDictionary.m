//
//  HSMutableAttributedString.m
//  HandSight
//
//  Created by Ruofei Du on 8/1/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSDictionary.h"

@implementation NSMutableDictionary (HandSight)

-(id) getKey {
    return [self objectForKey:@"key"];
}

-(int) getLine {
    return [[self objectForKey:@"line"] intValue];
}

-(int) getPara {
    return [[self objectForKey:@"para"] intValue];
}

-(int) getLength {
    return [[self objectForKey:@"length"] intValue];
}

-(int) getColumn {
    return [[self objectForKey:@"column"] intValue];
}

-(int) getID {
    return [[self objectForKey:@"id"] intValue];
}

-(void) setKey:(NSString *)key {
    [self setValue:key forKey:@"key"];
}

-(void) setLine:(int)num {
    [self setValue:[NSNumber numberWithInteger:num] forKey:@"line"];
}

-(void) setPara:(int)para {
    [self setValue:[NSNumber numberWithInteger:para] forKey:@"para"];
}

-(void) setLength:(int)length {
    [self setValue:[NSNumber numberWithInteger:length] forKey:@"length"];
}

-(void) setColumn:(int)col {
    [self setValue:[NSNumber numberWithInteger:col] forKey:@"column"];
}

-(void) setID:(int)ID {
    [self setValue:[NSNumber numberWithInteger:ID] forKey:@"id"];
}


-(BOOL) isFirstColumn {
    return [self getColumn] == 0;
}

-(BOOL) isSecondColumn {
    return [self getColumn] == 1;
}


@end
