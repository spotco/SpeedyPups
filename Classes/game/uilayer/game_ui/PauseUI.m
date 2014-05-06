#import "PauseUI.h"
#import "Common.h"
#import "Resource.h"
#import "MenuCommon.h"
#import "UserInventory.h"
#import "GameEngineLayer.h"
#import "UICommon.h"
#import "UILayer.h"

@implementation PauseUI

+(PauseUI*)cons {
    return [PauseUI node];
}

-(id)init {
    self = [super init];
    
    ccColor4B c = {50,50,50,220};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    CCNode *pause_ui = [CCLayerColor layerWithColor:c width:s.height height:s.width];
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
    
	ui_stuff = [CCSprite node];
	[pause_ui addChild:ui_stuff];
	
    [ui_stuff addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.8]
                                        color:ccc3(255, 255, 255)
                                     fontsize:45
                                          str:@"paused"]];
    
	CCSprite *disp_root = [CCSprite node];
	[disp_root setPosition:[Common screen_pctwid:0.575 pcthei:0.65]];
	[disp_root setScale:0.85];
	[ui_stuff addChild:disp_root];
    
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
	
	new_high_score_disp = [[Common cons_label_pos:[Common pct_of_obj:pointsbg pctx:1 pcty:1]
											color:ccc3(255,200,20)
										 fontsize:10
											  str:@"New Highscore!"] anchor_pt:ccp(1,1)];
	[pointsbg addChild:new_high_score_disp];
	
	
    
    CCMenuItem *retrybutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"retrybutton" tar:self sel:@selector(retry)
                                                pos:[Common screen_pctwid:0.35 pcthei:0.32]];
    
    CCMenuItem *playbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"playbutton" tar:self sel:@selector(unpause)
                                               pos:[Common screen_pctwid:0.94 pcthei:0.9]];
    
    CCMenuItem *backbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"prevbutton" tar:self sel:@selector(exit_to_menu)
                                               pos:[Common screen_pctwid:0.35 pcthei:0.6]];
    
    CCMenu *pausebuttons = [CCMenu menuWithItems:retrybutton,playbutton,backbutton, nil];
    [pausebuttons setPosition:ccp(0,0)];
    [ui_stuff addChild:pausebuttons];
    
    challenge_disp = [Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.12]
                                                   color:ccc3(255,255,255)
                                                fontsize:18
                                                     str:@""];
    [ui_stuff addChild:challenge_disp];
	
    
	[UICommon button:playbutton add_desctext:@"unpause" color:ccc3(255,255,255) fntsz:12];
	[UICommon button:retrybutton add_desctext:@"retry" color:ccc3(255,255,255) fntsz:12];
	[UICommon button:backbutton add_desctext:@"quit" color:ccc3(255,255,255) fntsz:12];
	
    [self addChild:pause_ui z:1];
	update_timer = [NSTimer scheduledTimerWithTimeInterval: 1/30.0
												  target: self
												selector:@selector(update)
												userInfo: nil repeats:YES];
	exit_to_gameover_menu = NO;
    
    return self;
}

-(void)update {
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
	if (exit_to_gameover_menu) {
		[ui_stuff setVisible:NO];
		if ([Common fuzzyeq_a:bg_curtain.position.y b:bg_curtain_tpos.y delta:1]) {
			[update_timer invalidate];
			[[CCDirector sharedDirector] resume];
			[(UILayer*)[self parent] to_gameover_menu];
			[AudioManager play_jingle];
		}
	}
}

-(void)setVisible:(BOOL)visible {
	[self set_curtain_animstart_positions];
	[super setVisible:visible];
}

-(void)set_curtain_animstart_positions {
	[left_curtain setPosition:ccp(-left_curtain.boundingBoxInPixels.size.width,[Common SCREEN].height/2.0)];
    [right_curtain setPosition:ccp([Common SCREEN].width + left_curtain.boundingBoxInPixels.size.width,[Common SCREEN].height/2.0)];
	[bg_curtain setPosition:ccp([Common SCREEN].width/2.0,[Common SCREEN].height)];
	
	left_curtain_tpos = ccp(left_curtain.boundingBoxInPixels.size.width/2.0,[Common SCREEN].height/2.0);
	right_curtain_tpos = ccp([Common SCREEN].width-right_curtain.boundingBoxInPixels.size.width/2.0,[Common SCREEN].height/2.0);
	bg_curtain_tpos = ccp([Common SCREEN].width/2.0,[Common SCREEN].height-bg_curtain.boundingBoxInPixels.size.height*0.15);
}

-(void)set_challenge_msg:(NSString *)msg {
    [challenge_disp setString:msg];
}

-(void)update_labels_lives:(NSString *)lives bones:(NSString *)bones time:(NSString *)time score:(NSString*)score highscore:(BOOL)highscore {
    [pause_lives_disp setString:lives];
    [pause_bones_disp setString:bones];
    [pause_time_disp setString:time];
	[pause_points_disp setString:score];
	[new_high_score_disp setVisible:highscore];
}

-(void)retry {
	[update_timer invalidate];
    [(UILayer*)[self parent] retry];
	[AudioManager playsfx:SFX_MENU_DOWN];
}

-(void)unpause {
    [(UILayer*)[self parent] unpause];
	[AudioManager playsfx:SFX_MENU_DOWN];
}

-(void)exit_to_menu {
	[AudioManager playsfx:SFX_MENU_DOWN];
	exit_to_gameover_menu = YES;
	bg_curtain_tpos = ccp([Common SCREEN].width/2.0,0);
}

-(void)removeAllChildrenWithCleanup:(BOOL)cleanup {
	[update_timer invalidate];
	[super removeAllChildrenWithCleanup:cleanup];
}

@end
