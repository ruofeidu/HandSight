//
//  HSMutableAttributedString.h
//  HandSight
//
//  Created by Ruofei Du on 8/1/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (HandSight)

-(id) getKey;
-(int) getLine;
-(int) getPara;
-(int) getLength;
-(int) getColumn;
-(int) getID;

-(void) setKey: (NSString*) key;
-(void) setLine: (int) num;
-(void) setPara: (int) para;
-(void) setColumn: (int) col;
-(void) setLength: (int) length;
-(void) setID: (int) ID;

-(BOOL) isFirstColumn;
-(BOOL) isSecondColumn;

-(void) setEvent: (NSString*) cmd;
-(void) setDate: (NSString*) date;
-(void) setTime: (float) timeStamp;
-(void) setX: (float) x;
-(void) setY: (float) y;
-(void) setLineWidth: (float) c;

-(void) setCatgory: (int) c;
-(void) setDocument: (int) c;
-(void) setFeedback: (int) c;
-(void) setLineID: (int) c;
-(void) setSkipNum: (int) c;
-(void) setParaID: (int) c;
-(void) setWordID: (int) c;
-(void) setVibrationCommand: (int) c;
-(void) setVibrationPower: (float) c;
-(void) setSpeed: (float) c;
-(void) setFrequency: (float) c;
-(void) setLineCenterY: (float) c;
-(void) setWordText: (NSString*) word;
-(void) setMode: (NSString*) mode;
-(void) setTouchLog: (NSString*) touch;
-(void) setExplorationType: (NSString*) touch;
-(void) setTrain:(int) c;
-(void) setNumTouches: (int) c;

@end
