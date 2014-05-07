#import "InventoryTabPane_Prizes.h"
#import "Common.h"
#import "MenuCommon.h"

@implementation InventoryTabPane_Prizes {
	NSMutableArray *touches;
	NSMutableArray *lights;
	CCSprite *wheel_pointer;
	float wheel_pointer_vr;
	TouchButton *spinbutton;
}

+(InventoryTabPane_Prizes*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Prizes node] cons:parent];
}

-(id)cons:(CCSprite*)parent {
	touches = [NSMutableArray array];
	
	[self addChild:[Common cons_label_pos:[Common pct_of_obj:parent pctx:0.2 pcty:0.85]
									color:ccc3(200,30,30)
								 fontsize:25
									  str:@"Wheel of Prizes!"]];
	
	CCSprite *wheel_bg = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
												 rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"menu_wheel_back"]]
						  pos:[Common pct_of_obj:parent pctx:0.65 pcty:0.5]];
	[self addChild:wheel_bg];
	
	wheel_pointer = [[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
										   rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"menu_wheel_point"]]
					anchor_pt:ccp(0.5,0.246)]
					pos:[Common pct_of_obj:wheel_bg pctx:0.5 pcty:0.5]];
	
	lights = [NSMutableArray array];
	for (float i = 0; i < 3.14 * 2; i += 3.14/6) {
		CCSprite *light = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
												 rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"menu_wheel_light_off"]];
		
		CGPoint tar_pos = ccp(0.5,0.5);
		Vec3D v = [VecLib scale:[VecLib cons_x:cosf(i+[Common deg_to_rad:15]) y:sinf(i+[Common deg_to_rad:15]) z:0] by:0.54];
		tar_pos.x += v.x;
		tar_pos.y += v.y;
		[light setPosition:[Common pct_of_obj:wheel_bg pctx:tar_pos.x pcty:tar_pos.y]];
		[wheel_bg addChild:light];
		[lights addObject:light];
	}
	[wheel_bg setScale:0.9];
	[wheel_bg addChild:wheel_pointer];
	
	
	
	spinbutton = [AnimatedTouchButton cons_pt:[Common pct_of_obj:parent pctx:0.16 pcty:0.25]
													  tex:[Resource get_tex:TEX_NMENU_ITEMS]
												  texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_shoptab"]
													   cb:[Common cons_callback:self sel:@selector(spin)]];
	[spinbutton addChild:[Common cons_label_pos:[Common pct_of_obj:spinbutton pctx:0.5 pcty:0.5]
										 color:ccc3(0,0,0)
									  fontsize:13
										   str:@"Spin!"]];
	[self addChild:spinbutton];
	[touches addObject:spinbutton];
	
	wheel_pointer_vr = 0;
	wheel_pointer.rotation = float_random(-180, 180);
	
	return self;
}

-(void)spin {
	wheel_pointer_vr = float_random(35, 45);
	[spinbutton setVisible:NO];
}

-(void)update {
	if (!self.visible) return;
	
	for (CCSprite *spr in lights) [spr setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"menu_wheel_light_off"]];
	
	[wheel_pointer setRotation:wheel_pointer.rotation + wheel_pointer_vr * [Common get_dt_Scale]];
	if (wheel_pointer_vr > 0.1 && wheel_pointer_vr * 0.95 < 0.1) {
		wheel_pointer_vr = 0;
		[spinbutton setVisible:YES];
		NSLog(@"TODO --stopped");
	}
	
	wheel_pointer_vr *= 0.95;
	
	
	Vec3D v = [VecLib cons_x:cosf([Common deg_to_rad:wheel_pointer.rotation+90]) y:sinf([Common deg_to_rad:wheel_pointer.rotation+90]) z:0];
	float rad = fmodf([Common deg_to_rad:[VecLib get_rotation:v offset:0]],(3.14*2));
	if (rad < 0) rad = 3.14*2 - ABS(rad);
	int i_tar = rad / (3.14/6);
	
	if (i_tar < lights.count) {
		CCSprite *light = lights[i_tar];
		[light setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"menu_wheel_light_on"]];
	}
	
	
	for (id b in touches) if ([b respondsToSelector:@selector(update)]) [b update];
}

-(void)touch_begin:(CGPoint)pt {
	if (!self.visible) return;
	for (TouchButton *b in touches) if (b.visible) [b touch_begin:pt];
}

-(void)touch_end:(CGPoint)pt {
	if (!self.visible) return;
	for (TouchButton *b in touches) if (b.visible) [b touch_end:pt];
}

-(void)set_pane_open:(BOOL)t {
	[self setVisible:t];
}

@end
