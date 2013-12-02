#import "IntroAnimFrame6.h"
#import "Resource.h"
#import "FileCache.h"
#import "RepeatFillSprite.h"

@implementation IntroAnimFrame6

+(IntroAnimFrame6*)cons {
	return [IntroAnimFrame6 node];
}

static float GROUNDHEI;

-(id)init {
	self = [super init];
	
	bg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
								rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame6_bg"]];
	[bg setScaleX:[Common scale_from_default].x];
	[bg setScaleY:[Common scale_from_default].y];
	[bg setAnchorPoint:ccp(0,0)];
	[bg setPosition:[Common screen_pctwid:0 pcthei:0]];
	[self addChild:bg];
	
	
	GROUNDHEI = [FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame6_groundtex"].size.height-10;
	
	ground = [RepeatFillSprite cons_tex:[Resource get_tex:TEX_INTRO_ANIM_SS]
								   rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame6_groundtex"]
									rep:6];
	[ground setPosition:ccp(0,40)];
	[self addChild:ground];
	
	dog1 = [CCSprite node];
	[dog1 runAction:[self runAction:[Common cons_anim:@[@"run_0",@"run_1",@"run_2",@"run_3"]
												speed:0.1
											  tex_key:TEX_DOG_RUN_6]]];
	[dog1 setPosition:ccp(-100,GROUNDHEI+5)];
	[self addChild:dog1];
	
	dog2 = [CCSprite node];
	[dog2 runAction:[self runAction:[Common cons_anim:@[@"run_0",@"run_1",@"run_2",@"run_3"]
												speed:0.1
											  tex_key:TEX_DOG_RUN_5]]];
	[dog2 setPosition:ccp(-100,GROUNDHEI)];
	[self addChild:dog2];
	
	dog3 = [CCSprite node];
	[dog3 runAction:[self runAction:[Common cons_anim:@[@"run_0",@"run_1",@"run_2",@"run_3"]
												speed:0.1
											  tex_key:TEX_DOG_RUN_1]]];
	[dog3 setPosition:ccp(-100,GROUNDHEI)];
	[self addChild:dog3];
	
	[dog1 setScale:0.7];
	[dog2 setScale:0.7];
	[dog3 setScale:0.7];
	
	copter = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
									rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"frame4_cage"]];
	[copter setPosition:[Common screen_pctwid:0.6 pcthei:1.4]];
	[copter setScale:0.8];
	[self addChild:copter];
	
	dog1_tar_pos = dog1.position;
	dog2_tar_pos = dog2.position;
	dog3_tar_pos = dog3.position;
	copter_tar_pos = copter.position;
	
	ct = 0;
	return self;
}

static int END_AT = 350;


-(void)update {
	ct++;
	[ground setPosition:ccp(((int)ground.position.x-5)%254,ground.position.y)];
	
	if (ct == 20) {
		dog3_tar_pos = ccp(190,GROUNDHEI);
		
	} else if (ct == 40) {
		dog2_tar_pos = ccp(115,GROUNDHEI);
		
	} else if (ct == 60) {
		dog1_tar_pos = ccp(50,GROUNDHEI+5);
		
	} else if (ct == 80) {
		copter_tar_pos = [Common screen_pctwid:0.8 pcthei:0.75];
		
	} else if (ct == 200) {
		copter_tar_pos = [Common screen_pctwid:1.5 pcthei:1.5];
		
	} else if (ct == 220) {
		dog3_tar_pos = ccp([Common SCREEN].width*1.4,GROUNDHEI);
		
	} else if (ct == 240) {
		dog2_tar_pos = ccp([Common SCREEN].width*1.4,GROUNDHEI);
		
	} else if (ct == 260) {
		dog1_tar_pos = ccp([Common SCREEN].width*1.4,GROUNDHEI);
		
	}
	
	if (ct < 200) {
		[dog1 setPosition:ccp(dog1.position.x+(dog1_tar_pos.x-dog1.position.x)/25.0,dog1.position.y)];
		[dog2 setPosition:ccp(dog2.position.x+(dog2_tar_pos.x-dog2.position.x)/25.0,dog2.position.y)];
		[dog3 setPosition:ccp(dog3.position.x+(dog3_tar_pos.x-dog3.position.x)/25.0,dog3.position.y)];
		
	} else {
		[dog1 setPosition:ccp(dog1.position.x+(dog1_tar_pos.x-dog1.position.x)/65.0,dog1.position.y)];
		[dog2 setPosition:ccp(dog2.position.x+(dog2_tar_pos.x-dog2.position.x)/65.0,dog2.position.y)];
		[dog3 setPosition:ccp(dog3.position.x+(dog3_tar_pos.x-dog3.position.x)/65.0,dog3.position.y)];
	}
	
	[copter setPosition:ccp(copter.position.x+(copter_tar_pos.x-copter.position.x)/15.0,copter.position.y+(copter_tar_pos.y-copter.position.y)/15.0)];
}

-(BOOL)should_continue {
	return ct >= END_AT;
}

-(void)force_continue {
	ct = END_AT;
}

@end
