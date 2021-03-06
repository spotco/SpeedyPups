#import "FreePupsAnim.h"
#import "Lab1BGLayerSet.h"
#import "Lab2BGLayerSet.h"
#import "Lab3BGLayerSet.h" 
#import "LabLineIsland.h"
#import "RepeatFillSprite.h"
#import "LabHandRail.h"
#import "AudioManager.h"
#import "FreeRunStartAtUnlockUIAnimation.h"
#import "MenuCommon.h"
#import "UICommon.h"
#import "ScoreManager.h"

#import "GameEngineLayer.h"
#import "UILayer.h"

@interface CCSprite_WithVel : CCSprite
@property(readwrite,assign) float vx,vy,vr;
@end
@implementation CCSprite_WithVel
@synthesize vx,vy,vr;
@end

@implementation FreePupsAnim

#define tFADEOUTLAYER 51

+(CCScene*)scene_with:(WorldNum)worldnum g:(GameEngineLayer *)g {
	CCScene *rtv = [CCScene node];
	[rtv addChild:[[FreePupsAnim node] cons_with:worldnum g:g]];
	
	CCLayerColor *fadeout_layer = [CCLayerColor layerWithColor:ccc4(0,0,0,0)];
	[fadeout_layer setOpacity:0];
	[rtv addChild:fadeout_layer z:0 tag:tFADEOUTLAYER];
	return rtv;
}

static float GROUNDLEVEL;

