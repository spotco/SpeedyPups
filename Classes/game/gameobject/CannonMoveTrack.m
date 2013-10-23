#import "CannonMoveTrack.h"

@implementation CannonMoveTrack

+(CannonMoveTrack*)cons_pt1:(CGPoint)pt1 pt2:(CGPoint)pt2 {
	return NULL;
}

-(CGPoint)get_pt1 {
	return CGPointZero;
}

-(CGPoint)get_pt2 {
	return CGPointZero;
}

-(HitRect)get_hit_rect {
	return [Common hitrect_cons_x1:0 y1:0 wid:0 hei:0];
}

@end
