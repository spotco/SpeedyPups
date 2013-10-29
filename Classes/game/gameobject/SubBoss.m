#import "SubBoss.h"
#import "GameEngineLayer.h"
#import "BGLayer.h"
#import "Lab2BGLayerSet.h"
#import "EnemyBomb.h"
#import "UICommon.h"
#import "LauncherRocket.h"

@interface FGWater : GameObject
+(FGWater*)cons;
@property (readwrite,assign) float offset;
@end

@implementation FGWater
@synthesize offset;
+(FGWater*)cons {
	return [[FGWater spriteWithTexture:[Resource get_tex:TEX_LAB2_WATER_FG]] cons_it];
}
-(id)cons_it {
	[self setAnchorPoint:ccp(0.5,1)];
	active = YES;
	return self;
}
-(void)update:(CGPoint)player_pos {
	player_pos.x *= 1.1;
	float xpos = ((int)(player_pos.x))%self.texture.pixelsWide + ((player_pos.x) - ((int)(player_pos.x)));
	[self setTextureRect:CGRectMake(
		xpos,
		0,
		[Common SCREEN].width*4,
		[self textureRect].size.height
	)];
}
-(void)check_should_render:(GameEngineLayer *)g {
	do_render = YES;
}
-(int)get_render_ord {
	return [GameRenderImplementation GET_RENDER_ABOVE_FG_ORD];
}
@end

@implementation SubBoss

static CCAction* _anim_body_normal = NULL;
static CCAction* _anim_body_angry;
static CCAction* _anim_body_bite;

static CCAction* _anim_hatch_closed_to_cannon;
static CCAction* _anim_hatch_cannon_to_closed;
static CCAction* _anim_hatch_closed;

+(SubBoss*)cons_with:(GameEngineLayer *)g {
	return [[SubBoss node] cons:g];
}

-(id)cons:(GameEngineLayer*)g {
	body = [CCSprite node];
	hatch = [CCSprite node];
	[self addChild:body];
	[hatch setAnchorPoint:ccp(0.5,0)];
	[body addChild:hatch];
	[SubBoss cons_anims];
	
	[hatch setPosition:ccp(215,195)];
	
	[self run_body_anim:_anim_body_normal];
	[hatch runAction:_anim_hatch_closed];
	
	active = YES;
	do_render = YES;
	
	bgobj = [[g get_bg_layer] get_subboss_bgobject];
	
	current_mode = SubMode_Intro;
	[bgobj setPosition:ccp(-100,bgobj.position.y)];
	ct = 0;
	
	[bgobj setScale:1];
	
	[bgobj setVisible:NO];
	[body setVisible:NO];
	
	fgwater = [FGWater cons];
	fgwater.offset = 1000;
	[g add_gameobject:fgwater];
	
	return self;
}

