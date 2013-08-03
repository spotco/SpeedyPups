#import "MenuCommon.h"
#import "GEventDispatcher.h"
#import "MainMenuLayer.h"
#import "CharSelAnim.h"

@implementation MenuCommon

+(CCSprite*)menu_item:(NSString*)tex id:(NSString*)tid pos:(CGPoint)pos {
    CCSprite *s = [CCSprite spriteWithTexture:[Resource get_tex:tex] rect:[FileCache get_cgrect_from_plist:tex idname:tid]];
    [s setPosition:pos];
    return s;
}

#define t_CHARSELBUTTON 3

+(CCMenu*)cons_common_nav_menu {
    CCMenuItem *shopbutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                              rect:@"nmenu_shopbutton"
                                               tar:self sel:@selector(goto_shop)
                                               pos:[Common screen_pctwid:0.05 pcthei:0.09]];
    
    CCMenuItem *charselbutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                                 rect:@"nmenu_blankbutton"
                                                  tar:self sel:@selector(goto_charsel)
                                                  pos:[Common screen_pctwid:0.175 pcthei:0.09]];
    
    
    
    CCMenuItem *settingsbutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                                  rect:@"nmenu_settingsbutton"
                                                   tar:self sel:@selector(goto_settings)
                                                   pos:[Common screen_pctwid:0.95 pcthei:0.09]];
    
    CCMenuItem *homebutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                                  rect:@"nmenu_homebutton"
                                                   tar:self sel:@selector(goto_home)
                                                   pos:[Common screen_pctwid:0.5 pcthei:0.09]];
    
    CCMenuItem *invbutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                              rect:@"nmenu_inventorybutton"
                                               tar:self sel:@selector(inventory)
                                               pos:[Common screen_pctwid:0.825 pcthei:0.09]];
    
    CCMenu* m = [CCMenu menuWithItems:invbutton,shopbutton,settingsbutton,homebutton, nil];
    [m addChild:charselbutton z:0 tag:t_CHARSELBUTTON];
	[m setPosition:ccp(0,0)];
    return m;
}

+(CCMenuItem*)nav_menu_get_charselbutton:(CCMenu*)menu {
	return (CCMenuItem*)[menu getChildByTag:t_CHARSELBUTTON];
}

+(CCMenuItem*)item_from:(NSString*)tex rect:(NSString*)rect tar:(id)tar sel:(SEL)sel pos:(CGPoint)pos {
    CCSprite* p_a = [CCSprite spriteWithTexture:[Resource get_tex:tex]
                                           rect:[FileCache get_cgrect_from_plist:tex idname:rect]];
    
    CCSprite *p_b = [CCSprite spriteWithTexture:[Resource get_tex:tex]
                                           rect:[FileCache get_cgrect_from_plist:tex idname:rect]];
    
    
    if ([rect isEqualToString:@"nmenu_blankbutton"]) {
        [p_a addChild:[CharSelAnim cons_pos:ccp(18,20)]];
        [p_b addChild:[CharSelAnim cons_pos:ccp(18,20)]];
    }
    
    [Common set_zoom_pos_align:p_a zoomed:p_b scale:1.2];
    
    CCMenuItemSprite *p = [CCMenuItemSprite itemFromNormalSprite:p_a
                                                  selectedSprite:p_b
                                                          target:tar
                                                        selector:sel];
    [p setPosition:pos];
    
    return p;
}

+(void)inventory {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_MENU_INVENTORY]];
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
