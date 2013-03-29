#import "NMenuSettingsPage.h"
#import "MenuCommon.h"

@implementation NMenuSettingsPage

+(NMenuSettingsPage*)cons {
    return [NMenuSettingsPage node];
}

-(id)init {
    self = [super init];
    
    /*
    CCMenuItem *tab1 = [NMenuSettingsPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_signtab"
                                                       tar:self sel:@selector(tab1)
                                                       pos:[Common screen_pctwid:0.3 pcthei:0.275]
                                                      text:@"Tab1" textpos:ccp(35,15)];
    
    CCMenuItem *tab2 = [NMenuSettingsPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_signtab"
                                                       tar:self sel:@selector(tab1)
                                                       pos:[Common screen_pctwid:0.5 pcthei:0.275]
                                                      text:@"Tab2" textpos:ccp(35,15)];
    
    CCMenuItem *tab3 = [NMenuSettingsPage labeleditem_from:TEX_NMENU_ITEMS
                                                      rect:@"nmenu_signtab"
                                                       tar:self sel:@selector(tab1)
                                                       pos:[Common screen_pctwid:0.7 pcthei:0.275]
                                                      text:@"Tab3" textpos:ccp(35,15)];
    
    CCMenu *m = [CCMenu menuWithItems:tab1,tab2,tab3, nil];
    [m setPosition:ccp(0,0)];
    [self addChild:m];
    */
     
    [self addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.85] color:ccc3(0, 0, 0) fontsize:25 str:@"Settings"]];
    
    [self addChild:[MenuCommon cons_common_nav_menu]];
    return self;
}

+(CCMenuItem*)labeleditem_from:(NSString*)tex rect:(NSString*)rect tar:(id)tar sel:(SEL)sel pos:(CGPoint)pos text:(NSString*)text textpos:(CGPoint)tpos{
    CCSprite* p_a = [CCSprite spriteWithTexture:[Resource get_tex:tex]
                                           rect:[FileCache get_cgrect_from_plist:tex idname:rect]];
    [p_a addChild:[Common cons_label_pos:tpos color:ccc3(0, 0, 0) fontsize:15 str:text]];
    
    CCSprite *p_b = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
                                           rect:[FileCache get_cgrect_from_plist:tex idname:rect]];
    [p_b addChild:[Common cons_label_pos:tpos color:ccc3(0, 0, 0) fontsize:15 str:text]];
    
    [Common set_zoom_pos_align:p_a zoomed:p_b scale:1.2];
    
    CCMenuItemSprite *p = [CCMenuItemSprite itemFromNormalSprite:p_a
                                                  selectedSprite:p_b
                                                          target:tar
                                                        selector:sel];
    [p setPosition:pos];
    
    return p;
}

-(void)tab1 {
    NSLog(@"test");
}



@end

