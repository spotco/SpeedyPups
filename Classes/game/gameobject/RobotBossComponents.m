#import "RobotBossComponents.h"
#import "Common.h" 
#import "Resource.h"
#import "FileCache.h"

@implementation RobotBossComponents

static CCAction *_robot_body;
static CCAction *_robot_body_hurt;
static CCAction *_robot_arm_front_loaded;
static CCAction *_robot_arm_front_unloaded;
static CCAction *_robot_arm_back;

static CCAction *_cat_tail_base;
static CCAction *_cat_cape;
static CCAction *_cat_stand;
static CCAction *_cat_laugh;
static CCAction *_cat_hurt;
static CCAction *_cat_damage;

+(void)cons_anims {
	if (_robot_body != NULL) return;
	_robot_body = [Common cons_anim:@[@"body_0",@"body_1"] speed:0.1 tex_key:TEX_ENEMY_ROBOTBOSS];
	_robot_body_hurt = [Common cons_anim:@[@"body_hurt"] speed:10 tex_key:TEX_ENEMY_ROBOTBOSS];
	_robot_arm_front_loaded = [Common cons_anim:@[@"arm_front_fist"] speed:10 tex_key:TEX_ENEMY_ROBOTBOSS];
	_robot_arm_front_unloaded = [Common cons_anim:@[@"arm_front_empty"] speed:10 tex_key:TEX_ENEMY_ROBOTBOSS];
	_robot_arm_back = [Common cons_anim:@[@"back_arm"] speed:10 tex_key:TEX_ENEMY_ROBOTBOSS];
	
	_cat_tail_base = [Common cons_anim:@[@"cat_tail_0",@"cat_tail_1",@"cat_tail_2",@"cat_tail_3"] speed:0.1 tex_key:TEX_ENEMY_ROBOTBOSS];
	_cat_cape = [Common cons_anim:@[@"cat_cape_0",@"cat_cape_1",@"cat_cape_2",@"cat_cape_3"] speed:0.1 tex_key:TEX_ENEMY_ROBOTBOSS];
	_cat_stand = [Common cons_anim:@[@"cat_laugh_0"] speed:10 tex_key:TEX_ENEMY_ROBOTBOSS];
	_cat_laugh = [Common cons_anim:@[
									 @"cat_laugh_0",
									 @"cat_laugh_1",
									 @"cat_laugh_2",
									 @"cat_laugh_3",
									 @"cat_laugh_2",
									 @"cat_laugh_3",
									 @"cat_laugh_2",
									 @"cat_laugh_3",
									 @"cat_laugh_2",
									 @"cat_laugh_3",
									 @"cat_laugh_2",
									 @"cat_laugh_3",
									 @"cat_laugh_2",
									 @"cat_laugh_3",
									 @"cat_laugh_2",
									 @"cat_laugh_3",
									 @"cat_laugh_0"] speed:0.1 tex_key:TEX_ENEMY_ROBOTBOSS];
	_cat_hurt = [Common cons_anim:@[@"cat_hurt_0",@"cat_hurt_1",@"cat_hurt_2"] speed:0.1 tex_key:TEX_ENEMY_ROBOTBOSS];
	_cat_damage = _cat_stand = [Common cons_anim:@[@"cat_damage"] speed:10 tex_key:TEX_ENEMY_ROBOTBOSS];
}

@end

@implementation RobotBossBody

+(RobotBossBody*)cons {
	return [RobotBossBody node];
}

-(id)init {
	self = [super init];
	
	self.backarm = [CCSprite node];
	self.body = [CCSprite node];
	self.frontarm = [CCSprite node];
	
	[self addChild:self.backarm];
	[self addChild:self.body];
	[self addChild:self.frontarm];
	
	CGRect body_rect = [FileCache get_cgrect_from_plist:TEX_ENEMY_ROBOTBOSS idname:@"body_0"];
	
	[self.backarm setAnchorPoint:ccp(0.45,0.8)];
	[self.backarm setPosition:ccp(body_rect.size.width*0.15,body_rect.size.height*0.55)];
	
	[self.body setAnchorPoint:ccp(0.5,0.1)];
	
	[self.frontarm setAnchorPoint:ccp(0.35,0.8)];
	[self.frontarm setPosition:ccp(-body_rect.size.width*0.35,body_rect.size.height*0.55)];
	
	[self.backarm runAction:_robot_arm_back];
	[self.body runAction:_robot_body];
	[self.frontarm runAction:_robot_arm_front_loaded];
	
	passive_arm_rotation_theta = 0;
	
	[self setScaleX:-1];
	
	return self;
}

-(void)update {
	passive_arm_rotation_theta+=0.025*[Common get_dt_Scale];
	[self.backarm setRotation:cosf(passive_arm_rotation_theta)*15];
	[self.frontarm setRotation:-cosf(passive_arm_rotation_theta)*15];
}

@end

@implementation CatBossBody

+(CatBossBody*)cons {
	return [CatBossBody node];
}

-(id)init {
	self = [super init];
	
	vib_base = [CCSprite node];
	[self addChild:vib_base];
	
	self.base = [CCSprite node];
	self.cape = [CCSprite node];
	self.top = [CCSprite node];
	
	[vib_base addChild:self.base];
	[vib_base addChild:self.cape];
	[vib_base addChild:self.top];
	
	[self.base runAction:_cat_tail_base];
	[self.cape runAction:_cat_cape];
	[self.top runAction:_cat_laugh];
	
	[self setScaleX:-1];
	
	return self;
}

-(void)update {
	vib_theta+=0.075;
	[vib_base setPosition:ccp(0,10*cosf(vib_theta))];
}

@end
