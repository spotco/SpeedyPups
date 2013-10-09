#import "MenuCommon.h"
#import "GEventDispatcher.h"
#import "MainMenuLayer.h"
#import "CharSelAnim.h"


@implementation TouchButton
@synthesize cb;
+(TouchButton*)cons_pt:(CGPoint)pt tex:(CCTexture2D *)tex texrect:(CGRect)texrect cb:(CallBack *)tcb {
	return [[TouchButton node] cons_pt:pt tex:tex texrect:texrect cb:tcb];
}

-(id)cons_pt:(CGPoint)pt tex:(CCTexture2D *)tex texrect:(CGRect)texrect cb:(CallBack *)tcb {
	[self setPosition:pt];
	[self setTexture:tex];
	[self setTextureRect:texrect];
	cb = tcb;
	
	
	return self;
}

-(void)touch_begin:(CGPoint)pt {
	pt = [self convertToNodeSpace:pt];
	CGRect hitrect = [self hit_rect_local];
	if (CGRectContainsPoint(hitrect, pt)) {
		[self on_touch];
	}
}

-(void)on_touch {
	[Common run_callback:cb];
}

-(void)touch_move:(CGPoint)pt{}
-(void)touch_end:(CGPoint)pt{}

-(CGRect)hit_rect_local {
	if (!self.visible) return CGRectZero;
	CGRect hitrect = [self boundingBox];
	hitrect.origin = CGPointZero;
	return hitrect;
}
@end

@implementation HoldTouchButton

+(HoldTouchButton*)cons_pt:(CGPoint)pt tex:(CCTexture2D *)tex texrect:(CGRect)texrect {
	return [[HoldTouchButton node] cons_pt:pt tex:tex texrect:texrect];
}

-(id)cons_pt:(CGPoint)pt tex:(CCTexture2D *)tex texrect:(CGRect)texrect {
	[self setPosition:pt];
	[self setTexture:tex];
	[self setTextureRect:texrect];
	self.cb = NULL;
	self.pressed = NO;
	zoom_scale = 1;
	default_scale_x = 1;
	default_scale_y = 1;
	return self;
}

-(void)touch_begin:(CGPoint)pt {
	pt = [self convertToNodeSpace:pt];
	CGRect hitrect = [self hit_rect_local];
	if (CGRectContainsPoint(hitrect, pt)) {
		self.pressed = YES;
		[self set_zoom_scale:1.5];
	} else {
		self.pressed = NO;
	}
}
-(void)touch_move:(CGPoint)pt{
	pt = [self convertToNodeSpace:pt];
	CGRect hitrect = [self hit_rect_local];
	if (!CGRectContainsPoint(hitrect, pt)) {
		self.pressed = NO;
	}
}
-(void)touch_end:(CGPoint)pt{
	self.pressed  = NO;
}

-(void)update {
	if (!self.pressed) {
		[self set_zoom_scale:[self zoom_scale] + (1 - [self zoom_scale])/4.0];
	}
}

-(void)set_zoom_scale:(float)sc {
	zoom_scale = sc;
	[super setScaleX:default_scale_x * zoom_scale];
	[super setScaleY:default_scale_y * zoom_scale];
}

-(float)zoom_scale {
	return zoom_scale;
}

-(void)setScaleX:(float)scaleX {
	default_scale_x = scaleX;
	[super setScaleX:default_scale_x * zoom_scale];
}

-(void)setScaleY:(float)scaleY {
	default_scale_y = scaleY;
	[super setScaleY:default_scale_y * zoom_scale];
}

@end

@implementation AnimatedTouchButton

+(AnimatedTouchButton*)cons_pt:(CGPoint)pt tex:(CCTexture2D *)tex texrect:(CGRect)texrect cb:(CallBack *)tcb {
	return [[AnimatedTouchButton node] cons_pt:pt tex:tex texrect:texrect cb:tcb];
}

-(id)cons_pt:(CGPoint)pt tex:(CCTexture2D *)tex texrect:(CGRect)texrect cb:(CallBack *)tcb {
	[super cons_pt:pt tex:tex texrect:texrect cb:tcb];
	target_scale = 1;
	return self;
}


-(void)update {
	[self setScale:(target_scale-self.scale)/3.0+self.scale];
}

-(void)on_touch {
	started_on = YES;
	target_scale = 1.2;
}

-(void)touch_end:(CGPoint)pt {
	pt = [self convertToNodeSpace:pt];
	CGRect hitrect = [self hit_rect_local];
	if (started_on && CGRectContainsPoint(hitrect, pt)) {
		[super on_touch];
		[self setScale:1.2];
	}
	started_on = NO;
	target_scale = 1;
}

-(CGRect)hit_rect_local {
	float sto_sc = [self scale];
	[self setScale:1];
	CGRect hitrect = [self boundingBox];
	hitrect.origin = CGPointZero;
	[self setScale:sto_sc];
	return hitrect;
}

@end

@implementation LabelGroup
-(id)init {
	self = [super init];
	labels = [NSMutableArray array];
	return self;
}

-(LabelGroup*)add_label:(CCLabelTTF *)l {
	[labels addObject:l];
	return self;
}

-(void)set_string:(NSString *)string {
	for (CCLabelTTF* l in labels) {
		[l setString:string];
	}
}
@end

@implementation SpriteGroup

-(id)init {
	self = [super init];
	sprites = [NSMutableArray array];
	return self;
}

-(SpriteGroup*)add_sprite:(CCSprite *)spr {
	[sprites addObject:spr];
	return self;
}

-(void)set_texture:(CCTexture2D *)tex {
	for (CCSprite *s in sprites) {
		[s setTexture:tex];
	}
}

-(void)set_texturerect:(CGRect)rect {
	for (CCSprite *s in sprites) {
		[s setTextureRect:rect];
	}
}

@end


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
	[self close_inventory];
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_MENU_INVENTORY]];
}

+(void)goto_shop {
	[self close_inventory];
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_GOTO_PAGE] add_i1:MENU_SHOP_PAGE i2:0]];
	[AudioManager playsfx:SFX_MENU_UP];
}

+(void)goto_charsel {
	[self close_inventory];
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_GOTO_PAGE] add_i1:MENU_DOG_MODE_PAGE_ID i2:0]];
	[AudioManager playsfx:SFX_MENU_UP];
}

+(void)goto_home {
	[self close_inventory];
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_GOTO_PAGE] add_i1:MENU_STARTING_PAGE_ID i2:0]];
	[AudioManager playsfx:SFX_MENU_UP];
}

+(void)goto_settings {
	[self close_inventory];
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_MENU_GOTO_PAGE] add_i1:MENU_SETTINGS_PAGE_ID i2:0]];
	[AudioManager playsfx:SFX_MENU_UP];
}

+(void)close_inventory {
    [GEventDispatcher push_event:[GEvent cons_type:GEVentType_MENU_CLOSE_INVENTORY]];
}

@end
