#import "GameObject.h"

@interface CannonRotationPoint : GameObject

+(CannonRotationPoint*)cons_pt1:(CGPoint)pt1 pt2:(CGPoint)pt2;
-(CGPoint)get_pt2;

@end
