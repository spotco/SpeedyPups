#import "AskContinueUI.h"
#import "PauseUI.h"
#import "Common.h"
#import "Resource.h"
#import "MenuCommon.h"
#import "UserInventory.h"
#import "GameEngineLayer.h"
#import "UICommon.h"
#import "UILayer.h"
#import "BoneCollectUIAnimation.h"

@implementation AskContinueUI

+(AskContinueUI*)cons {
    return [AskContinueUI node];
}

-(id)init {
    self = [super init];
    
    ccColor4B c = {50,50,50,220};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    ask_continue_ui = [CCLayerColor layerWithColor:c width:s.height height:s.width];
	
	playericon = [[CCSprite spriteWithTexture:[Resource get_tex:[Player get_character]]
										 rect:[FileCache get_cgrect_from_plist:[Player get_character] idname:@"hit_3"]]
				  pos:[Common screen_pctwid:0.5 pcthei:0.4]];
    [ask_continue_ui addChild:playericon];
	
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
	[self set_curtain_animstart_positions];
	
	[ask_continue_ui addChild:bg_curtain];
	[ask_continue_ui addChild:right_curtain];
	[ask_continue_ui addChild:left_curtain];
    
    [ask_continue_ui addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                                      rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"spotlight"]]
                               pos:[Common screen_pctwid:0.5 pcthei:0.6]]];
	
    continue_logo = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
											rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"continue"]]
					 pos:[Common screen_pctwid:0.5 pcthei:0.8]];
    [ask_continue_ui addChild:continue_logo];
    
    CCMenuItem *yes = [MenuCommon item_from:TEX_UI_INGAMEUI_SS
                                       rect:@"yesbutton"
                                        tar:self sel:@selector(continue_yes)
                                        pos:[Common screen_pctwid:0.3 pcthei:0.4]];
    
    CCMenuItem *no = [MenuCommon item_from:TEX_UI_INGAMEUI_SS
                                      rect:@"nobutton"
                                       tar:self sel:@selector(continue_no)
                                       pos:[Common screen_pctwid:0.7 pcthei:0.4]];
    
    yesnomenu = [CCMenu menuWithItems:yes,no, nil];
    [yesnomenu setPosition:CGPointZero];
    [ask_continue_ui addChild:yesnomenu];
    
    countdown_disp = [Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.575]
                                      color:ccc3(220, 10, 10) fontsize:50 str:@""];
    [ask_continue_ui addChild:countdown_disp];
	
	//continue price pane, below yes button
	continue_price_pane = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
														   rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"continue_price_bg"]]
									 pos:[Common screen_pctwid:0.3 pcthei:0.25]];
	[continue_price_pane addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
														 rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"tinybone"]
								   ] pos:[Common pct_of_obj:continue_price_pane pctx:0.15 pcty:0.25]]];
	[continue_price_pane addChild:[Common cons_label_pos:[Common pct_of_obj:continue_price_pane pctx:0.2 pcty:0.625]
												   color:ccc3(0,0,0)
												fontsize:10
													 str:@"price"]];
	continue_price = [Common cons_label_pos:[Common pct_of_obj:continue_price_pane pctx:0.62 pcty:0.275]
									  color:ccc3(255,0,0)
								   fontsize:18
										str:@"000000"];
	[continue_price_pane addChild:continue_price];
	[ask_continue_ui addChild:continue_price_pane];
	
	//total bones pane, bottom right
	CCSprite *total_bones_pane = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
														 rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"continue_total_bg"]]
								  pos:[Common screen_pctwid:0.89 pcthei:0.075]];
	[total_bones_pane addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													   rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"tinybone"]
								 ] pos:[Common pct_of_obj:total_bones_pane pctx:0.15 pcty:0.3]]];
	[total_bones_pane addChild:[Common cons_label_pos:[Common pct_of_obj:total_bones_pane pctx:0.325 pcty:0.75]
												color:ccc3(0,0,0)
											 fontsize:10
												  str:@"Total Bones"]];
	total_disp = [Common cons_label_pos:[Common pct_of_obj:total_bones_pane pctx:0.525 pcty:0.325]
								  color:ccc3(255,0,0)
							   fontsize:20
									str:@"000000"];
	[total_bones_pane addChild:total_disp];
	[ask_continue_ui addChild:total_bones_pane];
	 
    [self addChild:ask_continue_ui];
	bone_anims = [NSMutableArray array];
	
    return self;
}

