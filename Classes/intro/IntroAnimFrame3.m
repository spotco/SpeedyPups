#import "IntroAnimFrame3.h"
#import "Resource.h"
#import "FileCache.h"

@implementation IntroAnimFrame3

+(IntroAnimFrame3*)cons {
	return [IntroAnimFrame3 node];
}

-(id)init {
	self = [super init];
	
	bg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
								rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame3_bg"]];
	[bg setScaleX:[Common scale_from_default].x];
	[bg setScaleY:[Common scale_from_default].y];
	[bg setAnchorPoint:ccp(0,0)];
	[bg setPosition:[Common screen_pctwid:0 pcthei:0]];
	[self addChild:bg];
	
	dleft = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
								   rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame3_dog3"]];
	[dleft setPosition:[Common screen_pctwid:0.2 pcthei:0.21]];
	[self addChild:dleft];
	
	dright = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
									rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame3_dog2"]];
	[dright setPosition:[Common screen_pctwid:0.8 pcthei:0.29]];
	[self addChild:dright];
	
	pups = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
								  rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame3_pups"]];
	[pups setPosition:[Common screen_pctwid:0.5 pcthei:0.25]];
	[self addChild:pups];
	
	curtains = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
									  rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame3_curtain"]];
	[curtains setAnchorPoint:ccp(0.5,1)];
	[curtains setScaleX:[Common scale_from_default].x];
	[curtains setPosition:[Common screen_pctwid:0.5 pcthei:1]];
	[self addChild:curtains];
	
	ct = 0;
	return self;
}

static int END_AT = 150;


-(void)update {
	ct++;
}

-(BOOL)should_continue {
	return ct >= END_AT;
}

-(void)force_continue {
	ct = END_AT;
}

@end
