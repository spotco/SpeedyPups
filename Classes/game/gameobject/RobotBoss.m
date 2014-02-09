#import "RobotBoss.h"
#import "RobotBossComponents.h"
#import "GameEngineLayer.h"
#import "RobotBossFistProjectile.h"

@implementation RobotBoss

+(RobotBoss*)cons_with:(GameEngineLayer*)g {
	return [[RobotBoss node] cons:g];
}

-(id)cons:(GameEngineLayer*)_g {
	[RobotBossComponents cons_anims];

	g = _g;
	
	robot_body = [RobotBossBody cons];
	[self addChild:robot_body];
	
	cat_body = [CatBossBody cons];
	[self addChild:cat_body];
	
	[self set_bounds_and_ground:g];
	
	cur_mode = RobotBossMode_CAT_IN;
	
	cat_body_rel_pos = ccp(2000,800);
	robot_body_rel_pos = ccp(1500,0);
	
	fist_projectiles = [NSMutableArray array];
	
	
	self.active = YES;
	return self;
}

#define CAT_DEFAULT_POS ccp(900,500)
#define ROBOT_DEFAULT_POS ccp(725,0)
#define CENTER_POS ccp(player.position.x,groundlevel)

-(void)update:(Player *)player g:(GameEngineLayer *)_g {
	[self set_bounds_and_ground:g];
	[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:54 y:54 z:400]];
	
	[robot_body setPosition:CGPointAdd(CENTER_POS, robot_body_rel_pos)];
	[robot_body update];
	
	[cat_body setPosition:CGPointAdd(CENTER_POS, cat_body_rel_pos)];
	[cat_body update];
	
	NSMutableArray *to_remove = [NSMutableArray array];
	for (RobotBossFistProjectile *p in fist_projectiles) {
		
		if (p.direction == RobotBossFistProjectileDirection_AT_BOSS && p.time_left < 30) {
			[robot_body do_volley];
			
			if (p.time_left <= 10) {
				
				float time = float_random(35, 110);
				
				p.direction = RobotBossFistProjectileDirection_AT_PLAYER;
				[[p mode_parabola_a] set_startpos:ccp(p.position.x-player.position.x,p.position.y-groundlevel)
										   tarpos:ccp(0,0)
										time_left:time
									   time_total:time];
				[AudioManager playsfx:SFX_ROCKBREAK];
			}
			
		} else if ([p should_remove]) {
			[p do_remove:g];
			[g remove_gameobject:p];
			[to_remove addObject:p];
		
		}
	}
	[fist_projectiles removeObjectsInArray:to_remove];
	
	if (cur_mode == RobotBossMode_TOREMOVE) {
		[g remove_gameobject:self];
		return;
		
	} else if (cur_mode == RobotBossMode_CAT_IN) {
		[cat_body stand_anim];
		cat_body_rel_pos.x += (CAT_DEFAULT_POS.x - cat_body_rel_pos.x)/15.0;
		cat_body_rel_pos.y += (CAT_DEFAULT_POS.y - cat_body_rel_pos.y)/15.0;
		if (CGPointDist(cat_body_rel_pos, CAT_DEFAULT_POS) < 5) {
			cur_mode = RobotBossMode_ROBOT_IN;
		}
		
		
	} else if (cur_mode == RobotBossMode_ROBOT_IN) {
		[cat_body laugh_anim];
		cat_body_rel_pos.x += (CAT_DEFAULT_POS.x - cat_body_rel_pos.x)/2.0;
		cat_body_rel_pos.y += (CAT_DEFAULT_POS.y - cat_body_rel_pos.y)/2.0;
		robot_body_rel_pos.x += (ROBOT_DEFAULT_POS.x - robot_body_rel_pos.x)/20.0;
		robot_body_rel_pos.y += (ROBOT_DEFAULT_POS.y - robot_body_rel_pos.y)/20.0;
		if (CGPointDist(robot_body_rel_pos, ROBOT_DEFAULT_POS) < 5) {
			robot_body_rel_pos = ROBOT_DEFAULT_POS;
			cur_mode = RobotBossMode_WINDUP;
			[robot_body do_windup];
		}
		
	} else if (cur_mode == RobotBossMode_WINDUP) {
		[cat_body stand_anim];
		if ([robot_body windup_finished]) {
			cur_mode = RobotBossMode_WAIT_REVOLLEY;
			RobotBossFistProjectile *neu = [[RobotBossFistProjectile cons_g:g
																	relpos:CGPointAdd(robot_body_rel_pos, ccp(-140,350))
																	tarpos:CGPointZero
																	  time:40 groundlevel:groundlevel] mode_parabola_a];
			neu.direction = RobotBossFistProjectileDirection_AT_PLAYER;
			[g add_gameobject:neu];
			[fist_projectiles addObject:neu];
		}
		
	} else if (cur_mode == RobotBossMode_WAIT_REVOLLEY) {
	
		
	}
	
}

-(void)reset {
	[super reset];
	for (RobotBossFistProjectile *p in fist_projectiles) {
		[g remove_gameobject:p];
	}
	[fist_projectiles removeAllObjects];
	cur_mode = RobotBossMode_TOREMOVE;
}

-(void)check_should_render:(GameEngineLayer *)g { do_render = YES; }
-(int)get_render_ord{ return [GameRenderImplementation GET_RENDER_FG_ISLAND_ORD]; }

-(void)set_bounds_and_ground:(GameEngineLayer*)_g {
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
