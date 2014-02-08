#import "GameObject.h"

@class RobotBossBody;
@class CatBossBody;

@interface RobotBoss : GameObject {
	RobotBossBody *robot_body;
	CatBossBody *cat_body;
	
	float groundlevel;
}

+(RobotBoss*)cons_with:(GameEngineLayer*)g;

@end
