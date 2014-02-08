#import "RobotBoss.h"
#import "RobotBossComponents.h"
#import "GameEngineLayer.h"

@implementation RobotBoss

+(RobotBoss*)cons_with:(GameEngineLayer*)g {
	return [[RobotBoss node] cons:g];
}

-(id)cons:(GameEngineLayer*)g {
	[RobotBossComponents cons_anims];

	robot_body = [RobotBossBody cons];
	[self addChild:robot_body];
	
	cat_body = [CatBossBody cons];
	[self addChild:cat_body];
	
	self.active = YES;
	
	return self;
}

#define CAT_DEFAULT_POS ccp(900,500)
#define ROBOT_DEFAULT_POS ccp(725,0)
#define CENTER_POS ccp(player.position.x,groundlevel)

-(void)update:(Player *)player g:(GameEngineLayer *)g {
	[self set_bounds_and_ground:g];
	[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:54 y:54 z:400]];
	
	[robot_body setPosition:CGPointAdd(CENTER_POS, ROBOT_DEFAULT_POS)];
	[robot_body update];
	
	[cat_body setPosition:CGPointAdd(CENTER_POS, CAT_DEFAULT_POS)];
	[cat_body update];
	
}

-(void)check_should_render:(GameEngineLayer *)g { do_render = YES; }
-(int)get_render_ord{ return [GameRenderImplementation GET_RENDER_FG_ISLAND_ORD]; }

-(void)set_bounds_and_ground:(GameEngineLayer*)g {
    float yl_min = g.player.position.y;
	Island *lowest = NULL;
	for (Island *i in g.islands) {
		if (i.endX > g.player.position.x && i.startX < g.player.position.x) {
			if (lowest == NULL || lowest.startY > i.startY) {
				lowest = i;
			}
		}
	}
	if (lowest != NULL) {
		yl_min = lowest.startY;
	}
	[g frame_set_follow_clamp_y_min:yl_min-500 max:yl_min+300];
	groundlevel = yl_min;
}

@end
