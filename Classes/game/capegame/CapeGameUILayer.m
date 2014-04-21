#import "CapeGameUILayer.h"
#import "IngameUI.h"
#import "UICommon.h"
#import "Common.h"
#import "FileCache.h"
#import "Resource.h"
#import "MenuCommon.h"
#import "GameMain.h"
#import "CapeGameEngineLayer.h"
#import "UILayer.h"
#import "BoneCollectUIAnimation.h"
#import "ChallengeInfoTitleCardAnimation.h"
#import "GameEngineLayer.h"
#import "ScoreManager.h"

@implementation CapeGameUILayer

+(CapeGameUILayer*)cons_g:(CapeGameEngineLayer*)g {
	CapeGameUILayer *l = [[CapeGameUILayer node] cons:g];
	return l;
}

-(id)cons:(CapeGameEngineLayer*)g {
	cape_game = g;
	
	ingame_ui = [CCNode node];
	
	CCSprite *pauseicon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseicon"]];
	CCSprite *pauseiconzoom = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseicon"]];
	
    [UICommon set_zoom_pos_align:pauseicon zoomed:pauseiconzoom scale:1.4];
    
    CCMenuItemImage *ingamepause = [MRectCCMenuItemImage itemFromNormalSprite:pauseicon
															   selectedSprite:pauseiconzoom
																	   target:self
																	 selector:@selector(pause)];
    [ingamepause setPosition:ccp(
		 [Common SCREEN].width-pauseicon.boundingBoxInPixels.size.width+10,
		 [Common SCREEN].height-pauseicon.boundingBoxInPixels.size.height+10
	 )];
	
	CCSprite *bone_disp_icon = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"ingame_ui_bone_icon"]] pos:[Common screen_pctwid:0.06 pcthei:0.96]];
	CCSprite *lives_disp_icon = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"ingame_ui_lives_icon"]] pos:[Common screen_pctwid:0.06 pcthei:0.88]];
	CCSprite *time_disp_icon = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"ingame_ui_time_icon"]] pos:[Common screen_pctwid:0.06 pcthei:0.8]];
	
	bones_disp = [[Common cons_label_pos:[Common pct_of_obj:bone_disp_icon pctx:0.5 pcty:0.42] color:ccc3(200,30,30) fontsize:13 str:@""] anchor_pt:ccp(0,0.5)];
	lives_disp = [[Common cons_label_pos:[Common pct_of_obj:lives_disp_icon pctx:0.5 pcty:0.412] color:ccc3(200,30,30) fontsize:15 str:@""] anchor_pt:ccp(0,0.5)];
	time_disp = [[Common cons_label_pos:[Common pct_of_obj:time_disp_icon pctx:0.5 pcty:0.44] color:ccc3(200,30,30) fontsize:12 str:@""] anchor_pt:ccp(0,0.5)];
	
	[bone_disp_icon addChild:bones_disp];
	[lives_disp_icon addChild:lives_disp];
	[time_disp_icon addChild:time_disp];
	
	[ingame_ui addChild:bone_disp_icon];
	[ingame_ui addChild:lives_disp_icon];
	[ingame_ui addChild:time_disp_icon];
    
    CCMenu *ingame_ui_m = [CCMenu menuWithItems:ingamepause,nil];
    
    ingame_ui_m.anchorPoint = ccp(0,0);
    ingame_ui_m.position = ccp(0,0);
    [ingame_ui addChild:ingame_ui_m];
	
	itemlenbarroot = [CCSprite node];
	if (cape_game.is_boss_capegame) [self itembar_set_visible:NO];
	CCSprite *itemlenbarback = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																					 idname:@"item_timebaremptytex"]];
	[itemlenbarroot addChild:itemlenbarback];
	itemlenbarfill = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
											rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																		   idname:@"item_timebarfulltex"]];
	[itemlenbarroot addChild:itemlenbarfill];
	
	[itemlenbarback setAnchorPoint:ccp(0,0.5)];
	[itemlenbarfill setAnchorPoint:ccp(0,0.5)];
	
	[itemlenbarback setPosition:ccp(-68,0)];
	[itemlenbarfill setPosition:ccp(-68,0)];
	
	[itemlenbarroot addChild:[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																				   idname:@"item_timebar"]]];
	[itemlenbarroot setPosition:[Common screen_pctwid:0.82 pcthei:0.09]];
	
    [ingame_ui addChild:itemlenbarroot];
	[itemlenbarfill setScaleX:1];
	for (CCSprite *i in [itemlenbarroot children]) {
		[i setOpacity:175];
	}
	itemlenbaricon =
		[CCSprite spriteWithTexture:[Resource get_tex:TEX_ITEM_SS]
							   rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:[g is_boss_capegame]?@"item_rocket":@"item_dogcape"]];
	[itemlenbaricon setPosition:ccp(52.5,0)];
	[itemlenbaricon setScale:0.8];
	[itemlenbaricon setOpacity:200];
	[itemlenbarroot addChild:itemlenbaricon];
	
	[self cons_pause_ui];
	
	[self addChild:ingame_ui];
	[self addChild:pause_ui];
	[pause_ui setVisible:NO];
	
	uianim_holder = [CCNode node];
	[ingame_ui addChild:uianim_holder];
	uianims = [NSMutableArray array];
	
	scoredispbg = [[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
										   rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																		  idname:@"challengedescbg"]]
					pos:[Common screen_pctwid:0.01 pcthei:0.07]] anchor_pt:ccp(0,0.5)];
	[scoredispbg setOpacity:140];
	scoredisp = [[Common cons_label_pos:[Common pct_of_obj:scoredispbg pctx:0.1 pcty:0.375]
								  color:ccc3(0,0,0)
							   fontsize:16
									str:@"Pts \u00B7 9999999"] anchor_pt:ccp(0,0.5)];
	[scoredispbg addChild:scoredisp];
	multdisp = [[Common cons_label_pos:[Common pct_of_obj:scoredispbg pctx:0.1 pcty:0.75]
								 color:ccc3(200,30,30)
							  fontsize:12
								   str:@"Mult \u00B7 1"] anchor_pt:ccp(0,0.5)];
	[scoredispbg addChild:multdisp];
	[ingame_ui addChild:scoredispbg];
	current_disp_score = [cape_game.get_main_game.score get_score];
	current_disp_mult = [cape_game.get_main_game.score get_multiplier];
	
	return self;
}

