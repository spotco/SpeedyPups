#import "CCSprite.h"

@interface RobotBossComponents : NSObject
+(void)cons_anims;
@end

@interface RobotBossBody : CCSprite {
	float passive_arm_rotation_theta;
	int mode;
	
	float tar_front_rotation;
	float front_vr;
	
	float front_arm_empty_ct;
}
+(RobotBossBody*)cons;
@property(readwrite,strong) CCSprite *body;
@property(readwrite,strong) CCSprite *frontarm;
@property(readwrite,strong) CCSprite *backarm;
-(void)update;
-(void)do_windup;
-(BOOL)windup_finished;
-(void)do_volley;
@end

@interface CatBossBody :CCSprite {
	CCSprite *vib_base;
	float vib_theta;
	
	CCAction *base_anim, *cape_anim, *top_anim;
}
+(CatBossBody*)cons;
@property(readwrite,strong) CCSprite *base;
@property(readwrite,strong) CCSprite *cape;
@property(readwrite,strong) CCSprite *top;
-(void)update;

-(void)laugh_anim;
-(void)stand_anim;
@end