-(id)cons_with:(WorldNum)labnum g:(GameEngineLayer *)_g {
	g = _g;
	[self cons_anim];
	if (labnum == WorldNum_1) {
		BGLayerSet *set = [Lab1BGLayerSet cons];
		[set update:NULL curx:0 cury:0];
		[self addChild:set];
		if (![FreeRunStartAtManager get_can_start_at:FreeRunStartAt_WORLD2]) {
			[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD2];
			worldunlock_anim = [FreeRunStartAtUnlockUIAnimation cons_for_unlocking:FreeRunStartAt_WORLD2];
		}
	
	} else if (labnum == WorldNum_2) {
		BGLayerSet *set = [Lab2BGLayerSet cons];
		[set update:NULL curx:0 cury:0];
		[self addChild:set];
		if (![FreeRunStartAtManager get_can_start_at:FreeRunStartAt_WORLD3]) {
			[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD3];
			worldunlock_anim = [FreeRunStartAtUnlockUIAnimation cons_for_unlocking:FreeRunStartAt_WORLD3];
		}
		
	} else if (labnum == WorldNum_3) {
		BGLayerSet *set = [Lab3BGLayerSet cons];
		[set update:NULL curx:0 cury:0];
		[self addChild:set];
		
	}
	
	CCSprite *ground = [RepeatFillSprite cons_tex:[Resource get_tex:TEX_INTRO_ANIM_SS]
											 rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_lab_groundtex"]
											  rep:6];
	[ground setScale:0.5];
	[self addChild:ground];
	
	GROUNDLEVEL = [FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_lab_groundtex"].size.height*0.5 - 6;
	
	LabHandRail *rail = [LabHandRail cons_pt1:ccp(0,0) pt2:ccp([Common SCREEN].width*2,0)];
	[rail setPosition:ccp(0,GROUNDLEVEL)];
	rail.do_render = YES;
	[rail setScale:0.7];
	[self addChild:rail z:2];
	
	CGPoint cage_start = [Common screen_pctwid:0.65 pcthei:0.7];

	CCSprite *cage_chain = [CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
												  rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_chain"]];
	[cage_chain setScale:0.7];
	[cage_chain setAnchorPoint:ccp(0.5,0)];
	[cage_chain setPosition:ccp(cage_start.x,cage_start.y+20)];
	[self addChild:cage_chain];
	
	
	cage_base = [CCSprite_WithVel node];
	[cage_base setPosition:cage_start];
	[cage_base setScale:0.7];
	[self addChild:cage_base];
	
	cage_bottom = [CCSprite_WithVel spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
												   rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_open_bottom"]];
	[cage_base addChild:cage_bottom];
	cage_top = [CCSprite_WithVel spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
												rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_open_top"]];
	[cage_top setPosition:ccp(0,55)];
	[cage_base addChild:cage_top];
	
	dog = [CCSprite_WithVel node];
	[dog runAction:run_anim];
	[dog setAnchorPoint:ccp(0.5,0)];
	[dog setScale:0.7];
	[dog setPosition:ccp(-75,GROUNDLEVEL)];
	[self addChild:dog];
	
	mode = FreePupsAnimMode_RUNIN;
	cage_on_ground = NO;
	pups = [NSMutableArray array];
	[Common unset_dt];
	
	uianim = [FreePupsUIAnimation cons];
	[self addChild:uianim z:4];
	
	[self schedule:@selector(update:)];
	
	[self cons_menu_ui_worldnum:labnum];
	return self;
}

-(void)cons_menu_ui_worldnum:(WorldNum)worldnum {
	
	menu_ui = [CCSprite node];
	[self addChild:menu_ui z:50];
	[menu_ui setVisible:NO];
	[menu_ui addChild:[CCLayerColor layerWithColor:ccc4(50,50,50,200)]];
	
	left_curtain = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
										  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"curtain_left"]];
	right_curtain = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
										   rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"curtain_left"]];
	bg_curtain = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
										rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"curtain_bg"]];
	[right_curtain setScaleX:-1];
	[bg_curtain setAnchorPoint:ccp(0.5,0)];
	[bg_curtain setScaleX:[Common SCREEN].width/[bg_curtain boundingBox].size.width];
	[bg_curtain setScaleY:[Common SCREEN].height/[bg_curtain boundingBox].size.height];
	[menu_ui addChild:left_curtain];
	[menu_ui addChild:right_curtain];
	[menu_ui addChild:bg_curtain];
	[self set_curtain_animstart_positions];
	
    [ menu_ui addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.8]
                                        color:ccc3(255, 255, 255)
                                     fontsize:45
                                          str:[NSString stringWithFormat:@"World %d Complete!",(worldnum == WorldNum_3 ? 3 : (worldnum == WorldNum_2 ? 2 : 1))]]];
	

	CCSprite *disp_root = [CCSprite node];
	[disp_root setPosition:[Common screen_pctwid:0.5 pcthei:0.575]];
	[disp_root setScale:0.85];
	[menu_ui addChild:disp_root];
	
    CCSprite *timebg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfoblank"]];
    [disp_root addChild:timebg];
    
    CCSprite *bonesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfobones"]];
    [bonesbg setPosition:ccp(timebg.position.x, timebg.position.y - [timebg boundingBox].size.height - 5)];
    [disp_root addChild:bonesbg];
    
    CCSprite *livesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfolives"]];
    [livesbg setPosition:ccp(bonesbg.position.x,bonesbg.position.y - [bonesbg boundingBox].size.height - 5)];
    [disp_root addChild:livesbg];
	
	CCSprite *pointsbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfoblank"]];
	[pointsbg setPosition:ccp(bonesbg.position.x,livesbg.position.y - [livesbg boundingBox].size.height - 15)];
	[pointsbg setScale:1.3];
	[disp_root addChild:pointsbg];
	
	for (CCSprite *c in @[timebg,bonesbg,livesbg,pointsbg]) {
		[c setOpacity:200];
	}
	
    CCLabelTTF *pause_time_disp = [Common cons_label_pos:[Common pct_of_obj:timebg pctx:0.5 pcty:0.5]
                                       color:ccc3(255, 255, 255)
                                    fontsize:20
                                         str:[NSString stringWithFormat:@"Time: %@",[UICommon parse_gameengine_time:[g get_time]]]];
    [timebg addChild:pause_time_disp];
    
    CCLabelTTF *pause_bones_disp= [Common cons_label_pos:[Common pct_of_obj:bonesbg pctx:0.5 pcty:0.5]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:[NSString stringWithFormat:@"%d",[g get_num_bones]]];
    [bonesbg addChild:pause_bones_disp];
    
    CCLabelTTF *pause_lives_disp= [Common cons_label_pos:[Common pct_of_obj:livesbg pctx:0.5 pcty:0.5]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:[NSString stringWithFormat:@"%d",[g get_lives]]];
    [livesbg addChild:pause_lives_disp];
	
	CCLabelTTF *pause_points_disp = [Common cons_label_pos:[Common pct_of_obj:pointsbg pctx:0.5 pcty:0.5]
										 color:ccc3(255,255,255)
									  fontsize:20
										   str:[NSString stringWithFormat:@"Points: %d",[g.score get_score]]];
	[pointsbg addChild:pause_points_disp];
	
	CCLabelTTF *new_high_score_disp = [[Common cons_label_pos:[Common pct_of_obj:pointsbg pctx:1 pcty:1]
											color:ccc3(255,200,20)
										 fontsize:10
											  str:@"New Highscore!"] anchor_pt:ccp(1,1)];
	[pointsbg addChild:new_high_score_disp];
	[new_high_score_disp setVisible:[ScoreManager get_world_highscore:g.world_mode.cur_world] < [g.score get_score]];
	[ScoreManager set_world:worldnum highscore:[g.score get_score]];
	
    
    CCMenuItem *nextbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"nextbutton" tar:self sel:@selector(next)
                                                pos:[Common screen_pctwid:0.7 pcthei:0.45]];
    
    CCMenuItem *backbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"homebutton" tar:self sel:@selector(exit_to_menu)
                                               pos:[Common screen_pctwid:0.3 pcthei:0.45]];
    
    CCMenu *pausebuttons = [CCMenu menuWithItems:nextbutton,backbutton, nil];
    [pausebuttons setPosition:ccp(0,0)];
    [menu_ui addChild:pausebuttons];
	
	[UICommon button:nextbutton add_desctext:@"Continue" color:ccc3(255,255,255) fntsz:12];
	[UICommon button:backbutton add_desctext:@"To Menu" color:ccc3(255,255,255) fntsz:12];
	
	if (worldunlock_anim != NULL) {
		[menu_ui addChild:worldunlock_anim];
	}
}

