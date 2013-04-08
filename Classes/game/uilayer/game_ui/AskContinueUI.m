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
    
    [self addChild:ask_continue_ui];
    
    return self;
}

-(void)continue_no {
    
}

-(void)continue_yes {
    
}

@end
