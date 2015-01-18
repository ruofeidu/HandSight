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


-(void) setEvent:(NSString *)event {
    [self setValue:event forKey:@"Event"];
}

-(void) setDate:(NSString *)key {
    [self setValue:key forKey:@"Date"];
}

-(void) setTime:(float)timeStamp {
    [self setValue:[NSNumber numberWithFloat:timeStamp] forKey:@"Time"];
}

-(BOOL) isFirstColumn {
    return [self getColumn] == 0;
}

-(BOOL) isSecondColumn {
    return [self getColumn] == 1;
}

-(void) setVibrationPower: (float) c {
    [self setValue:[NSNumber numberWithFloat:c] forKey:@"Relative-distance"];

}

-(void) setFrequency: (float) c {
    [self setValue:[NSNumber numberWithFloat:c] forKey:@"Audio-frequency"];

}

-(void) setLineCenterY: (float) c {
    [self setValue:[NSNumber numberWithFloat:c] forKey:@"Line-centerY"];
}


-(void) setX: (float) x {
    [self setValue:[NSNumber numberWithFloat:x] forKey:@"x"];
}
-(void) setY: (float) y {
    [self setValue:[NSNumber numberWithFloat:y] forKey:@"y"];
}

-(void) setLineWidth: (float) c {
    [self setValue:[NSNumber numberWithFloat:c] forKey:@"Line-width"];
}

-(void) setSpeed: (float) c {
    [self setValue:[NSNumber numberWithFloat:c] forKey:@"Speed"];
}

-(void) setCatgory: (int) c {
    [self setValue:[NSNumber numberWithInteger:c] forKey:@"Category"];
}


-(void) setVibrationCommand: (int) c {
    [self setValue:[NSNumber numberWithInteger:c] forKey:@"Vibration-command"];
}


-(void) setDocument: (int) c {
    
    [self setValue:[NSNumber numberWithInteger:c] forKey:@"Document"];
}

-(void) setFeedback: (int) c {
    
    if (c == 0) {
        [self setValue:@"Audio" forKey:@"Feedback-type"];
    } else {
        [self setValue:@"Haptio" forKey:@"Feedback-type"];
    }
}

-(void) setLineID: (int) c {
    
    [self setValue:[NSNumber numberWithInteger:c] forKey:@"Line-ID"];
}

-(void) setNumTouches: (int) c {
    
    [self setValue:[NSNumber numberWithInteger:c] forKey:@"Num-touches"];
}

-(void) setWordID: (int) c {
    
    [self setValue:[NSNumber numberWithInteger:c] forKey:@"Word-ID"];
}

-(void) setSkipNum: (int) c {
    
    [self setValue:[NSNumber numberWithInteger:c] forKey:@"Skip-num"];
}

-(void) setParaID: (int) c {
    
    [self setValue:[NSNumber numberWithInteger:c] forKey:@"Para-ID"];
}

-(void) setWordText:(NSString *)event {
    [self setValue:event forKey:@"Word-text"];
}

-(void) setMode:(NSString *)mode {
    [self setValue:mode forKey:@"Mode"];
}

-(void) setTrain:(int) c {
    [self setValue:[NSNumber numberWithInteger:c] forKey:@"Train"];
}


-(void) setTouchLog: (NSString*) touch {
    [self setValue: touch forKey:@"Touches"];
}


-(void) setExplorationType: (NSString*) touch {
    [self setValue: touch forKey:@"Exploration-type"];
}




@end