-(void)itembar_set_visible:(BOOL)b {
	[itemlenbarroot setVisible:b];
}

-(void)cons_pause_ui {
	ccColor4B c = {50,50,50,220};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    pause_ui = [CCLayerColor layerWithColor:c width:s.height height:s.width];
    pause_ui.anchorPoint = ccp(0,0);
    [pause_ui setPosition:ccp(0,0)];
	
	left_curtain = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
										  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"curtain_left"]];
	right_curtain = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
										   rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"curtain_left"]];
	bg_curtain = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
										rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"curtain_bg"]];
	[right_curtain setScaleX:-1];
	[bg_curtain setAnchorPoint:ccp(0.5,0)];
	[bg_curtain setScaleX:[Common SCREEN].width/bg_curtain.boundingBoxInPixels.size.width];
	[bg_curtain setScaleY:[Common SCREEN].height/bg_curtain.boundingBoxInPixels.size.height];
	[pause_ui addChild:bg_curtain];
	[pause_ui addChild:left_curtain];
	[pause_ui addChild:right_curtain];
	[self set_curtain_animstart_positions];
    
    [pause_ui addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.8]
                                        color:ccc3(255, 255, 255)
                                     fontsize:45
                                          str:@"paused"]];
	
	CCSprite *disp_root = [CCSprite node];
	[disp_root setPosition:[Common screen_pctwid:0.575 pcthei:0.65]];
	[disp_root setScale:0.85];
	[pause_ui addChild:disp_root];
    
    CCSprite *bonesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfobones"]];
    [disp_root addChild:bonesbg];
    
    CCSprite *livesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfolives"]];
    [livesbg setPosition:ccp(livesbg.position.x, livesbg.position.y - livesbg.boundingBoxInPixels.size.height - 5)];
    [disp_root addChild:livesbg];
	
	CCSprite *timebg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfoblank"]];
    [timebg setPosition:ccp(livesbg.position.x,livesbg.position.y - livesbg.boundingBoxInPixels.size.height - 5)];
	[disp_root addChild:timebg];
	
	CCSprite *pointsbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfoblank"]];
	[pointsbg setPosition:ccp(timebg.position.x,timebg.position.y - timebg.boundingBoxInPixels.size.height - 10)];
	[pointsbg setScale:1.25];
	[disp_root addChild:pointsbg];
	
	for (CCSprite *c in @[timebg,bonesbg,livesbg,pointsbg]) {
		[c setOpacity:200];
	}
    
    pause_time_disp = [Common cons_label_pos:[Common pct_of_obj:timebg pctx:0.5 pcty:0.5]
                                       color:ccc3(255, 255, 255)
                                    fontsize:20
                                         str:@"Time: 0:00"];
    [timebg addChild:pause_time_disp];
    
    pause_bones_disp= [Common cons_label_pos:[Common pct_of_obj:bonesbg pctx:0.5 pcty:0.5]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0"];
    [bonesbg addChild:pause_bones_disp];
    
    pause_lives_disp= [Common cons_label_pos:[Common pct_of_obj:livesbg pctx:0.5 pcty:0.5]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0"];
    [livesbg addChild:pause_lives_disp];
	
	pause_points_disp = [Common cons_label_pos:[Common pct_of_obj:pointsbg pctx:0.5 pcty:0.5]
										 color:ccc3(255,255,255)
									  fontsize:20
										   str:@""];
	[pointsbg addChild:pause_points_disp];
	
	pause_new_high_score_disp = [[Common cons_label_pos:[Common pct_of_obj:pointsbg pctx:1 pcty:1]
											color:ccc3(255,200,20)
										 fontsize:10
											  str:@"New Highscore!"] anchor_pt:ccp(1,1)];
	[pointsbg addChild:pause_new_high_score_disp];
    
    CCMenuItem *retrybutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"retrybutton" tar:self sel:@selector(retry)
                                                pos:[Common screen_pctwid:0.3 pcthei:0.32]];
    
    CCMenuItem *playbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"playbutton" tar:self sel:@selector(unpause)
                                               pos:[Common screen_pctwid:0.94 pcthei:0.9]];
    
    CCMenuItem *backbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"homebutton" tar:self sel:@selector(exit_to_menu)
                                               pos:[Common screen_pctwid:0.3 pcthei:0.6]];
    
    CCMenu *pausebuttons = [CCMenu menuWithItems:retrybutton,playbutton,backbutton, nil];
    [pausebuttons setPosition:ccp(0,0)];
    [pause_ui addChild:pausebuttons];
    
	[UICommon button:playbutton add_desctext:@"unpause" color:ccc3(255,255,255) fntsz:12];
	[UICommon button:retrybutton add_desctext:@"retry" color:ccc3(255,255,255) fntsz:12];
	[UICommon button:backbutton add_desctext:@"to menu" color:ccc3(255,255,255) fntsz:12];
	
	update_timer = [NSTimer scheduledTimerWithTimeInterval: 1/30.0
													target: self
												  selector:@selector(update_pause_menu)
												  userInfo: nil repeats:YES];

}

