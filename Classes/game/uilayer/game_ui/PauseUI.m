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
    
    [pause_ui addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.8]
                                        color:ccc3(255, 255, 255)
                                     fontsize:45
                                          str:@"paused"]];
    
    CCSprite *timebg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfoblank"]];
    [timebg setPosition:[Common screen_pctwid:0.75 pcthei:0.6]];
    [pause_ui addChild:timebg];
    
    CCSprite *bonesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfobones"]];
    [bonesbg setPosition:[Common screen_pctwid:0.75 pcthei:0.45]];
    [pause_ui addChild:bonesbg];
    
    CCSprite *livesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfolives"]];
    [livesbg setPosition:[Common screen_pctwid:0.75 pcthei:0.3]];
    [pause_ui addChild:livesbg];
	
	for (CCSprite *c in @[timebg,bonesbg,livesbg]) {
		[c setOpacity:200];
	}
    
    pause_time_disp = [Common cons_label_pos:[Common screen_pctwid:0.75 pcthei:0.6]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0:00"];
    [pause_ui addChild:pause_time_disp];
    
    pause_bones_disp= [Common cons_label_pos:[Common screen_pctwid:0.75 pcthei:0.45]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0"];
    [pause_ui addChild:pause_bones_disp];
    
    pause_lives_disp= [Common cons_label_pos:[Common screen_pctwid:0.75 pcthei:0.3]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0"];
    [pause_ui addChild:pause_lives_disp];
    
    CCMenuItem *retrybutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"retrybutton" tar:self sel:@selector(retry)
                                                pos:[Common screen_pctwid:0.5 pcthei:0.6]];
    
    CCMenuItem *playbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"playbutton" tar:self sel:@selector(unpause)
                                               pos:[Common screen_pctwid:0.35 pcthei:0.6]];
    
    CCMenuItem *backbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"backbutton" tar:self sel:@selector(exit_to_menu)
                                               pos:[Common screen_pctwid:0.20 pcthei:0.6]];
    
    CCMenu *pausebuttons = [CCMenu menuWithItems:retrybutton,playbutton,backbutton, nil];
    [pausebuttons setPosition:ccp(0,0)];
    [pause_ui addChild:pausebuttons];
    
    challenge_disp = [Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.13]
                                                   color:ccc3(255,255,255)
                                                fontsize:23
                                                     str:@""];
    [pause_ui addChild:challenge_disp];
	
	
	CCSprite *equipeditemslot = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													   rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																					  idname:@"itemslotsmall"]]
								 pos:ccp(0,0)];
	TexRect *equipitemtr = [GameItemCommon texrect_from:[UserInventory get_current_gameitem]];
	item_icon = [[CCSprite spriteWithTexture:equipitemtr.tex rect:equipitemtr.rect]
							   pos:[Common pct_of_obj:equipeditemslot pctx:0.5 pcty:0.5]];
	[equipeditemslot addChild:item_icon];
	[equipeditemslot setPosition:[Common screen_pctwid:0.17 pcthei:0.345]];
	[equipeditemslot setOpacity:180];
	for (CCSprite *c in equipeditemslot.children) [c setOpacity:180];
	[pause_ui addChild:equipeditemslot];
	
	
	CCSprite *equipeditemdescbg = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
														  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS
																						 idname:@"pauseitemdescbg"]]
								 pos:[Common screen_pctwid:0.4 pcthei:0.345]];
	[equipeditemdescbg setOpacity:200];
	[equipeditemdescbg addChild:[Common cons_label_pos:[Common pct_of_obj:equipeditemdescbg pctx:0.5 pcty:0.86]
												 color:ccc3(255,255,255)
											  fontsize:15
												   str:@"Equipped item:"]];
	item_desc_name = [Common cons_label_pos:[Common pct_of_obj:equipeditemdescbg pctx:0.5 pcty:0.55]
												 color:ccc3(255,255,255)
											  fontsize:25
												   str:[GameItemCommon name_from:[UserInventory get_current_gameitem]]];
	[equipeditemdescbg addChild:item_desc_name];
	
	[equipeditemdescbg addChild:[Common cons_label_pos:[Common pct_of_obj:equipeditemdescbg pctx:0.5 pcty:0.2]
												 color:ccc3(255,255,255)
											  fontsize:10
												   str:@"Upgrade at the store!"]];
	
	[pause_ui addChild:equipeditemdescbg];
    
    [self addChild:pause_ui z:1];
    
    return self;
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
    [(UILayer*)[self parent] retry];
}

-(void)unpause {
    [(UILayer*)[self parent] unpause];
}

-(void)exit_to_menu {
    [(UILayer*)[self parent] exit_to_menu];
}

-(void)update_item_slot {
	TexRect *tr = [GameItemCommon texrect_from:[UserInventory get_current_gameitem]];
	item_icon.texture = tr.tex;
	item_icon.textureRect = tr.rect;
	[item_desc_name setString:[GameItemCommon name_from:[UserInventory get_current_gameitem]]];
}

@end
