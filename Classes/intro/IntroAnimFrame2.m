#import "IntroAnimFrame2.h"
#import "Resource.h"
#import "FileCache.h"
#import "RepeatFillSprite.h"
#import "BackgroundObject.h"
#import "Common.h"

@implementation IntroAnimFrame2

+(IntroAnimFrame2*)cons {
	return [IntroAnimFrame2 node];
}

static int GROUND_TEX_WID;

-(id)init {
	self = [super init];
	
    BackgroundObject *sky = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_SKY] scrollspd_x:0 scrollspd_y:0];
	[sky setScaleX:[Common scale_from_default].x];
	[sky setScaleY:[Common scale_from_default].y];
	BackgroundObject *starsbg = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_STARS] scrollspd_x:0 scrollspd_y:0];
    BackgroundObject *moon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_MOON]];
	//BackgroundObject *backhills = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_LAYER_3] scrollspd_x:0.025 scrollspd_y:0.005];
	//BackgroundObject *fronthills = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_LAYER_1] scrollspd_x:0.1 scrollspd_y:0.03];
    
    [moon setPosition:[Common screen_pctwid:0.75 pcthei:0.8]];
    
    float pctm = 0;
    [sky setColor:ccc3(pb(20,pctm),pb(20,pctm),pb(60,pctm))];
    //[backhills setColor:ccc3(pb(50,pctm),pb(50,pctm),pb(90,pctm))];
    //[fronthills setColor:ccc3(pb(140,pctm),pb(140,pctm),pb(180,pctm))];
    
    [self addChild:sky];
    [self addChild:starsbg];
    [self addChild:moon];
    //[self addChild:backhills];
    //[self addChild:fronthills];
	
	GROUND_TEX_WID = [FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame2_ground"].size.width;
	ground = [RepeatFillSprite cons_tex:[Resource get_tex:TEX_INTRO_ANIM_SS]
								   rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame2_ground"]
									rep:6];
	[ground setPosition:[Common screen_pctwid:0 pcthei:-0.24]];
	[self addChild:ground];
	
	robot1 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
									rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame2_robolauncher"]];
	[robot1 setPosition:[Common screen_pctwid:1.42 pcthei:0.5]];
	[self addChild:robot1];
	
	robot2 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
									rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame2_copter"]];
	[robot2 setPosition:[Common screen_pctwid:1.7 pcthei:0.56]];
	[self addChild:robot2];
	
	robot3 = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
									rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame2_robominion"]];
	[robot3 setPosition:[Common screen_pctwid:1.9 pcthei:0.48]];
	[self addChild:robot3];

	
	ct = 0;
	return self;
}

static int END_AT = 125;


-(void)update {
	ct+=[Common get_dt_Scale];
	[robot1 setPosition:ccp(robot1.position.x-12*[Common get_dt_Scale],robot1.position.y)];
	[robot2 setPosition:ccp(robot2.position.x-12.2*[Common get_dt_Scale],robot2.position.y)];
	[robot3 setPosition:ccp(robot3.position.x-12.1*[Common get_dt_Scale],robot3.position.y)];
}

-(BOOL)should_continue {
	return ct >= END_AT;
}

-(void)force_continue {
	ct = END_AT;
}

@end
