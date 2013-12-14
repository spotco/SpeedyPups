#import "IntroAnimFrame3.h"
#import "Resource.h"
#import "FileCache.h"

@interface CCSprite_WithVel : CCSprite
@property(readwrite,assign) float v_r;
@end

@implementation CCSprite_WithVel
@synthesize v_r;
@end

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
	[bg setAnchorPoint:ccp(0.5,0.5)];
	[bg setPosition:[Common screen_pctwid:0.5 pcthei:0.5]];
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
	
    debris = [NSMutableArray array];
    for (int i = 0; i < 16; i++) {
        CCSprite_WithVel *particle = [CCSprite_WithVel spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
													rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS
																				   idname:[NSString stringWithFormat:@"frame3_debris_%d",i%8]]];
        [particle setPosition:ccp([Common SCREEN].width/7*i+float_random(-50, 50),float_random([Common SCREEN].height, [Common SCREEN].height+500))];
		[particle setRotation:float_random(0, 360)];
		[debris addObject:particle];
		particle.v_r = float_random(10, 30);
		[self addChild:particle];
		
		particle = [CCSprite_WithVel spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
												  rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS
																				 idname:[NSString stringWithFormat:@"frame3_debris_%d",i%8]]];
        [particle setPosition:ccp([Common SCREEN].width/7*i+float_random(-50, 50),float_random([Common SCREEN].height+450, [Common SCREEN].height+750))];
		[particle setRotation:float_random(0, 360)];
		[debris addObject:particle];
		particle.v_r = float_random(10, 30);
		[self addChild:particle];
    }
	
	[self addChild:curtains];
	
	ct = 0;
	return self;
}

static int END_AT = 150;


-(void)update {
	ct++;
	if (ct > END_AT*0.5) {
		if (ct%4==0) {
			[self setPosition:ccp(float_random(-1, 1),float_random(-1, 1))];
		}
		for (CCSprite_WithVel *particle in debris) {
			[particle setPosition:CGPointAdd(ccp(0,-10), particle.position)];
			[particle setRotation:particle.rotation+particle.v_r];
		}
	}
}

-(BOOL)should_continue {
	return ct >= END_AT;
}

-(void)force_continue {
	ct = END_AT;
}

@end
