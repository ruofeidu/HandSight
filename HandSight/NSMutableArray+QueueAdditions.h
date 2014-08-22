/*
 Generic queue.
 */

@interface NSMutableArray (QueueAdditions)

-(id) dequeue;
-(void) enqueue:(id)obj;
-(id) peek:(int)index;
-(id) peekHead;
-(id) peekTail;
-(id) popTail; 
-(BOOL) empty;

// HandSight only
-(void) markHeadSpoken;
@end