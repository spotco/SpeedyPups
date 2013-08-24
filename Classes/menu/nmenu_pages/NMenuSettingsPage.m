#import "NMenuSettingsPage.h"
#import "MenuCommon.h"
#import "GameMain.h"

@implementation NMenuSettingsPage

+(NMenuSettingsPage*)cons {
    return [NMenuSettingsPage node];
}

-(id)init {
    self = [super init];
    
    [GEventDispatcher add_listener:self];
    [self addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.85] color:ccc3(0,0,0) fontsize:25 str:@"FreeRun Start"]];
	[self addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.78] color:ccc3(0,0,0) fontsize:14 str:@"Play to unlock!"]];

	ClippingNode *clipper = [ClippingNode node];
	[clipper setClippingRegion:CGRectMake(
		[Common SCREEN].width*0.2,
		[Common SCREEN].height*0.44,
		[Common SCREEN].width * 0.6,
		[Common SCREEN].height * 0.3
	)];
	[self addChild:clipper];
	
	clipper_anchor = [CCSprite node];
	CCSprite *zero_anchor = [[CCSprite node] pos:ccp([Common SCREEN].width*0.175,[Common SCREEN].height*0.44)];
	[zero_anchor addChild:clipper_anchor];
	[clipper addChild:zero_anchor];
	
	
	NSArray *labels = @[	 @"tutorial",	  @"world 1",	 @"lab 1",	   @"world 2",	 @"lab 2",	  @"world 3",	@"lab 3"];
	NSArray *icons =  @[@"icon_tutorial", @"icon_world1", @"icon_lab", @"icon_world1",@"icon_lab",@"icon_world1",@"icon_lab"];
	for(int i = 0; i < labels.count; i++) {
		CCSprite *icon = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
												rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:icons[i]]]
						  pos:ccp(50+i*90,30)];
		[clipper_anchor addChild:icon];
		[clipper_anchor addChild:[Common cons_label_pos:ccp(50+i*90,7.5)
												  color:ccc3(0,0,0)
											   fontsize:13
													str:labels[i]]];
		[clipper_anchor addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
														rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"location_spacer"]]
								  pos:ccp(50+i*90+45,30)]];
	}
	
	selector_icon = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
											rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"dog_selector"]]
					pos:ccp(50,60)];
	[clipper_anchor addChild:selector_icon];
	
	scroll_right_arrow = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
												rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"settingspage_scrollright"]]
						  pos:[Common screen_pctwid:0.82 pcthei:0.615]];
	[self addChild:scroll_right_arrow];
	
	scroll_left_arrow = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
												 rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"settingspage_scrollright"]]
						  pos:[Common screen_pctwid:0.18 pcthei:0.615]];
	[scroll_left_arrow setScaleX:-1];
	[self addChild:scroll_left_arrow];
	
    [self addChild:[MenuCommon cons_common_nav_menu]];
    return self;
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_INVENTORY) {
    } else if (e.type == GEVentType_MENU_CLOSE_INVENTORY) {
    }
}



@end

