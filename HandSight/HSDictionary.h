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
    
@end