-(void)next {
	[self exit];
	[g exit_to_next_world];
}

-(void)exit_to_menu {
	[self exit];
	[GEventDispatcher immediate_event:[GEvent cons_type:GEventType_QUIT]];
}

-(void)set_curtain_animstart_positions {
	[left_curtain setPosition:ccp(-[left_curtain boundingBox].size.width,[Common SCREEN].height/2.0)];
    [right_curtain setPosition:ccp([Common SCREEN].width + [left_curtain boundingBox].size.width,[Common SCREEN].height/2.0)];
	[bg_curtain setPosition:ccp([Common SCREEN].width/2.0,[Common SCREEN].height)];
	
	left_curtain_tpos = ccp([left_curtain boundingBox].size.width/2.0,[Common SCREEN].height/2.0);
	right_curtain_tpos = ccp([Common SCREEN].width-[right_curtain boundingBox].size.width/2.0,[Common SCREEN].height/2.0);
	bg_curtain_tpos = ccp([Common SCREEN].width/2.0,[Common SCREEN].height-[bg_curtain boundingBox].size.height*0.15);
}

-(void)open_menu {
	[AudioManager playbgm_imm:BGM_GROUP_JINGLE];
	mode = FreePupsAnimMode_MENU;
}

-(void)shake_for:(float)ct intensity:(float)intensity { //thx vlambeer
	shake_ct = ct;
	shake_intensity = intensity;
}

-(CGPoint)get_shake_offset {
	if (shake_ct <= 0) return CGPointZero;
	float t = float_random(-3.14, 3.14);
	Vec3D v = [VecLib scale:[VecLib cons_x:cosf(t) y:sinf(t) z:0] by:float_random(0,shake_intensity)];
	return ccp(v.x,v.y);
}

