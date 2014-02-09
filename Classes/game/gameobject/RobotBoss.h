#import "GameObject.h"

@class RobotBossBody;
@class CatBossBody;
@class RobotBossFistProjectile;

typedef enum RobotBossMode {
	RobotBossMode_TOREMOVE,
	RobotBossMode_CAT_IN,
	RobotBossMode_ROBOT_IN,
	RobotBossMode_WINDUP,
	RobotBossMode_WAIT_REVOLLEY,
	RobotBossMode_REVOLLEY
	
} RobotBossMode;

@interface RobotBoss : GameObject {
	GameEngineLayer __unsafe_unretained *g;
	
	RobotBossBody *robot_body;
	CatBossBody *cat_body;
	
	CGPoint cat_body_rel_pos;
	CGPoint robot_body_rel_pos;
	
	float groundlevel;
	
	RobotBossMode cur_mode;
	
	NSMutableArray *fist_projectiles;
}

+(RobotBoss*)cons_with:(GameEngineLayer*)g;

@end
