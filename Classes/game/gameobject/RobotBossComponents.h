#import "CCSprite.h"

@interface RobotBossComponents : NSObject
+(void)cons_anims;
@end

@interface RobotBossBody : CCSprite {
	float passive_arm_rotation_theta;
}
+(RobotBossBody*)cons;
@property(readwrite,strong) CCSprite *body;
@property(readwrite,strong) CCSprite *frontarm;
@property(readwrite,strong) CCSprite *backarm;
-(void)update;
@end

@interface CatBossBody :CCSprite {
	CCSprite *vib_base;
	float vib_theta;
}
+(CatBossBody*)cons;
@property(readwrite,strong) CCSprite *base;
@property(readwrite,strong) CCSprite *cape;
@property(readwrite,strong) CCSprite *top;
-(void)update;
@end
