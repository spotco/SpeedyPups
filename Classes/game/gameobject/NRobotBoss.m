#import "NRobotBoss.h"
#import "NRobotBossComponents.h"
#import "GameEngineLayer.h"
#import "JumpParticle.h"
#import "LauncherRocket.h"
#import "CannonFireParticle.h"

@implementation NRobotBoss

+(NRobotBoss*)cons_with:(GameEngineLayer*)g {
	return [[NRobotBoss node] cons:g];
}

#define RPOS_CAT_TAUNT_POS ccp(400,300)
#define RPOS_CAT_DEFAULT_POS ccp(1500,500)
#define RPOS_ROBOT_DEFAULT_POS ccp(725,0)

#define LPOS_ROBOT_DEFAULT_POS ccp(-650,0)

#define CAPE_WAIT_POS ccp(500,150)

#define CENTER_POS ccp(player.position.x,groundlevel)
#define LERP_TO(pos1,pos2,div) ccp(pos1.x+(pos2.x-pos1.x)/div,pos1.y+(pos2.y-pos1.y)/div)

-(id)cons:(GameEngineLayer*)_g {
	[NRobotBossComponents cons_anims];
	
	g = _g;
	
	robot_body = [NRobotBossBody cons];
	[self addChild:robot_body];
	
	cat_body = [NCatBossBody cons];
	[self addChild:cat_body];
	
	[self set_bounds_and_ground:g];
	
	cat_body_rel_pos = ccp(2000,800);
	robot_body_rel_pos = ccp(1500,0);
	
	cur_mode = NRobotBossMode_CAT_IN_RIGHT1;
	
	self.active = YES;
	return self;
}

