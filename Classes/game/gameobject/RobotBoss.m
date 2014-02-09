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
	
	cur_mode = RobotBossMode_CAT_IN_RIGHT1;
	
	cat_body_rel_pos = ccp(2000,800);
	robot_body_rel_pos = ccp(1500,0);
	
	fist_projectiles = [NSMutableArray array];
	
	self.active = YES;
	return self;
}

#define RPOS_CAT_TAUNT_POS ccp(400,300)
#define RPOS_CAT_DEFAULT_POS ccp(900,500)
#define RPOS_ROBOT_DEFAULT_POS ccp(725,0)
#define CENTER_POS ccp(player.position.x,groundlevel)
#define LERP_TO(pos1,pos2,div) ccp(pos1.x+(pos2.x-pos1.x)/div,pos1.y+(pos2.y-pos1.y)/div)

-(void)update:(Player *)player g:(GameEngineLayer *)_g {
	[self set_bounds_and_ground:g];
	
	[robot_body setPosition:CGPointAdd(CENTER_POS, robot_body_rel_pos)];
	[robot_body update];
	
	[cat_body setPosition:CGPointAdd(CENTER_POS, cat_body_rel_pos)];
	[cat_body update];
	
	
	NSMutableArray *to_remove = [NSMutableArray array];
	for (RobotBossFistProjectile *p in fist_projectiles) {
		if (p.direction == RobotBossFistProjectileDirection_AT_BOSS) {
			if (p.time_left < 20 && ![robot_body swing_in_progress]) [robot_body do_swing];
			if (p.time_left <= 10) [self volley_return:p];
			
		} else if (p.direction == RobotBossFistProjectileDirection_AT_CAT && p.time_left <= 5) {
			if (cur_mode == RobotBossMode_WHIFF_AT_CAT_RIGHT_1) {
				delay_ct = 40;
				cur_mode = RobotBossMode_CAT_HURT_OUT_1;
			}
		}
			
		
		if ([p should_remove] && (p.direction == RobotBossFistProjectileDirection_AT_PLAYER || p.direction == RobotBossFistProjectileDirection_AT_CAT)) {
			[p do_remove:g];
			[g remove_gameobject:p];
			[to_remove addObject:p];
			[AudioManager playsfx:SFX_ROCKBREAK];
			[AudioManager playsfx:SFX_FAIL];
			
		}
	}
	[fist_projectiles removeObjectsInArray:to_remove];
	
	if (cur_mode == RobotBossMode_TOREMOVE) {
		[g remove_gameobject:self];
		return;
	
	} else if (cur_mode == RobotBossMode_CAT_IN_RIGHT1) {
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:54 y:54 z:400]];
		[cat_body stand_anim];
		
		cat_body_rel_pos = LERP_TO(cat_body_rel_pos, RPOS_CAT_TAUNT_POS, 15.0);
		
		
		if (CGPointDist(cat_body_rel_pos, RPOS_CAT_TAUNT_POS) < 5) {
			cur_mode = RobotBossMode_CAT_TAUNT_RIGHT1;
			[cat_body laugh_anim];
			delay_ct = 80;
		}
		
	} else if (cur_mode == RobotBossMode_CAT_TAUNT_RIGHT1) {
		delay_ct-=[Common get_dt_Scale];
		if (delay_ct <= 0) {
			cur_mode = RobotBossMode_CAT_ROBOT_IN_RIGHT1;
			[cat_body stand_anim];
			[AudioManager playsfx:SFX_BOSS_ENTER];
		}
		
	} else if (cur_mode == RobotBossMode_CAT_ROBOT_IN_RIGHT1) {
		cat_body_rel_pos = LERP_TO(cat_body_rel_pos, RPOS_CAT_DEFAULT_POS, 15.0);
		robot_body_rel_pos = LERP_TO(robot_body_rel_pos, RPOS_ROBOT_DEFAULT_POS, 25.0);
		if (CGPointDist(robot_body_rel_pos, RPOS_ROBOT_DEFAULT_POS) < 5) {
			cur_mode = RobotBossMode_VOLLEY_RIGHT_1;
			delay_ct = 20;
			volley_ct = 2;
		}
		
	} else if (cur_mode == RobotBossMode_VOLLEY_RIGHT_1) {
		delay_ct -= [Common get_dt_Scale];
		if (fist_projectiles.count == 0 && delay_ct <= 0 && ![robot_body swing_in_progress]) {
			[robot_body do_swing];
			
		} else if (fist_projectiles.count == 0 && [robot_body swing_in_progress] && [robot_body swing_launched]) {
			RobotBossFistProjectile *neu = [[RobotBossFistProjectile cons_g:g
																	 relpos:CGPointAdd(robot_body_rel_pos, ccp(-140,350))
																	 tarpos:CGPointZero
																	   time:100 groundlevel:groundlevel] mode_parabola_a];
			neu.direction = RobotBossFistProjectileDirection_AT_PLAYER;
			[g add_gameobject:neu];
			[fist_projectiles addObject:neu];
			[AudioManager playsfx:SFX_BOSS_ENTER];
			
		}
		
	} else if (cur_mode == RobotBossMode_CAT_HURT_OUT_1) {
		[cat_body damage_anim];
		delay_ct -= [Common get_dt_Scale];
		[cat_body brownian];
		
		if (delay_ct <= 0) {
			CGPoint flyout_pos = ccp(RPOS_CAT_DEFAULT_POS.x+600,RPOS_CAT_DEFAULT_POS.y+50);
			cat_body_rel_pos = LERP_TO(cat_body_rel_pos, flyout_pos, 25.0);
			if (CGPointDist(cat_body_rel_pos, flyout_pos) < 100) {
				robot_body_rel_pos = LERP_TO(robot_body_rel_pos, ccp(RPOS_ROBOT_DEFAULT_POS.x+1200,0), 30.0);
				if (CGPointDist(robot_body_rel_pos, ccp(RPOS_ROBOT_DEFAULT_POS.x+1200,0)) < 40) {
					cur_mode = RobotBossMode_CAT_IN_LEFT1;
				}
			}
		}
		
	}
}

-(void)volley_return:(RobotBossFistProjectile*)p {
	if (cur_mode == RobotBossMode_VOLLEY_RIGHT_1) {
		volley_ct--;
		if (volley_ct == 1) {
			p.direction = RobotBossFistProjectileDirection_AT_PLAYER;
			[p mode_parabola_a];
			[p set_startpos:ccp(p.position.x-g.player.position.x,p.position.y-groundlevel)
									   tarpos:ccp(0,0)
									time_left:60
								   time_total:60];
			[AudioManager playsfx:SFX_ROCKBREAK];
			[AudioManager playsfx:SFX_BOSS_ENTER];
			
		} else {
			p.direction = RobotBossFistProjectileDirection_AT_CAT;
			[p mode_parabola_at_cat];
			[p set_startpos:ccp(p.position.x-g.player.position.x,p.position.y-groundlevel)
					 tarpos:RPOS_CAT_DEFAULT_POS
				  time_left:100
				 time_total:100];
			[AudioManager playsfx:SFX_ROCKBREAK];
			[AudioManager playsfx:SFX_BOSS_ENTER];
			cur_mode = RobotBossMode_WHIFF_AT_CAT_RIGHT_1;
			
		}
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
