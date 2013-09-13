#import "PauseUI.h"
#import "Common.h"
#import "Resource.h"
#import "MenuCommon.h"
#import "UserInventory.h"
#import "GameEngineLayer.h"
#import "UICommon.h"
#import "UILayer.h"

#import "InventoryItemPane.h"

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
    
    [pause_ui addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.8]
                                        color:ccc3(255, 255, 255)
                                     fontsize:45
                                          str:@"paused"]];
    
    CCSprite *timebg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfoblank"]];
    [timebg setPosition:[Common screen_pctwid:0.6 pcthei:0.6]];
    [pause_ui addChild:timebg];
    
    CCSprite *bonesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfobones"]];
    [bonesbg setPosition:[Common screen_pctwid:0.6 pcthei:0.45]];
    [pause_ui addChild:bonesbg];
    
    CCSprite *livesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfolives"]];
    [livesbg setPosition:[Common screen_pctwid:0.6 pcthei:0.3]];
    [pause_ui addChild:livesbg];
	
	for (CCSprite *c in @[timebg,bonesbg,livesbg]) {
		[c setOpacity:200];
	}
    
    pause_time_disp = [Common cons_label_pos:[Common screen_pctwid:0.6 pcthei:0.6]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0:00"];
    [pause_ui addChild:pause_time_disp];
    
    pause_bones_disp= [Common cons_label_pos:[Common screen_pctwid:0.6 pcthei:0.45]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0"];
    [pause_ui addChild:pause_bones_disp];
    
    pause_lives_disp= [Common cons_label_pos:[Common screen_pctwid:0.6 pcthei:0.3]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0"];
    [pause_ui addChild:pause_lives_disp];
    
    CCMenuItem *retrybutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"retrybutton" tar:self sel:@selector(retry)
                                                pos:[Common screen_pctwid:0.3 pcthei:0.32]];
    
    CCMenuItem *playbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"playbutton" tar:self sel:@selector(unpause)
                                               pos:[Common screen_pctwid:0.94 pcthei:0.9]];
    
    CCMenuItem *backbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"homebutton" tar:self sel:@selector(exit_to_menu)
                                               pos:[Common screen_pctwid:0.3 pcthei:0.6]];
    
    CCMenu *pausebuttons = [CCMenu menuWithItems:retrybutton,playbutton,backbutton, nil];
    [pausebuttons setPosition:ccp(0,0)];
    [pause_ui addChild:pausebuttons];
    
    challenge_disp = [Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.13]
                                                   color:ccc3(255,255,255)
                                                fontsize:20
                                                     str:@""];
    [pause_ui addChild:challenge_disp];
	
    
	[UICommon button:playbutton add_desctext:@"unpause" color:ccc3(255,255,255) fntsz:12];
	[UICommon button:retrybutton add_desctext:@"retry" color:ccc3(255,255,255) fntsz:12];
	[UICommon button:backbutton add_desctext:@"to menu" color:ccc3(255,255,255) fntsz:12];
	
    [self addChild:pause_ui z:1];
	update_timer = [NSTimer scheduledTimerWithTimeInterval: 1/30.0
												  target: self
												selector:@selector(update)
												userInfo: nil repeats:YES];
    
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

-(void)update_labels_lives:(NSString *)lives bones:(NSString *)bones time:(NSString *)time {
    [pause_lives_disp setString:lives];
    [pause_bones_disp setString:bones];
    [pause_time_disp setString:time];
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
	[update_timer invalidate];
    [(UILayer*)[self parent] exit_to_menu];
	[AudioManager playsfx:SFX_MENU_DOWN];
}

@end
