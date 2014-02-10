#import "CCSprite.h"

@interface RobotBossComponents : NSObject
+(void)cons_anims;
@end

@interface RobotBossBody : CCSprite {
	float passive_arm_rotation_theta;
	float swing_theta;
	int mode;
	
	BOOL swing_has_thrown_bomb;
}
+(RobotBossBody*)cons;
@property(readwrite,strong) CCSprite *body;
@property(readwrite,strong) CCSprite *frontarm;
@property(readwrite,strong) CCSprite *backarm;
-(void)update;
-(void)do_swing;
-(BOOL)swing_launched;
-(BOOL)swing_in_progress;

-(void)set_swing_has_thrown_bomb;
-(BOOL)swing_has_thrown_bomb;

@end

@interface CatBossBody :CCSprite {
	CCSprite *vib_base;
	float vib_theta;
	
	CCAction *top_anim;
}
+(CatBossBody*)cons;
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
