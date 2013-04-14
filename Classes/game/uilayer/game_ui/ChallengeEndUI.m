#import "ChallengeEndUI.h"
#import "cocos2d.h" 
#import "Resource.h"
#import "FileCache.h" 
#import "MenuCommon.h"
#import "UILayer.h"

@implementation ChallengeEndUI

+(ChallengeEndUI*)cons {
    return [ChallengeEndUI node];
}

-(id)init {
    self = [super init];
    
    ccColor4B c = {50,50,50,220};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    CCNode *complete_ui = [CCLayerColor layerWithColor:c width:s.height height:s.width];
    complete_ui.anchorPoint = ccp(0,0);
    [complete_ui setPosition:ccp(0,0)];
    
    wlicon = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                     rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"challengecomplete"]]
              pos:[Common screen_pctwid:0.5 pcthei:0.8]];
    [complete_ui addChild:wlicon];
    
    CCSprite *infopane = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
                                                 rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"challengeinfo"]]
                          pos:[Common screen_pctwid:0.5 pcthei:0.4]];
    
    CCLabelTTF *l = [Common cons_label_pos:ccp(220,82) color:ccc3(0,0,0) fontsize:15 str:@"Collected"];
    [l setAnchorPoint:ccp(1,0.5)];
    [infopane addChild:l];
    
    bone_disp = [Common cons_label_pos:ccp(245,85) color:ccc3(220,10,10) fontsize:15 str:@"0"];
    [bone_disp setAnchorPoint:ccp(0,0.5)];
    [infopane addChild:bone_disp];
    
    l = [Common cons_label_pos:ccp(220,58) color:ccc3(0,0,0) fontsize:15 str:@"Time"];
    [l setAnchorPoint:ccp(1,0.5)];
    [infopane addChild:l];
    
    time_disp = [Common cons_label_pos:ccp(230,60) color:ccc3(220,10,10) fontsize:15 str:@"0:00"];
    [time_disp setAnchorPoint:ccp(0,0.5)];
    [infopane addChild:time_disp];
    
    l = [Common cons_label_pos:ccp(220,37) color:ccc3(0,0,0) fontsize:15 str:@"Secrets"];
    [l setAnchorPoint:ccp(1,0.5)];
    [infopane addChild:l];
    
    secrets_disp = [Common cons_label_pos:ccp(230,37) color:ccc3(220,10,10) fontsize:15 str:@"0"];
    [secrets_disp setAnchorPoint:ccp(0,0.5)];
    [infopane addChild:secrets_disp];
    
    NSString* maxstr = @"aaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
                               lineBreakMode:UILineBreakModeWordWrap];
    
    infodesc = [CCLabelTTF labelWithString:@"Some challenge eh"
                                dimensions:actualSize
                                 alignment:UITextAlignmentLeft
                                  fontName:@"Carton Six"
                                  fontSize:13];
    [infodesc setColor:ccc3(40,40,40)];
    [infodesc setAnchorPoint:ccp(0,0.5)];
    [infodesc setPosition:ccp(10,67.5)];
    [infopane addChild:infodesc];
    
    
    CCMenuItem *backbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"backbutton" tar:self sel:@selector(exit_to_menu)
                                               pos:[Common screen_pctwid:0.3 pcthei:0.1]];
    
    CCMenuItem *retrybutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"retrybutton" tar:self sel:@selector(retry)
                                                pos:[Common screen_pctwid:0.7 pcthei:0.1]];
    
    CCMenu *m = [CCMenu menuWithItems:backbutton,retrybutton, nil];
    [m setPosition:CGPointZero];
    [complete_ui addChild:m];
    
    [complete_ui addChild:infopane];
    [self addChild:complete_ui];
    
    return self;
}

-(void)update_passed:(BOOL)p info:(ChallengeInfo*)ci bones:(NSString*)bones time:(NSString*)time secrets:(NSString*)secrets {
    [wlicon setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:p?@"challengecomplete":@"challengefailed"]];
    [infodesc setString:[ci to_string]];
    [bone_disp setString:bones];
    [time_disp setString:time];
    [secrets_disp setString:secrets];
}

-(void)retry {
    [(UILayer*)[self parent] retry];
}

-(void)exit_to_menu {
    [(UILayer*)[self parent] exit_to_menu];
}

@end