-(void)set_curtain_animstart_positions {
	[left_curtain setPosition:ccp(-left_curtain.boundingBoxInPixels.size.width,[Common SCREEN].height/2.0)];
    [right_curtain setPosition:ccp([Common SCREEN].width + left_curtain.boundingBoxInPixels.size.width,[Common SCREEN].height/2.0)];
	[bg_curtain setPosition:ccp([Common SCREEN].width/2.0,[Common SCREEN].height)];
	
	left_curtain_tpos = ccp(left_curtain.boundingBoxInPixels.size.width/2.0,[Common SCREEN].height/2.0);
	right_curtain_tpos = ccp([Common SCREEN].width-right_curtain.boundingBoxInPixels.size.width/2.0,[Common SCREEN].height/2.0);
	bg_curtain_tpos = ccp([Common SCREEN].width/2.0,[Common SCREEN].height-bg_curtain.boundingBoxInPixels.size.height*0.15);
}

-(void)start_countdown:(int)cost {
	
	[AudioManager sto_prev_group];
	[AudioManager bgm_stop];
	[AudioManager playsfx:SFX_FANFARE_LOSE after_do:[Common cons_callback:(NSObject*)[AudioManager class] sel:@selector(play_jingle)]];
	
	
	[self set_curtain_animstart_positions];
    countdown_ct = 10;
	mod_ct = 1;
	countdown_disp_scale = 3;
    continue_cost = cost;
	continue_price_pane_vs = 0.01;
	
	[countdown_disp setVisible:YES];
	[yesnomenu setVisible:YES];
	[playericon setPosition:[Common screen_pctwid:0.5 pcthei:0.4]];
	[playericon setTextureRect:[FileCache get_cgrect_from_plist:[Player get_character] idname:@"hit_3"]];
	
	curmode = AskContinueUI_COUNTDOWN;
	
    [self schedule:@selector(update:) interval:1/30.0];
    [countdown_disp setString:[NSString stringWithFormat:@"%d",countdown_ct]];
    [continue_price setString:[NSString stringWithFormat:@"%d",cost]];
    [total_disp setString:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
}


-(void)update:(ccTime)delta {
	[Common set_dt:delta];
	mod_ct++;
	
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
	
	if (curmode == AskContinueUI_COUNTDOWN) {
		[self update_countdown];
		
	} else if (curmode == AskContinueUI_YES_TRANSFER_MONEY) {
		[self update_transfer_bones];
		
	} else if (curmode == AskContinueUI_YES_RUNOUT) {
		[self update_runout];
	
	} else if (curmode == AskContinueUI_TRANSITION_TO_GAMEOVER) {
		if ([Common fuzzyeq_a:bg_curtain.position.y b:bg_curtain_tpos.y delta:1]) {
			[self to_gameover_screen];
		}
		
	}
}

-(void)stop_countdown {
    [self unschedule:@selector(update:)];
}

-(void)continue_no {
	curmode = AskContinueUI_TRANSITION_TO_GAMEOVER;
	bg_curtain_tpos = ccp([Common SCREEN].width/2.0,0);
	for (CCNode *i in ask_continue_ui.children) {
		if (i != left_curtain && i != right_curtain && i != bg_curtain) {
			[i setVisible:NO];
		}
	}
	
}

-(void)continue_yes {
    if ([UserInventory get_current_bones] >= continue_cost) {
		[AudioManager todos_remove_all];
		[countdown_disp setVisible:NO];
		[UserInventory add_bones:-continue_cost];
		countdown_ct = 1; //works as transfer rate now
		[yesnomenu setVisible:NO];
		actual_next_continue_price = continue_cost*2;
		[continue_price_pane setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"continue_price_bg_nopoke"]];
		curmode = AskContinueUI_YES_TRANSFER_MONEY;
		
    } else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough bones for a continue!"
														message:@""
													   delegate:self
											  cancelButtonTitle:@"Ok :("
											  otherButtonTitles:nil];
		[alert show];
		curmode = AskContinueUI_COUNTDOWN_PAUSED;
		
	}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"clique sur bouton:%d",buttonIndex);
	curmode = AskContinueUI_COUNTDOWN;
}