-(void)update:(ccTime)dt {
	[Common set_dt:dt];
	[uianim update];
	
	if (shake_ct > 0) {
		shake_ct -= [Common get_dt_Scale];
		CGPoint shake = [self get_shake_offset];
		[self.parent setPosition:shake];
	} else {
		[self.parent setPosition:CGPointZero];
	}
	
	if (mode == FreePupsAnimMode_RUNIN) {
		[dog setPosition:CGPointAdd(dog.position, ccp(3*[Common get_dt_Scale],0))];
		
		if (dog.position.x > [Common SCREEN].width*0.35) {
			mode = FreePupsAnimMode_ROLL;
			[dog stopAllActions];
			[dog runAction:roll_anim];
			[AudioManager playsfx:SFX_SPIN];
		}
		
	} else if (mode == FreePupsAnimMode_ROLL) {
		CGPoint target_pt = CGPointAdd(cage_base.position, ccp(-40,-35));
		Vec3D dir_v = [VecLib scale:[VecLib normalize:[VecLib cons_x:target_pt.x-dog.position.x y:target_pt.y-dog.position.y z:0]] by:6*[Common get_dt_Scale]];
		[dog setPosition:CGPointAdd(dog.position, ccp(dir_v.x,dir_v.y))];
		
		if (dog.position.x >= target_pt.x) {
			mode = FreePupsAnimMode_BREAKANDFALL;
			dog.vx = -4.5;
			dog.vy = 7;
			[AudioManager playsfx:SFX_ROCKBREAK];
			[self shake_for:20 intensity:4];
		}
		
	} else if (mode == FreePupsAnimMode_BREAKANDFALL) {
		[dog setPosition:CGPointAdd(dog.position, ccp(dog.vx*[Common get_dt_Scale],dog.vy*[Common get_dt_Scale]))];
		if (dog.vx < 0) {
			dog.vy -= 0.3 * [Common get_dt_Scale];
			if (dog.position.y <= GROUNDLEVEL) {
				dog.vx = 4;
				dog.vy = 0;
				[dog setPosition:ccp(dog.position.x,GROUNDLEVEL)];
				[dog stopAllActions];
				[dog runAction:run_anim];
			}
		}
		
		if (!cage_on_ground) {
			[cage_base setPosition:CGPointAdd(cage_base.position, ccp(0,-7*[Common get_dt_Scale]))];
			float cage_groundlevel = GROUNDLEVEL + [cage_bottom boundingBox].size.height * 0.5 * 0.7 - 10;
			if (cage_base.position.y <= cage_groundlevel) {
				cage_on_ground = YES;
				[self shake_for:20 intensity:4];
				[cage_base setPosition:ccp(cage_base.position.x,cage_groundlevel)];
				cage_top.vx = 3;
				cage_top.vy = 6;
				[AudioManager playsfx:SFX_BOP];
				[cage_bottom setTextureRect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_empty_back"]];
				[self reorderChild:cage_base z:1];
				for (int i = 0; i < 8; i++) {
					CCSprite_WithVel *pup = [CCSprite_WithVel spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
																		   rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:i%2==0?@"pupcage_pup_0":@"pupcage_pup_1"]];
					[pup setPosition:ccp(float_random(-20, 20),float_random(-10, 10))];
					pup.vx = float_random(1, 6) * (i<4?-1:1);
					pup.vy = float_random(3, 13);
					pup.vr = float_random(-10, 10);
					[pups addObject:pup];
					[cage_base addChild:pup];
				}
				[AudioManager playsfx:SFX_BARK_HIGH];
				[AudioManager playsfx:SFX_FANFARE_WIN after_do:[Common cons_callback:self sel:@selector(open_menu)]];
				
				[cage_base addChild:[CCSprite spriteWithTexture:[Resource get_tex:TEX_INTRO_ANIM_SS]
														   rect:[FileCache get_cgrect_from_plist:TEX_INTRO_ANIM_SS idname:@"pupcage_empty_bars"]]];
				
			}
			
		} else {
			[cage_top setPosition:CGPointAdd(cage_top.position, ccp(cage_top.vx*[Common get_dt_Scale],cage_top.vy*[Common get_dt_Scale]))];
			[cage_top setRotation:cage_top.rotation+10*[Common get_dt_Scale]];
			cage_top.vy -= 0.3 * [Common get_dt_Scale];
			
			for (CCSprite_WithVel *pup in pups) {
				[pup setPosition:CGPointAdd(pup.position, ccp(pup.vx*[Common get_dt_Scale],pup.vy*[Common get_dt_Scale]))];
				[pup setRotation:pup.rotation+pup.vr*[Common get_dt_Scale]];
				pup.vy -= 0.3 * [Common get_dt_Scale];
			}
		}
		
	} else if (mode == FreePupsAnimMode_MENU) {
		[menu_ui setVisible:YES];
		[left_curtain setPosition:ccp(
			left_curtain.position.x + (left_curtain_tpos.x - left_curtain.position.x)/4.0,
			left_curtain.position.y + (left_curtain_tpos.y - left_curtain.position.y)/4.0
		)];
		[right_curtain setPosition:ccp(
			right_curtain.position.x + (right_curtain_tpos.x - right_curtain.position.x)/4.0,
			right_curtain.position.y + (right_curtain_tpos.y - right_curtain.position.y)/4.0
		)];
		[bg_curtain setPosition:ccp(
			bg_curtain.position.x + (bg_curtain_tpos.x - bg_curtain.position.x)/4.0,
			bg_curtain.position.y + (bg_curtain_tpos.y - bg_curtain.position.y)/4.0
		)];
		
		if (worldunlock_anim != NULL) {
			[worldunlock_anim update];
		}
		
	}
}

-(void)exit {
	[self unscheduleAllSelectors];
	[self removeAllChildrenWithCleanup:YES];
	[[CCDirector sharedDirector] popScene];
}

-(void)cons_anim {
	run_anim = [Common cons_anim:@[@"run_0",@"run_1",@"run_2",@"run_3"] speed:0.1 tex_key:[Player get_character]];
	roll_anim = [Common cons_anim:@[@"roll_0",@"roll_1",@"roll_2",@"roll_3"] speed:0.05 tex_key:[Player get_character]];
}

@end
