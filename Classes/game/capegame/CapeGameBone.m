#import "CapeGameBone.h"
#import "Resource.h"
#import "Common.h"
#import "CapeGamePlayer.h"
#import "AudioManager.h"

@implementation CapeGameBone

+(CapeGameBone*)cons_pt:(CGPoint)pt {
	return [[CapeGameBone node] cons_pt:pt];
}

-(id)cons_pt:(CGPoint)pt {
	[self setTexture:[Resource get_tex:TEX_GOLDEN_BONE]];
	CGRect texr = CGRectZero;
	texr.size = self.texture.contentSize;
	[self setTextureRect:texr];
	[self setPosition:pt];
	active = YES;
	return self;
}

-(void)update:(CapeGameEngineLayer *)g {
	if (!active) return;
	
	if ([Common hitrect_touch:[[g player] get_hitrect] b:[self get_hitrect]]) {
		[self setVisible:NO];
		[g collect_bone];
		[AudioManager playsfx:SFX_BONE];
		active = NO;
	}
}

-(HitRect)get_hitrect {
	return [Common hitrect_cons_x1:position_.x-10 y1:position_.y-10 wid:20 hei:20];
}

@end