-(void)update_countdown {
	countdown_disp_scale = countdown_disp_scale - (countdown_disp_scale-1)/3;
	[countdown_disp setScale:countdown_disp_scale];
	
	if (continue_price_pane.scale > 1.1) {
		continue_price_pane.scale = 1.1;
		continue_price_pane_vs = -0.01;
		
	} else if (continue_price_pane.scale < 0.9) {
		continue_price_pane.scale = 0.9;
		continue_price_pane_vs = 0.01;
	}
	[continue_price_pane setScale:continue_price_pane.scale + continue_price_pane_vs];
	
	
	if (mod_ct%30==0) {
		countdown_ct--;
		[countdown_disp setString:[NSString stringWithFormat:@"%d",countdown_ct]];
		countdown_disp_scale = 3;
		if (countdown_ct == 3 || countdown_ct == 2 || countdown_ct == 1) {
			[AudioManager playsfx:SFX_READY];
		}
		if (countdown_ct <= 0) {
			[self continue_no];
			return;
		}
	}
}

-(void)update_transfer_bones {
	NSMutableArray *toremove = [NSMutableArray array];
	for (UIIngameAnimation *i in bone_anims) {
		[i update];
		if (i.ct <= 0) {
			[self removeChild:i cleanup:YES];
			[toremove addObject:i];
		}
	}
	[bone_anims removeObjectsInArray:toremove];
	[toremove removeAllObjects];
	
	if (bone_anims.count != 0) {
		if (mod_ct % 3 == 0) {
			player_anim_ct++;
			if (player_anim_ct%2==0) {
				[playericon setTextureRect:[FileCache get_cgrect_from_plist:[Player get_character] idname:@"hit_3"]];
			} else {
				[playericon setTextureRect:[FileCache get_cgrect_from_plist:[Player get_character] idname:@"hit_2"]];
			}
		}
	}
	
	if (continue_cost > 0) {
		int neutotal = total_disp.string.integerValue-countdown_ct;
		int neuprix = continue_price.string.integerValue+countdown_ct;
		continue_cost-=countdown_ct;
		if (mod_ct%10==0) countdown_ct *= 2;
		[continue_price setString:[NSString stringWithFormat:@"%d",neuprix]];
		[total_disp setString:[NSString stringWithFormat:@"%d",neutotal]];
		
		if (mod_ct%2==0) {
			BoneCollectUIAnimation *neuanim = [BoneCollectUIAnimation cons_start:[Common screen_pctwid:0.89 pcthei:0.075]
																			 end:CGPointAdd(playericon.position,ccp(-30,15))];
			[bone_anims addObject:neuanim];
			[self addChild:neuanim];
			[AudioManager playsfx:SFX_BONE];
			
		}
		
	} else if (bone_anims.count != 0) {
		[continue_price setString:[NSString stringWithFormat:@"%d",actual_next_continue_price]];
		[total_disp setString:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
		
	} else {
		[playericon setTextureRect:[FileCache get_cgrect_from_plist:[Player get_character] idname:@"hit_3"]];
		[continue_price setString:[NSString stringWithFormat:@"%d",actual_next_continue_price]];
		[total_disp setString:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
		continue_cost = 10; //used as pause ct now
		[playericon setTextureRect:[FileCache get_cgrect_from_plist:[Player get_character] idname:@"run_0"]];
		[Player character_bark];
		curmode = AskContinueUI_YES_RUNOUT;
		
		[AudioManager bgm_stop];
		[AudioManager playsfx:SFX_FANFARE_WIN after_do:[Common cons_callback:(NSObject*)[AudioManager class] sel:@selector(play_prev_group)]];
		
		
	}
}

-(void)update_runout {
	if (continue_cost > 0) {
		continue_cost--;
		
	} else if (playericon.position.x < [Common SCREEN].width) {
		playericon.position = CGPointAdd(playericon.position, ccp(10,0));
		if (mod_ct % 2 == 0) {
			player_anim_ct = (player_anim_ct + 1) % 4;
			[playericon setTextureRect:[FileCache get_cgrect_from_plist:[Player get_character]
																 idname:[NSString stringWithFormat:@"run_%d",player_anim_ct]]];
		}
		
	} else {
		[(UILayer*)[self parent] continue_game];
		[self stop_countdown];
		
	}
}

-(void)to_gameover_screen {
	[self stop_countdown];
    [(UILayer*)[self parent] to_gameover_menu];
}

@end
