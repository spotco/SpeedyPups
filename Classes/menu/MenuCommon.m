#import "MenuCommon.h"
#import "GEventDispatcher.h"
#import "MainMenuLayer.h"

@implementation MenuCommon

+(CCAction*)cons_run_anim:(NSString*)tar {
    CCTexture2D *texture = [Resource get_tex:tar];
    NSMutableArray *animFrames = [NSMutableArray array];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_0"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_1"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_2"]]];
    [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:tar idname:@"run_3"]]];
    return [Common make_anim_frames:animFrames speed:float_random(0.1, 0.3)];
}

+(CCSprite*)menu_item:(NSString*)tex id:(NSString*)tid pos:(CGPoint)pos {
    CCSprite *s = [CCSprite spriteWithTexture:[Resource get_tex:tex] rect:[FileCache get_cgrect_from_plist:tex idname:tid]];
    [s setPosition:pos];
    return s;
}

+(CCMenu*)cons_common_nav_menu {
    CCMenuItem *shopbutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                              rect:@"nmenu_shopbutton"
                                               tar:self sel:@selector(goto_shop)
                                               pos:[Common screen_pctwid:0.05 pcthei:0.08]];
    
    CCMenuItem *charselbutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                                 rect:@"nmenu_blankbutton"
                                                  tar:self sel:@selector(goto_charsel)
                                                  pos:[Common screen_pctwid:0.15 pcthei:0.08]];
    
    CCMenuItem *settingsbutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                                  rect:@"nmenu_settingsbutton"
                                                   tar:self sel:@selector(goto_settings)
                                                   pos:[Common screen_pctwid:0.95 pcthei:0.08]];
    
    CCMenuItem *homebutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                                  rect:@"nmenu_backbutton"
                                                   tar:self sel:@selector(goto_home)
                                                   pos:[Common screen_pctwid:0.85 pcthei:0.08]];
    
    CCMenu* m = [CCMenu menuWithItems:shopbutton,charselbutton,settingsbutton,homebutton, nil];
    [m setPosition:ccp(0,0)];
    return m;
}

+(CCMenuItem*)item_from:(NSString*)tex rect:(NSString*)rect tar:(id)tar sel:(SEL)sel pos:(CGPoint)pos {
    CCSprite* p_a = [CCSprite spriteWithTexture:[Resource get_tex:tex]
                                           rect:[FileCache get_cgrect_from_plist:tex idname:rect]];
    
    CCSprite *p_b = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
                                           rect:[FileCache get_cgrect_from_plist:tex idname:rect]];
    [Common set_zoom_pos_align:p_a zoomed:p_b scale:1.2];
    
    CCMenuItemSprite *p = [CCMenuItemSprite itemFromNormalSprite:p_a
                                                  selectedSprite:p_b
                                                          target:tar
                                                        selector:sel];
    [p setPosition:pos];
    
    return p;
}

+(void)goto_shop {
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_GOTO_PAGE] add_i1:MENU_SHOP_PAGE i2:0]];
}

+(void)goto_charsel {
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_GOTO_PAGE] add_i1:MENU_DOG_MODE_PAGE_ID i2:0]];
}

+(void)goto_home {
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_GOTO_PAGE] add_i1:MENU_STARTING_PAGE_ID i2:0]];
}

+(void)goto_settings {
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_GOTO_PAGE] add_i1:MENU_SETTINGS_PAGE_ID i2:0]];
}

@end
