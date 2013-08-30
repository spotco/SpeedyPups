#import "NMenuSettingsPage.h"
#import "MenuCommon.h"
#import "GameMain.h"
#import "FreeRunStartAtManager.h"

@interface MapIconTouchButton : TouchButton {
	CGRect clipping_area;
	CCLabelTTF *disp_text;
}
@property (readwrite,assign) FreeRunStartAt starting_loc;
+(MapIconTouchButton*)cons_loc:(FreeRunStartAt)loc pos:(CGPoint)pos clip:(CGRect)clip cb:(CallBack*)tcb;
-(void)update;
@end

@implementation MapIconTouchButton
@synthesize starting_loc;
+(MapIconTouchButton*)cons_loc:(FreeRunStartAt)loc pos:(CGPoint)pos clip:(CGRect)clip cb:(CallBack *)tcb {
	return [[MapIconTouchButton node] cons_loc:loc pos:pos clip:clip cb:tcb];
}

-(id)cons_loc:(FreeRunStartAt)loc pos:(CGPoint)pos clip:(CGRect)clip cb:(CallBack*)tcb {
	[self setPosition:pos];
	starting_loc = loc;
	clipping_area = clip;
	self.cb = tcb;
	
	disp_text = [Common cons_label_pos:ccp([FreeRunStartAtManager get_icon_for_loc:loc].rect.size.width/2.0,-7)
								 color:ccc3(0,0,0)
							  fontsize:13
								   str:[FreeRunStartAtManager name_for_loc:loc]];
	[self addChild:disp_text];
	[self set_icon_and_text];
	
	return self;
}

-(void)set_icon_and_text {
	TexRect *tr = [FreeRunStartAtManager get_icon_for_loc:starting_loc];
	[self setTexture:tr.tex];
	if ([FreeRunStartAtManager get_can_start_at:starting_loc]) {
		[self setTextureRect:tr.rect];
		[disp_text setColor:ccc3(0,0,0)];
		[disp_text setString:[FreeRunStartAtManager name_for_loc:starting_loc]];
		
	} else {
		[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_FREERUNSTARTICONS idname:@"icon_question"]];
		[disp_text setColor:ccc3(80,80,80)];
		[disp_text setString:@"Locked"];
		
	}
}

-(void)update {
	[self setScale:(1-self.scale)/5.0+self.scale];
}

-(void)touch_begin:(CGPoint)pt {
	if (![FreeRunStartAtManager get_can_start_at:starting_loc]) return;
	CGPoint scrn_pt = pt;
	pt = [self convertToNodeSpace:pt];
	CGRect hitrect = [self hit_rect_local];
	if (CGRectContainsPoint(hitrect, pt)) {
		if (!CGRectContainsPoint(clipping_area, scrn_pt)) {
			return;
		}
		[self setScale:1.4];
		[self.cb.target performSelector:self.cb.selector withObject:self];
	}
}

-(CGRect)hit_rect_local {
	CGRect hr = [super hit_rect_local];
	hr.origin.x -= 10;
	hr.origin.y -= 10;
	hr.size.width += 20;
	hr.size.height += 20;
	return hr;
}

@end

@implementation NMenuSettingsPage

+(NMenuSettingsPage*)cons {
    return [NMenuSettingsPage node];
}

