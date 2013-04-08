#import "AskContinueUI.h"
#import "PauseUI.h"
#import "Common.h"
#import "Resource.h"
#import "MenuCommon.h"
#import "UserInventory.h"
#import "GameEngineLayer.h"
#import "UICommon.h"
#import "UILayer.h"

@implementation AskContinueUI

+(AskContinueUI*)cons {
    return [AskContinueUI node];
}

-(id)init {
    self = [super init];
    
    ccColor4B c = {0,0,0,200};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    CCNode *ask_continue_ui = [CCLayerColor layerWithColor:c width:s.height height:s.width];
    
    [ask_continue_ui addChild:[[CCSprite spriteWithTexture:[Resource get_tex:[Player get_character]]
                                                      rect:[FileCache get_cgrect_from_plist:[Player get_character] idname:@"hit_3"]]
                               pos:[Common screen_pctwid:0.5 pcthei:0.4]]];
    
    [ask_continue_ui addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                                      rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"spotlight"]]
                               pos:[Common screen_pctwid:0.5 pcthei:0.6]]];
    
    [ask_continue_ui addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                                      rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"continue"]]
                               pos:[Common screen_pctwid:0.5 pcthei:0.8]]];
    
    CCMenuItem *yes = [MenuCommon item_from:TEX_UI_INGAMEUI_SS
                                       rect:@"yesbutton"
                                        tar:self sel:@selector(continue_yes)
                                        pos:[Common screen_pctwid:0.3 pcthei:0.4]];
    
    CCMenuItem *no = [MenuCommon item_from:TEX_UI_INGAMEUI_SS
                                      rect:@"nobutton"
                                       tar:self sel:@selector(continue_no)
                                       pos:[Common screen_pctwid:0.7 pcthei:0.4]];
    
    CCMenu *m = [CCMenu menuWithItems:yes,no, nil];
    [m setPosition:CGPointZero];
    [ask_continue_ui addChild:m];
    
    countdown_disp = [Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.575]
                                      color:ccc3(220, 10, 10) fontsize:50 str:@""];
    [ask_continue_ui addChild:countdown_disp];
    
    CCSprite *costpane = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                                 rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"costpane"]]
                          pos:[Common screen_pctwid:0.3 pcthei:0.25]];
    cost_disp = [Common cons_label_pos:ccp(23,-3) color:ccc3(220,10,10) fontsize:30 str:@""];
    [cost_disp setAnchorPoint:ccp(0,0)];
    [costpane addChild:cost_disp];
    [ask_continue_ui addChild:costpane];
    
    CCSprite *totalpane = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                                  rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"costpane"]]
                           pos:[Common screen_pctwid:0.925 pcthei:0.075]];
    total_disp = [Common cons_label_pos:ccp(23,-3) color:ccc3(220,10,10) fontsize:30 str:@""];
    [total_disp setAnchorPoint:ccp(0,0)];
    [totalpane addChild:total_disp];
    [ask_continue_ui addChild:totalpane];
    
    [ask_continue_ui addChild:[Common cons_label_pos:[Common screen_pctwid:0.75 pcthei:0.075] color:ccc3(255,255,255) fontsize:30 str:@"total:"]];
    
    [self addChild:ask_continue_ui];
    
    return self;
}

-(void)start_countdown:(int)cost {
    countdown_ct = 10;
    continue_cost = cost;
    [self schedule:@selector(update) interval:1];
    [countdown_disp setString:[NSString stringWithFormat:@"%d",countdown_ct]];
    [cost_disp setString:[NSString stringWithFormat:@"%d",cost]];
    [total_disp setString:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
}

-(void)update {
    if (countdown_ct < 0) {
        [self stop_countdown];
        [self to_gameover_screen];
        return;
    }
    [countdown_disp setString:[NSString stringWithFormat:@"%d",countdown_ct]];
    countdown_ct--;
}

-(void)stop_countdown {
    [self unschedule:@selector(update)];
}

-(void)continue_no {
    [self stop_countdown];
    [self to_gameover_screen];
}

-(void)continue_yes {
    if ([UserInventory get_current_bones] >= continue_cost) {
        [self stop_countdown];
        [UserInventory add_bones:-continue_cost];
        NSLog(@"to continue");
    }
}

-(void)to_gameover_screen {
    NSLog(@"to gameover");
}

@end
