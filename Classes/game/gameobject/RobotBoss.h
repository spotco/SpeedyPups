#import "GameObject.h"

@class RobotBossBody;
@class CatBossBody;
@class RobotBossFistProjectile;

typedef enum RobotBossMode {
	RobotBossMode_TOREMOVE,
	RobotBossMode_CAT_IN_RIGHT1,
	RobotBossMode_CAT_TAUNT_RIGHT1,
	RobotBossMode_CAT_ROBOT_IN_RIGHT1,
	RobotBossMode_VOLLEY_RIGHT_1,
	RobotBossMode_WHIFF_AT_CAT_RIGHT_1,
	RobotBossMode_CAT_HURT_OUT_1,
	
	RobotBossMode_CAT_IN_LEFT1,
	RobotBossMode_CAT_TAUNT_LEFT1,
	RobotBossMode_CAT_ROBOT_IN_LEFT1,
	RobotBossMode_VOLLEY_LEFT_1,
	RobotBossMode_WHIFF_AT_CAT_LEFT_1,
	RobotBossMode_CAT_HURT_OUT_LEFT_1,
	
	RobotBossMode_CAT_IN_RIGHT2,
	RobotBossMode_CAT_TAUNT_RIGHT2,
	RobotBossMode_CAT_ROBOT_IN_RIGHT2,
	RobotBossMode_VOLLEY_RIGHT_2,
	RobotBossMode_WHIFF_AT_CAT_RIGHT_2,
	RobotBossMode_CAT_HURT_OUT_RIGHT_2,
	
	RobotBossMode_CAT_HURT_WAIT,
	RobotBossMode_CAT_OUT_TO_CAPEGAME
} RobotBossMode;

@interface RobotBoss : GameObject {
	GameEngineLayer __unsafe_unretained *g;
	
	RobotBossBody *robot_body;
	CatBossBody *cat_body;
	CCSprite *cape_item_body;
	
	CGPoint cat_body_rel_pos;
	CGPoint robot_body_rel_pos;
	CGPoint cape_item_rel_pos;
	
	NSMutableArray *fist_projectiles;
	
	float delay_ct;
	float groundlevel;
	
	RobotBossMode cur_mode;
	
	int volley_ct;
	
	
}

+(RobotBoss*)cons_with:(GameEngineLayer*)g;

@end