-(id)init {
    self = [super init];
	
	touches = [NSMutableArray array];
    
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
	
	FreeRunStartAt loc[] = {FreeRunStartAt_TUTORIAL,FreeRunStartAt_WORLD1,FreeRunStartAt_LAB1,FreeRunStartAt_WORLD2,FreeRunStartAt_LAB2,FreeRunStartAt_WORLD3,FreeRunStartAt_LAB3};
	CGPoint selector_icon_position = ccp(50,70);
	for(int i = 0; i < 7; i++) {
		MapIconTouchButton *b = [MapIconTouchButton cons_loc:loc[i]
														 pos:ccp(50+i*90,40)
														clip:clipper.clippingRegion
														  cb:[Common cons_callback:self sel:@selector(mapicontouch:)]];
		[clipper_anchor addChild:b];
		[touches addObject:b];
		[clipper_anchor addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
														 rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"location_spacer"]]
								  pos:ccp(50+i*90+45,40)]];
		clippedholder_x_min = -(50+i*90) + [Common SCREEN].width * 0.6 - 55;
		
		if (loc[i] == [FreeRunStartAtManager get_starting_loc]) {
			selector_icon_position.x = b.position.x;
		}
	}
	
	selector_icon = [CCSprite node];
	[selector_icon runAction:[Common cons_anim:@[@"dog_selector_0",@"dog_selector_1"] speed:0.2 tex_key:TEX_NMENU_ITEMS]];
	[selector_icon setScale:0.6];
	[selector_icon setAnchorPoint:ccp(0.44,0.5)];
	[selector_icon setPosition:selector_icon_position];
	selector_icon_target_pos = selector_icon.position;
	[clipper_anchor addChild:selector_icon];
	
	scroll_right_arrow = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
												rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"settingspage_scrollright"]]
						  pos:[Common screen_pctwid:0.83 pcthei:0.615]];
	[self addChild:scroll_right_arrow];
	
	scroll_left_arrow = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
												 rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"settingspage_scrollright"]]
						  pos:[Common screen_pctwid:0.17 pcthei:0.615]];
	[scroll_left_arrow setScaleX:-1];
	[self addChild:scroll_left_arrow];
	
    [self addChild:[MenuCommon cons_common_nav_menu]];
	
	clippedholder_x_max = 0;
	
    return self;
}

-(void)mapicontouch:(MapIconTouchButton*)button {
	if ([FreeRunStartAtManager get_can_start_at:button.starting_loc]) {
		[FreeRunStartAtManager set_starting_loc:button.starting_loc];
		selector_icon_target_pos = button.position;
		
	} else {
		NSLog(@"mapicontouch ERROR");
	}
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_INVENTORY) {
    } else if (e.type == GEVentType_MENU_CLOSE_INVENTORY) {
    } else if (e.type == GEventType_MENU_TICK && self.visible) {
		[self update];
	}
}

-(void)setVisible:(BOOL)visible {
	if (visible) {
		for (MapIconTouchButton *b in touches) {
			[b set_icon_and_text];
		}
	}
	[super setVisible:visible];
}

-(void)update {
	if (!visible_) return;
	CGPoint neupos = CGPointAdd(ccp(vx,0), clipper_anchor.position);
	neupos.x = clampf(neupos.x, clippedholder_x_min, clippedholder_x_max);
	[clipper_anchor setPosition:neupos];
	vx *= 0.8;
	[scroll_right_arrow setVisible:neupos.x != clippedholder_x_min];
	[scroll_left_arrow setVisible:neupos.x != clippedholder_x_max];
	
	selector_icon.position = ccp((selector_icon_target_pos.x-selector_icon.position.x)/5.0+selector_icon.position.x,selector_icon.position.y);
	
	for (MapIconTouchButton *btn in touches) {
		[btn update];
	}
}

-(void)touch_begin:(CGPoint)pt {
	for (int i = touches.count-1; i>=0; i--) {
		TouchButton *b = touches[i];
		[b touch_begin:pt];
	}
	
	is_scroll = YES;
	last_scroll_pt = pt;
	scroll_move_ct = 0;
}

-(void)touch_move:(CGPoint)pt {
	if (!visible_) return;
	if (!is_scroll) return;
	CGPoint ydelta = ccp(-last_scroll_pt.x+pt.x,0);
	last_scroll_pt = pt;
	
	float sign = [Common sig:ydelta.x];
	float av = 15.0*MIN(ABS(ydelta.x),30)/30.0;
	av /= MAX(1,8.0-scroll_move_ct);
	vx += sign * av;
	scroll_move_ct++;
}

-(void)touch_end:(CGPoint)pt {
	if (!visible_) return;
	is_scroll = NO;
}



@end