-(void)update:(Player *)player g:(GameEngineLayer *)_g {
	[self set_bounds_and_ground:g];
	
	[robot_body setPosition:CGPointAdd(CENTER_POS, robot_body_rel_pos)];
	[robot_body update];
	
	[cat_body setPosition:CGPointAdd(CENTER_POS, cat_body_rel_pos)];
	[cat_body update];
	
	if (cur_mode == NRobotBossMode_TOREMOVE) {
		[g remove_gameobject:self];
		return;
		
	} else if (cur_mode == NRobotBossMode_CAT_IN_RIGHT1) {
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:54 y:54 z:400]];
		[cat_body setScaleX:-1];
		[robot_body setScaleX:-1];
		[self update_cat_body_flyin_to:RPOS_CAT_TAUNT_POS transition_to:NRobotBossMode_CAT_TAUNT_RIGHT1];
		
	} else if (cur_mode == NRobotBossMode_CAT_TAUNT_RIGHT1) {
		[self update_taunt_transition_to:NRobotBossMode_CAT_ROBOT_IN_RIGHT1];
		
	} else if (cur_mode == NRobotBossMode_CAT_ROBOT_IN_RIGHT1) {
		[self update_robot_body_in_robotpos:ccp(1500,0) catpos:RPOS_CAT_DEFAULT_POS transition_to:NRobotBossMode_CHOOSING];
		if (cur_mode != NRobotBossMode_CAT_ROBOT_IN_RIGHT1) {
			[self attack_wallrockets_right];
			[AudioManager playsfx:SFX_BOSS_ENTER];
		}

	} else if (cur_mode == NRobotBossMode_ATTACK_WALLROCKETS_IN) {
		[robot_body setScaleX:-1];
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:54 y:54 z:400]];
		[self update_robot_body_in_robotpos:RPOS_ROBOT_DEFAULT_POS catpos:RPOS_CAT_DEFAULT_POS transition_to:NRobotBossMode_CHOOSING];
		if (cur_mode != NRobotBossMode_ATTACK_WALLROCKETS_IN) {
			cur_mode = NRobotBossMode_ATTACK_WALLROCKETS;
			delay_ct = 100;
		}
		
	} else if (cur_mode == NRobotBossMode_ATTACK_WALLROCKETS) {
		[robot_body setScaleX:-1];
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:54 y:54 z:400]];
		if (delay_ct < 75) {
			[robot_body do_fire];
		}
		delay_ct-=[Common get_dt_Scale];
		if (delay_ct <= 0) {
			float mvx = -7, mvy = float_random(-5, 5);
			if (tmp_ct > 0) {
				delay_ct = 20;
				tmp_ct--;
				
			} else {
				delay_ct = 80;
				tmp_ct = 8;
				pattern_ct--;
				if (pattern_ct <= 0) {
					delay_ct = 200;
					pattern_ct = 5;
					cur_mode = NRobotBossMode_ATTACK_CHARGE_LEFT;
					[AudioManager playsfx:SFX_BOSS_ENTER];
				}
			}
			[robot_body arm_fire];
			[AudioManager playsfx:SFX_ROCKET_LAUNCH];
			[g add_particle:[[CannonFireParticle cons_x:[self get_arm_fire_position].x+75 y:[self get_arm_fire_position].y+15] set_scale:1.4]];
			[g add_gameobject:(GameObject*)[[[RelativePositionLauncherRocket cons_at:[self get_arm_fire_position]
																player:player.position
																   vel:ccp(mvx,mvy)] set_remlimit:1000] set_scale:1.4]];
		}
		
	} else if (cur_mode == NRobotBossMode_ATTACK_CHARGE_LEFT) {
		delay_ct-=[Common get_dt_Scale];
		[robot_body stop_fire];
		[robot_body setScaleX:-1];
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:54 y:54 z:400]];
		if (delay_ct < 170) {
			[robot_body set_passive_rotation_theta_speed:0.2];
		}
		if (delay_ct <= 120 && pattern_ct >= 5) {
			[robot_body hop];
			pattern_ct--;
		} else if (delay_ct <= 55 && pattern_ct >= 4) {
			[robot_body hop];
			pattern_ct--;
		} else if (delay_ct <= 35 & pattern_ct >= 3) {
			[robot_body hop];
			pattern_ct--;
		} else if (delay_ct <= 15 && pattern_ct >= 2) {
			[robot_body hop];
			pattern_ct--;
		} else if (delay_ct <= 5 && pattern_ct >= 1) {
			pattern_ct--;
			[AudioManager playsfx:SFX_BOSS_ENTER];
			
		} else if (delay_ct <= 0) {
			robot_body_rel_pos.x -= 12.5*[Common get_dt_Scale];
			if (robot_body_rel_pos.x < -500) {
				[self attack_stream_homing_left];
				[robot_body set_passive_rotation_theta_speed:0.09];
				robot_body_rel_pos.x = -1500;
			}
		}
		
	} else if (cur_mode == NRobotBossMode_ATTACK_STREAMHOMING_IN) {
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:320 y:54 z:400]];
		[robot_body setScaleX:1];
		[self update_robot_body_in_robotpos:LPOS_ROBOT_DEFAULT_POS catpos:RPOS_CAT_DEFAULT_POS transition_to:NRobotBossMode_CHOOSING];
		if (cur_mode != NRobotBossMode_ATTACK_STREAMHOMING_IN) {
			cur_mode = NRobotBossMode_ATTACK_STREAMHOMING;
			delay_ct = 100;
		}
		
	} else if (cur_mode == NRobotBossMode_ATTACK_STREAMHOMING) {
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:320 y:54 z:400]];
		if (delay_ct < 75) {
			[robot_body do_fire];
		}
		[robot_body setScaleX:1];
		delay_ct-=[Common get_dt_Scale];
		if (delay_ct <= 0) {
			float mvx = 6, mvy = 0;
			if (tmp_ct == 2) {
				mvy = 3;
			} else if (tmp_ct == 1) {
				mvy = 0;
			} else {
				mvy = -3;
			}
			
		
			if (tmp_ct > 0) {
				delay_ct = 40;
				tmp_ct--;
				
			} else {
				delay_ct = 230;
				tmp_ct = 2;
				pattern_ct--;
				if (pattern_ct <= 0) {
					delay_ct = 200;
					pattern_ct = 5;
					cur_mode = NRobotBossMode_ATTACK_CHARGE_RIGHT;
				}
			}
			[robot_body arm_fire];
			[AudioManager playsfx:SFX_ROCKET_LAUNCH];
			[g add_particle:[[CannonFireParticle cons_x:[self get_arm_fire_position].x+75 y:[self get_arm_fire_position].y+15] set_scale:1.4]];
			[g add_gameobject:[(RelativePositionLauncherRocket*)[[[RelativePositionLauncherRocket cons_at:[self get_arm_fire_position2]
																			  player:player.position
																				 vel:ccp(mvx,mvy)] set_remlimit:300] set_scale:1.4] set_homing]];
		}
	} else if (cur_mode == NRobotBossMode_ATTACK_CHARGE_RIGHT) {
		delay_ct-=[Common get_dt_Scale];
		[robot_body stop_fire];
		[robot_body setScaleX:1];
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:320 y:54 z:400]];
		if (delay_ct < 170) {
			[robot_body set_passive_rotation_theta_speed:0.2];
		}
		if (delay_ct <= 120 && pattern_ct >= 5) {
			[robot_body hop];
			pattern_ct--;
		} else if (delay_ct <= 55 && pattern_ct >= 4) {
			[robot_body hop];
			pattern_ct--;
		} else if (delay_ct <= 35 & pattern_ct >= 3) {
			[robot_body hop];
			pattern_ct--;
		} else if (delay_ct <= 15 && pattern_ct >= 2) {
			[robot_body hop];
			pattern_ct--;
		} else if (delay_ct <= 5 && pattern_ct >= 1) {
			pattern_ct--;
			[AudioManager playsfx:SFX_BOSS_ENTER];
			
		} else if (delay_ct <= 0) {
			robot_body_rel_pos.x += 12.5*[Common get_dt_Scale];
			if (robot_body_rel_pos.x > 800) {
				[self attack_wallrockets_right];
				[robot_body set_passive_rotation_theta_speed:0.09];
				robot_body_rel_pos.x = 1500;
			}
		}
	}
}