static CGPoint last_pos;
-(void)update:(Player *)player g:(GameEngineLayer *)g {
	[self set_bounds_and_ground:g];
	
	fgwater.offset += (150-fgwater.offset)/10.0;
	[fgwater setPosition:ccp(player.position.x,groundlevel-fgwater.offset)];
	[fgwater update:player.position];
	
	if (current_mode == SubMode_ToRemove) {
		[g remove_gameobject:self];
		[g remove_gameobject:fgwater];
		
	} else if (current_mode == SubMode_Intro) {
		[bgobj setVisible:YES];
		[body setVisible:NO];
		[bgobj setScaleX:1];
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:120 y:110 z:240]];
		[bgobj setPosition:ccp(bgobj.position.x+2*[Common get_dt_Scale],bgobj.position.y)];
		if (bgobj.position.x > [Common SCREEN].width+150) {
			[self pick_next_move];
			
		}
		//todo -- make wake effect here
		
	} else if (current_mode == SubMode_BGFireBombs) {
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:120 y:110 z:240]];
		[bgobj setVisible:YES];
		[body setVisible:NO];
		[bgobj setScaleX:-1];
		if (bgobj.position.x > [Common SCREEN].width*0.75) {
			[bgobj setPosition:ccp(bgobj.position.x-2*[Common get_dt_Scale],bgobj.position.y)];
			if (bgobj.position.x <= [Common SCREEN].width*0.75) {
				[bgobj anim_hatch_closed_to_cannon];
			}
		} else {
			ct++;
			if (ct%20==0) {
				[g add_gameobject:[[RelativePositionEnemyBomb
								   cons_pt:[UICommon touch_to_game_coords:[bgobj get_nozzle] g:g]
								   v:ccp(float_random(-16,-4),float_random(5,9))
								   player:player.position] do_bg_to_front_anim]];
				[bgobj set_recoil_delta:ccp(10,-10)];
				[bgobj explosion_at:[bgobj get_nozzle]];
			}
			//todo -- make 1,1,3,1,1,3
			if (ct > 250) { //todo -- make move out phase
				[self pick_next_move];
			}
			
		}
		
	} else if (current_mode == SubMode_BGFireMissiles) {
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:120 y:110 z:240]];
		[bgobj setVisible:YES];
		[body setVisible:NO];
		[bgobj setScaleX:-1];
		
		if (bgobj.position.x > -150) {
			if (ct == 40) {
				[bgobj anim_hatch_closed_to_open];
			} else if (ct > 40) {
				if (ct % 9 == 0) {
					[bgobj launch_rocket];
				}
				if (ct > 80) {
					if (ct % 14 == 0) {
						[g add_gameobject:[LauncherRocket cons_at:ccp(player.position.x+float_random(900, 1000),groundlevel+600) vel:ccp(0,float_random(-5, -3))]];
					}
				}
			}
			ct++;
		
			[bgobj setPosition:CGPointAdd(bgobj.position, ccp(-2*[Common get_dt_Scale],0))];
		} else {
			[self pick_next_move];
		}
		
	} else if (current_mode == SubMode_FrontJumpAttack) {
		[g set_target_camera:[Common cons_normalcoord_camera_zoom_x:120 y:110 z:240]];
		[bgobj setVisible:NO];
		[body setVisible:YES];
		[body setScaleX:-1];
		
		float target_rotation = 0;
		
		if (body_rel_pos.x > 500) {
			body_rel_pos.x -= 3 * [Common get_dt_Scale];
			target_rotation = 0;
			[self run_body_anim:_anim_body_normal];
			if (body_rel_pos.x <= 500) {
				body_rel_pos.x = 500;
				ct = 50;
				sub_submode = 0;
			}
			
		} else if (sub_submode == 0) {
			target_rotation = 15;
			ct--;
			if (ct <= 0) {
				sub_submode = 1;
				ct = 0;
				//todo -- splash anim here
			}
			
		} else if (sub_submode == 1) {
			body_rel_pos.x -= 3.5 * [Common get_dt_Scale];
			body_rel_pos.y = (-25.0/5000.0) * (body_rel_pos.x - 500) * (body_rel_pos.x);
			target_rotation = [VecLib get_rotation:[VecLib cons_x:body_rel_pos.x-last_pos.x y:body_rel_pos.y-last_pos.y z:0] offset:0];
			
			ct++;
			if (ct >= 35) {
				[self run_body_anim:_anim_body_bite];
			}
			if (body_rel_pos.x < -20) {
				//todo -- splash anim here
				[self pick_next_move];
			}
			//todo -- make hit effect and roll into effect
		}
		
		[body setRotation:body.rotation + (target_rotation - body.rotation)/5];
		[body setPosition:ccp(player.position.x+body_rel_pos.x,groundlevel+body_rel_pos.y)];
		
	}
	
	last_pos = body_rel_pos;
}

static int pick_ct;
-(void)pick_next_move {
	pick_ct++;
	if (pick_ct%3 == 0) {
		current_mode = SubMode_BGFireBombs;
		[bgobj setPosition:ccp([Common SCREEN].width+150,bgobj.position.y)];
		ct = 0;
		[bgobj anim_hatch_closed];
		
	} else if (pick_ct%3 == 1) {
		current_mode = SubMode_BGFireMissiles;
		[bgobj setPosition:ccp([Common SCREEN].width+150,bgobj.position.y)];
		ct = 0;
		[bgobj anim_hatch_closed];
		
	} else if (pick_ct%3 == 2) {
		current_mode = SubMode_FrontJumpAttack;
		body_rel_pos = ccp(1000,0);
		sub_submode = 0;
		ct = 0;
		[self run_body_anim:_anim_body_normal];
		
	}
}

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

-(HitRect)get_hit_rect {
	return [Common hitrect_cons_x1:body.position.x-100 y1:body.position.y-50 wid:200 hei:120];
}

-(void)check_should_render:(GameEngineLayer *)g {
	do_render = YES;
}

-(void)reset {
	current_mode = SubMode_ToRemove;
	_current_anim = NULL;
}

+(void)cons_anims {
	if (_anim_body_normal != NULL) return;
	_anim_body_normal = [Common cons_anim:@[@"body_normal"] speed:20 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_body_angry = [Common cons_anim:@[@"body_normal",@"body_normal_red"] speed:0.1 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_body_bite = [Common cons_nonrepeating_anim:@[@"body_bite0",
										  @"body_bite1",
										  @"body_bite2"]
								  speed:0.1
								tex_key:TEX_ENEMY_SUBBOSS];
	
	_anim_hatch_closed = [Common cons_anim:@[@"hatch_0"] speed:20 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_hatch_closed_to_cannon = [Common cons_anim:@[@"hatch_0",
													   @"hatch_1",
													   @"hatch_cannon_0",
													   @"hatch_cannon_1",
													   @"hatch_cannon_2"]
											   speed:0.1
											 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_hatch_closed_to_cannon = [Common cons_anim:@[@"hatch_cannon_2",
													   @"hatch_cannon_1",
													   @"hatch_cannon_0",
													   @"hatch_1",
													   @"hatch_0"]
											   speed:0.1
											 tex_key:TEX_ENEMY_SUBBOSS];
	
}

-(void)run_body_anim:(CCAction*)anim {
	if (_current_anim == NULL) {
		_current_anim = anim;
		[body runAction:anim];
	} else if (anim != _current_anim) {
		[body stopAllActions];
		_current_anim = anim;
		[body runAction:anim];
	}
}

@end
