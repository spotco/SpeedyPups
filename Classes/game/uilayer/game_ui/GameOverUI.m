#import "GameOverUI.h"
#import "PauseUI.h"
#import "Common.h"
#import "Resource.h"
#import "MenuCommon.h"
#import "UserInventory.h"
#import "GameEngineLayer.h"
#import "UICommon.h"
#import "UILayer.h"

@implementation GameOverUI

+(GameOverUI*)cons {
    return [GameOverUI node];
}

-(id)init {
    self = [super init];
    
    ccColor4B c = {50,50,50,220};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    CCNode *gameover_ui = [CCLayerColor layerWithColor:c width:s.height height:s.width];
    gameover_ui.anchorPoint = ccp(0,0);
    [gameover_ui setPosition:ccp(0,0)];
    
    [gameover_ui addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                                  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"gameover"]]
                            pos:[Common screen_pctwid:0.5 pcthei:0.8]]];
    
    CCSprite *infopane = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                                rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"gameinfopane"]]
                          pos:[Common screen_pctwid:0.5 pcthei:0.4]];
    
    CCLabelTTF *l = [Common cons_label_pos:ccp(108,76) color:ccc3(0,0,0) fontsize:25 str:@"Collected"];
    [l setAnchorPoint:ccp(1,0.5)];
    [infopane addChild:l];
    l = [Common cons_label_pos:ccp(108,41) color:ccc3(0,0,0) fontsize:25 str:@"Time"];
    [l setAnchorPoint:ccp(1,0.5)];
    [infopane addChild:l];
    
    bone_disp = [Common cons_label_pos:ccp(135,76) color:ccc3(220,10,10) fontsize:25 str:@"0"];
    [bone_disp setAnchorPoint:ccp(0,0.5)];
    [infopane addChild:bone_disp];
    
    time_disp = [Common cons_label_pos:ccp(115,41) color:ccc3(220,10,10) fontsize:25 str:@"0:00"];
    [time_disp setAnchorPoint:ccp(0,0.5)];
    [infopane addChild:time_disp];
    
    CCMenuItem *backbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"backbutton" tar:self sel:@selector(exit_to_menu)
                                               pos:[Common screen_pctwid:0.3 pcthei:0.1]];
    
    CCMenuItem *retrybutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"retrybutton" tar:self sel:@selector(retry)
                                               pos:[Common screen_pctwid:0.7 pcthei:0.1]];
    
    CCMenu *m = [CCMenu menuWithItems:backbutton,retrybutton, nil];
    [m setPosition:CGPointZero];
    [gameover_ui addChild:m];
    
    [infopane addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_TUTORIAL_ANIM_1]
                                                  rect:[FileCache get_cgrect_from_plist:TEX_TUTORIAL_ANIM_1 idname:@"spikehit6"]]
                           pos:ccp(210,65)]];
    
    [gameover_ui addChild:infopane];
    
    [self addChild:gameover_ui];
    
    return self;
}

-(void)set_bones:(NSString*)bones time:(NSString*)time {
    [bone_disp setString:bones];
    [time_disp setString:time];
}

-(void)retry {
    [(UILayer*)[self parent] retry];
}

-(void)exit_to_menu {
    [(UILayer*)[self parent] exit_to_menu];
}

-(void)setVisible:(BOOL)visible {
	[super setVisible:visible];
	if (visible) {
		[AudioManager playbgm_imm:BGM_GROUP_JINGLE];
	}
}

@end