-(void)update {
    NSMutableArray *toremove = [NSMutableArray array];
    for (UIIngameAnimation *i in uianims) {
        [i update];
        if (i.ct <= 0) {
            [uianim_holder removeChild:i cleanup:YES];
            [toremove addObject:i];
			[i repool];
        }
    }
    [uianims removeObjectsInArray:toremove];
    [toremove removeAllObjects];
	
	[self update_scoredisp:[cape_game get_main_game]];
}

-(void)update_scoredisp:(GameEngineLayer*)g {
	if (current_disp_score != [g.score get_score]) {
		if (ABS([g.score get_score] - current_disp_score) > 1) {
			current_disp_score = current_disp_score + ([g.score get_score] - current_disp_score)/4;
			
		} else {
			current_disp_score = [g.score get_score];
		}
		
	}
	[scoredisp set_label:strf("Pts \u00B7 %d",(int)current_disp_score)];
	[multdisp set_label:strf("Mult \u00B7 %.2f",[g.score get_multiplier])];
}

-(void)update_pause_menu {
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
}

-(void)set_curtain_animstart_positions {
	[left_curtain setPosition:ccp(-left_curtain.boundingBoxInPixels.size.width,[Common SCREEN].height/2.0)];
    [right_curtain setPosition:ccp([Common SCREEN].width + left_curtain.boundingBoxInPixels.size.width,[Common SCREEN].height/2.0)];
	[bg_curtain setPosition:ccp([Common SCREEN].width/2.0,[Common SCREEN].height)];
	
	left_curtain_tpos = ccp(left_curtain.boundingBoxInPixels.size.width/2.0,[Common SCREEN].height/2.0);
	right_curtain_tpos = ccp([Common SCREEN].width-right_curtain.boundingBoxInPixels.size.width/2.0,[Common SCREEN].height/2.0);
	bg_curtain_tpos = ccp([Common SCREEN].width/2.0,[Common SCREEN].height-bg_curtain.boundingBoxInPixels.size.height*0.15);
}

