#import "NMenuShopPage.h"
#import "MenuCommon.h"
#import "Shopkeeper.h"

@implementation NMenuShopPage
+(NMenuShopPage*)cons {
    return [NMenuShopPage node];
}
-(id)init {
    self = [super init];
    
    [self addChild:[Shopkeeper cons_pt:[Common screen_pctwid:0.1 pcthei:0.45]]];
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_shopmenu" pos:[Common screen_pctwid:0.6 pcthei:0.65]]];
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_speechbub" pos:[Common screen_pctwid:0.425 pcthei:0.35]]];
    
    CCMenuItem *tab1 = [NMenuShopPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_shoptab"
                                                       tar:self sel:@selector(tab1)
                                                       pos:[Common screen_pctwid:0.35 pcthei:0.93]
                                                      text:@"Tab1" textpos:ccp(40,19)];
    
    
    CCMenuItem *tab2 = [NMenuShopPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_shoptab"
                                                       tar:self sel:@selector(tab1)
                                                       pos:[Common screen_pctwid:0.6 pcthei:0.93]
                                                      text:@"Tab2" textpos:ccp(40,19)];
    
    CCMenuItem *tab3 = [NMenuShopPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_shoptab"
                                                       tar:self sel:@selector(tab1)
                                                       pos:[Common screen_pctwid:0.85 pcthei:0.93]
                                                      text:@"Tab3" textpos:ccp(40,19)];
    
    CCMenuItem *buybutton = [NMenuShopPage labeleditem_from:TEX_NMENU_ITEMS
                                                  rect:@"nmenu_shoptab"
                                                   tar:self sel:@selector(tab1)
                                                   pos:[Common screen_pctwid:0.85 pcthei:0.30]
                                                  text:@"BUY" textpos:ccp(55,19)];
    
    CCMenu *m = [CCMenu menuWithItems:tab1,tab2,tab3,buybutton, nil];
    [m setPosition:ccp(0,0)];
    [self addChild:m];
    
    [self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_shopsign" pos:[Common screen_pctwid:0.1 pcthei:0.88]]];
    
    [self addChild:[MenuCommon cons_common_nav_menu]];
    return self;
}

+(CCMenuItem*)labeleditem_from:(NSString*)tex rect:(NSString*)rect tar:(id)tar sel:(SEL)sel pos:(CGPoint)pos text:(NSString*)text textpos:(CGPoint)tpos{
    CCSprite* p_a = [CCSprite spriteWithTexture:[Resource get_tex:tex]
                                           rect:[FileCache get_cgrect_from_plist:tex idname:rect]];
    [p_a addChild:[Common cons_label_pos:tpos color:ccc3(0, 0, 0) fontsize:20 str:text]];
    
    CCSprite *p_b = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
                                           rect:[FileCache get_cgrect_from_plist:tex idname:rect]];
    [p_b addChild:[Common cons_label_pos:tpos color:ccc3(0, 0, 0) fontsize:20 str:text]];
    
    [Common set_zoom_pos_align:p_a zoomed:p_b scale:1.2];
    
    CCMenuItemSprite *p = [CCMenuItemSprite itemFromNormalSprite:p_a
                                                  selectedSprite:p_b
                                                          target:tar
                                                        selector:sel];
    [p setPosition:pos];
    
    return p;
}

-(void)tab1 {
    NSLog(@"tab1");
}
@end
