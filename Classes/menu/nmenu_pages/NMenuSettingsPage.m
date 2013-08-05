#import "NMenuSettingsPage.h"
#import "MenuCommon.h"
#import "GameMain.h"

@implementation NMenuSettingsPage

+(NMenuSettingsPage*)cons {
    return [NMenuSettingsPage node];
}

-(id)init {
    self = [super init];
	
	do_tutorial = (CCMenuItemSprite*)[MenuCommon item_from:TEX_NMENU_ITEMS
													  rect:@"nmenu_checkbutton"
													   tar:self
													   sel:@selector(do_tutorial_button)
													   pos:[Common screen_pctwid:0.3 pcthei:0.6]];
	CCMenu *settings_btn_menu = [CCMenu menuWithItems:do_tutorial, nil];
	[settings_btn_menu setPosition:CGPointZero];
	[self addChild:settings_btn_menu];
	
	do_tutorial_label = [Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.6]
										 color:ccc3(0,0,0)
									  fontsize:18
										   str:@""];
	[self addChild:do_tutorial_label];
	[self update_tutorial_button];
    
    [GEventDispatcher add_listener:self];
     
    [self addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.85] color:ccc3(0, 0, 0) fontsize:25 str:@"Settings"]];
    
    [self addChild:[MenuCommon cons_common_nav_menu]];
    return self;
}

-(void)do_tutorial_button {
	[GameMain SET_DO_TUTORIAL:![GameMain GET_DO_TUTORIAL]];
	[self update_tutorial_button];
}

-(void)update_tutorial_button {
	CCSprite *normalimg = (CCSprite*)((CCMenuItemSprite*)do_tutorial).normalImage;
	CCSprite *selectedimg = (CCSprite*)((CCMenuItemSprite*)do_tutorial).selectedImage;
	
	if ([GameMain GET_DO_TUTORIAL]) {
		[do_tutorial_label setString:@"Tutorial On"];
		[normalimg setTextureRect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_checkbutton"]];
		[selectedimg setTextureRect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_checkbutton"]];
		
	} else {
		[do_tutorial_label setString:@"Tutorial Off"];
		[normalimg setTextureRect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_xbutton"]];
		[selectedimg setTextureRect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_xbutton"]];
		
	}
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_INVENTORY) {
        kill = YES;
        
    } else if (e.type == GEVentType_MENU_CLOSE_INVENTORY) {
        kill = NO;
        
    }
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