-(CGPoint)get_arm_fire_position {
	return CGPointAdd(robot_body.position, ccp(-200,120));
}

-(CGPoint)get_arm_fire_position2 {
	return CGPointAdd(robot_body.position, ccp(200,120));
}

-(void)attack_stream_homing_left {
	cur_mode = NRobotBossMode_ATTACK_STREAMHOMING_IN;
	delay_ct = 0;
	tmp_ct = 2;
	pattern_ct = 3;
}

-(void)attack_wallrockets_right {
	cur_mode = NRobotBossMode_ATTACK_WALLROCKETS_IN;
	delay_ct = 0;
	tmp_ct = 8;
	pattern_ct = 3;
}

-(void)reset {
	[super reset];
	cur_mode = NRobotBossMode_TOREMOVE;
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

-(void)update_cat_body_flyin_to:(CGPoint)tar transition_to:(NRobotBossMode)mode {
	[cat_body stand_anim];
	cat_body_rel_pos = LERP_TO(cat_body_rel_pos, tar, 15.0);
	
	if (CGPointDist(cat_body_rel_pos, tar) < 10) {
		cur_mode = mode;
		[cat_body laugh_anim];
		delay_ct = 80;
	}
}

-(void)update_taunt_transition_to:(NRobotBossMode)mode {
	delay_ct-=[Common get_dt_Scale];
	if (delay_ct <= 0) {
		cur_mode = mode;
		[cat_body stand_anim];
	}
}

-(void)update_robot_body_in_robotpos:(CGPoint)robot_pos catpos:(CGPoint)cat_pos transition_to:(NRobotBossMode)mode {
	cat_body_rel_pos = LERP_TO(cat_body_rel_pos, cat_pos, 15.0);
	robot_body_rel_pos = LERP_TO(robot_body_rel_pos, robot_pos, 25.0);
	if (CGPointDist(cat_body_rel_pos, cat_pos) < 100 && CGPointDist(robot_body_rel_pos, robot_pos) < 15) {
		cur_mode = mode;
		delay_ct = 20;
	}
}

@end