-(CCLabelTTF*)bones_disp { return bones_disp; }
-(CCLabelTTF*)lives_disp { return lives_disp; }
-(CCLabelTTF*)time_disp { return time_disp; }

-(void)update_pct:(float)pct {
	[itemlenbarfill setScaleX:pct];
}

-(void)do_bone_collect_anim:(CGPoint)start {
    BoneCollectUIAnimation* b = [BoneCollectUIAnimation cons_start:start end:[Common screen_pctwid:0 pcthei:1]];
    [uianim_holder addChild:b];
    [uianims addObject:b];
}

-(void)do_tutorial_anim {
	UIIngameAnimation *ua = [MessageTitleCardAnimation cons_msg:@"Touch to fly,\nand watch out for spikes!"];
	[uianim_holder addChild:ua];
	[uianims addObject:ua];
}

-(void)pause {
	[AudioManager playsfx:SFX_MENU_UP];
	[[CCDirector sharedDirector] pause];
	[self set_curtain_animstart_positions];
	[ingame_ui setVisible:NO];
	[pause_ui setVisible:YES];
	
	[pause_bones_disp setString:[bones_disp string]];
	[pause_lives_disp setString:[lives_disp string]];
	[pause_time_disp setString:[time_disp string]];
	[pause_points_disp setString:strf("Score \u00B7 %d",[cape_game.get_main_game.score get_score])];
	[pause_new_high_score_disp setVisible:[ScoreManager get_world_highscore:cape_game.get_main_game.world_mode.cur_world] < [cape_game.get_main_game.score get_score]];
}

-(void)retry {
	[AudioManager playsfx:SFX_MENU_DOWN];
	[[CCDirector sharedDirector] resume];
	[update_timer invalidate];
	[[CCDirector sharedDirector] popScene];
	
	GameModeCallback *cbv = [[[cape_game get_main_game] get_ui_layer] get_retry_callback];
	if (cbv == NULL) {
		NSLog(@"cbv is null");
		[GEventDispatcher push_event:[GEvent cons_type:GEventType_QUIT]];
		
	} else {
		[GEventDispatcher push_event:[[GEvent cons_type:GEventType_RETRY_WITH_CALLBACK] add_key:@"callback" value:cbv]];
	}
	
}

-(void)unpause {
	[AudioManager playsfx:SFX_MENU_DOWN];
	[[CCDirector sharedDirector] resume];
	[ingame_ui setVisible:YES];
	[pause_ui setVisible:NO];
}

-(void)exit_to_menu {
	cape_game.get_main_game.current_mode = GameEngineLayerMode_GAMEEND;
	[AudioManager playsfx:SFX_MENU_DOWN];
	[[CCDirector sharedDirector] resume];
	[update_timer invalidate];
	[[CCDirector sharedDirector] popScene];
	[GEventDispatcher push_event:[GEvent cons_type:GEventType_QUIT]];
}

-(void)exit {
	[update_timer invalidate];
	cape_game = NULL;
}

-(void)dealloc {
	for (UIIngameAnimation *i in uianims) {
		[uianim_holder removeChild:i cleanup:YES];
		[i repool];
	}
	[uianims removeAllObjects];
	[self removeAllChildrenWithCleanup:YES];
}

@end
