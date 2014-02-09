#import "GameObject.h"
@class GameEngineLayer;

@interface RobotBossFistProjectile : GameObject {
	CGPoint startpos, tarpos;
	float time_left;
	float time_total;
	float groundlevel;
	int mode;
}
#define RobotBossFistProjectileDirection_AT_PLAYER 0
#define RobotBossFistProjectileDirection_AT_BOSS 1
#define RobotBossFistProjectileDirection_AT_CAT 2
@property(readwrite,assign) int direction;

+(RobotBossFistProjectile*)cons_g:(GameEngineLayer*)g relpos:(CGPoint)relpos tarpos:(CGPoint)tarpos time:(float)time groundlevel:(float)groundlevel;

-(id)set_startpos:(CGPoint)_startpos tarpos:(CGPoint)_tarpos time_left:(float)_time_left time_total:(float)_time_total;

-(id)mode_parabola_a;
-(id)mode_line;
-(id)mode_parabola_at_cat;

-(float)time_left;

-(BOOL)should_remove;
-(void)do_remove:(GameEngineLayer*)g;
@end
