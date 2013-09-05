#import "ShopBuyBoneFlyoutParticle.h"
#import "Common.h"

@implementation ShopBuyBoneFlyoutParticle

+(ShopBuyBoneFlyoutParticle*)cons_pt:(CGPoint)pt vel:(CGPoint)vel {
	return [[ShopBuyBoneFlyoutParticle node] cons_pt:pt vel:vel];
}

-(void)set_body {
	[self setTexture:[Resource get_tex:TEX_GOLDEN_BONE]];
	CGSize tex_size = [Resource get_tex:TEX_GOLDEN_BONE].contentSize;
	[self setTextureRect:CGRectMake(0, 0, tex_size.width, tex_size.height)];
}

#define MAX_CT 23.0

-(id)cons_pt:(CGPoint)pt vel:(CGPoint)tvel {
	[self set_body];
	ct = MAX_CT;
	[self setPosition:pt];
	vel = tvel;
	[self setRotation:float_random(0, 360)];
	vr = float_random(8, 20) * [Common sig:float_random(-100, 100)];
	init_scale = float_random(0.3, 0.9);
	[self setScale:init_scale];
	
	return self;
}

-(void)update:(GameEngineLayer *)g {
	ct--;
	float pct = 1-ct/MAX_CT;
	[self setPosition:CGPointAdd(position_, vel)];
	[self setRotation:rotation_+vr];
	[self setScale:init_scale+pct*1.2];
	[self setOpacity:220-pct*220];
}

-(BOOL)should_remove {
	return ct <= 0;
}

@end
