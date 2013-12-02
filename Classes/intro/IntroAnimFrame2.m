#import "IntroAnimFrame2.h"
#import "Resource.h"
#import "FileCache.h"
#import "RepeatFillSprite.h"

@implementation IntroAnimFrame2

+(IntroAnimFrame2*)cons {
	return [IntroAnimFrame2 node];
}

static int GROUND_TEX_WID;

-(id)init {
	self = [super init];
	
	bg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
								rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame2_bg"]];
	[bg setScaleX:[Common scale_from_default].x];
	[bg setScaleY:[Common scale_from_default].y];
	[bg setAnchorPoint:ccp(0,0)];
	[bg setPosition:[Common screen_pctwid:0 pcthei:0]];
	[self addChild:bg];
	
	GROUND_TEX_WID = [FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame2_ground"].size.width;
	ground = [RepeatFillSprite cons_tex:[Resource get_tex:TEX_INTRO_ANIM_SS]
								   rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame2_ground"]
									rep:6];
	[ground setPosition:ccp(0,20)];
	[self addChild:ground];
	
	robot1 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
									rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame2_robolauncher"]];
	[robot1 setPosition:[Common screen_pctwid:1.42 pcthei:0.35]];
	[self addChild:robot1];
	
	robot2 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
									rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame2_copter"]];
	[robot2 setPosition:[Common screen_pctwid:1.7 pcthei:0.37]];
	[self addChild:robot2];
	
	robot3 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
									rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame2_robominion"]];
	[robot3 setPosition:[Common screen_pctwid:1.9 pcthei:0.33]];
	[self addChild:robot3];

	
	ct = 0;
	return self;
}

static int END_AT = 125;


-(void)update {
	ct++;
	[robot1 setPosition:ccp(robot1.position.x-17,robot1.position.y)];
	[robot2 setPosition:ccp(robot2.position.x-17.2,robot2.position.y)];
	[robot3 setPosition:ccp(robot3.position.x-17.1,robot3.position.y)];
}

-(BOOL)should_continue {
	return ct >= END_AT;
}

-(void)force_continue {
	ct = END_AT;
}

@end
