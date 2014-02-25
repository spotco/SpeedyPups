#import "CCSprite.h"

@interface NRobotBossComponents : NSObject
+(void)cons_anims;
@end

@interface NRobotBossBody : CCSprite {
	float passive_arm_rotation_theta;
	float passive_arm_rotation_theta_speed;
	float swing_theta;
	BOOL firing;
	
	CCAction *current_front_arm_anim;
	
	CCSprite *frontarm_anchor, *body_anchor;
	CCSprite *hopanchor;
	float hop_vy;
}
+(NRobotBossBody*)cons;
@property(readwrite,strong) CCSprite *body;
@property(readwrite,strong) CCSprite *frontarm;
@property(readwrite,strong) CCSprite *backarm;
-(void)update;

-(void)set_passive_rotation_theta_speed:(float)t;
-(void)do_fire;
-(void)arm_fire;
-(void)stop_fire;

-(void)hop;

@end

@interface NCatBossBody :CCSprite {
	CCSprite *vib_base;
	float vib_theta;
	
	CCAction *top_anim;
}
+(NCatBossBody*)cons;
@property(readwrite,strong) CCSprite *base;
@property(readwrite,strong) CCSprite *cape;
@property(readwrite,strong) CCSprite *top;
-(void)update;

-(void)laugh_anim;
-(void)stand_anim;
-(void)damage_anim;
-(void)hurt_anim;
-(void)brownian;
@end