#import "InventoryTabPane_Prizes.h"
#import "Common.h"
#import "MenuCommon.h"
#import "SpinButton.h"
#import "DataStore.h"
#import "UserInventory.h"

typedef enum PrizesPaneMode {
	PrizesPaneMode_REST,
	PrizesPaneMode_SPINNING,
	PrizesPaneMode_GIVE_PRIZE
} PrizesPaneMode;

typedef enum Prize {
	Prize_ManyCoin,
	Prize_ManyBone,
	Prize_Coin,
	Prize_Bone,
	Prize_Mystery,
	Prize_None
} Prize;

@interface PrizeIcon : CCSprite
@property(readwrite,assign) Prize prize_type;
@end
@implementation PrizeIcon
@synthesize prize_type;
@end

@implementation InventoryTabPane_Prizes {
	NSMutableArray *touches;
	NSMutableArray *lights;
	NSMutableArray *prizes;
	CCSprite *wheel_pointer;
	float wheel_pointer_vr;
	SpinButton *spinbutton;
	
	CCLabelTTF *cur_bones_disp;
	CCLabelTTF *cur_coins_disp;
	
	PrizesPaneMode mode;
	float disp_bones;
}

+(InventoryTabPane_Prizes*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Prizes node] cons:parent];
}

-(id)cons:(CCSprite*)parent {
	touches = [NSMutableArray array];
	prizes = [NSMutableArray array];
	mode = PrizesPaneMode_REST;
	disp_bones = [UserInventory get_current_bones];
	CCSprite *wheel_label = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"wheelofprizes"]]
							 pos:[Common pct_of_obj:parent pctx:0.5 pcty:0.79]];
	[wheel_label setScaleX:0.82];
	[wheel_label setScaleY:0.66];
	[self addChild:wheel_label];
	
	CCSprite *bones_disp_bg = [[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													 rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"currency_bones_disp"]]
							   pos:[Common pct_of_obj:parent pctx:0.02 pcty:0.25]] anchor_pt:ccp(0,0.5)];
	[self addChild:bones_disp_bg];
	
	cur_bones_disp = [[Common cons_label_pos:[Common pct_of_obj:bones_disp_bg pctx:0.2 pcty:0.5]
									  color:ccc3(200,30,30)
								   fontsize:20
										str:@""] anchor_pt:ccp(0,0.5)];
	[bones_disp_bg addChild:cur_bones_disp];
	
	
	CCSprite *coins_disp_bg = [[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													   rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"currency_coins_disp"]]
								pos:[Common pct_of_obj:parent pctx:0.02 pcty:0.1]] anchor_pt:ccp(0,0.5)];
	[self addChild:coins_disp_bg];
	
	cur_coins_disp = [[Common cons_label_pos:[Common pct_of_obj:coins_disp_bg pctx:0.2 pcty:0.5]
									   color:ccc3(200,30,30)
									fontsize:20
										 str:@""] anchor_pt:ccp(0,0.5)];
	[coins_disp_bg addChild:cur_coins_disp];
	
	CCSprite *wheel_bg = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
												 rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"menu_wheel_back"]]
						  pos:[Common pct_of_obj:parent pctx:0.5 pcty:0.425]];
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
		
		PrizeIcon *prize_icon = [PrizeIcon spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:CGRectZero];
		prize_icon.prize_type = Prize_None;
		[prize_icon setScale:0.6];
		tar_pos = ccp(0.5,0.5);
		v = [VecLib scale:[VecLib cons_x:cosf(i+[Common deg_to_rad:15]) y:sinf(i+[Common deg_to_rad:15]) z:0] by:0.41];
		tar_pos.x += v.x;
		tar_pos.y += v.y;
		[prize_icon setPosition:[Common pct_of_obj:wheel_bg pctx:tar_pos.x pcty:tar_pos.y]];
		[prizes addObject:prize_icon];
		[wheel_bg addChild:prize_icon];
	}
	[wheel_bg setScale:0.8];
	[wheel_bg addChild:wheel_pointer];
	
	
	spinbutton = [SpinButton cons_pt:[Common pct_of_obj:parent pctx:0.84 pcty:0.25]
								  cb:[Common cons_callback:self sel:@selector(spin)]];
	
	[self addChild:spinbutton];
	[touches addObject:spinbutton];
	
	wheel_pointer_vr = 0;
	wheel_pointer.rotation = float_random(-180, 180);
	
	[self reload_prizes];
	
	return self;
}


-(void)reload_prizes {
	
	Prize manycoin = Prize_ManyCoin;
	Prize manybone = Prize_ManyBone;
	Prize coin = Prize_Coin;
	Prize bone = Prize_Bone;
	
	NSMutableArray *in_prizes = _NSMARRAY(
		NSVEnum(manycoin, Prize),
		NSVEnum(manybone, Prize),
		NSVEnum(coin, Prize),
		NSVEnum(coin, Prize),
		NSVEnum(bone, Prize),
		NSVEnum(bone, Prize)
	);
	[in_prizes shuffle];
	
	NSMutableArray *open_slots = [NSMutableArray array];
	for (int i = 0; i < prizes.count; i++) [open_slots addObject:[NSNumber numberWithInt:i]];
	[open_slots shuffle];
	
	for (PrizeIcon *i in prizes) {
		i.prize_type = Prize_None;
		[i setTextureRect:CGRectZero];
	}
	while(in_prizes.count > 0) {
		int slot = [open_slots.lastObject intValue];
		Prize tar_type;
		[in_prizes.lastObject getValue:&tar_type];
		PrizeIcon *tar = prizes[slot];
		
		[open_slots removeLastObject];
		[in_prizes removeLastObject];
		
		tar.prize_type = tar_type;
		
		NSString *texkey = @"";
		if (tar.prize_type == Prize_ManyCoin) {
			texkey = @"menu_prize_manycoin";
		} else if (tar.prize_type == Prize_ManyBone) {
			texkey = @"menu_prize_manybone";
		} else if (tar.prize_type == Prize_Coin) {
			texkey = @"menu_prize_fewcoin";
		} else if (tar.prize_type == Prize_Bone) {
			texkey = @"menu_prize_fewbone";
		} else if (tar.prize_type == Prize_Mystery) {
			texkey = @"menu_prize_mystery";
		}
		[tar setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:texkey]];
	}
	
	
}

#define KEY_LAST_TIME_SPIN @"key_last_time_spinned"
#define SPIN_COST 500
#define RESPIN_TIME 10

-(void)refresh_page {
	BOOL time_ok = NO;
	long last_time_spinned = [DataStore get_long_for_key:KEY_LAST_TIME_SPIN];
	if (last_time_spinned == 0) {
		time_ok = YES;
	} else if (sys_time() - last_time_spinned > RESPIN_TIME) {
		time_ok = YES;
	} else {
		time_ok = NO;
	}
	
	BOOL bones_ok = NO;
	if ([UserInventory get_current_bones] >= SPIN_COST) {
		bones_ok = YES;
	}
	
	
	if (!time_ok) {
		[spinbutton lock_time:RESPIN_TIME - (sys_time() - last_time_spinned)];
		
	} else if (!bones_ok) {
		[spinbutton lock_bones:SPIN_COST];
		
	} else {
		[spinbutton unlock_cost:SPIN_COST];
		
	}
	
	[cur_coins_disp set_label:strf("%d",[UserInventory get_current_coins])];
	[cur_bones_disp set_label:strf("%d",(int)disp_bones)];
	
	disp_bones = drp(disp_bones,[UserInventory get_current_bones],7);
	if (ABS(disp_bones - [UserInventory get_current_bones]) < 2) disp_bones = [UserInventory get_current_bones];
}

-(void)give_prize:(Prize)t {
	if (t == Prize_ManyCoin) {
		[UserInventory add_coins:3];
		
	} else if (t == Prize_ManyBone) {
		[UserInventory add_bones:1000];
		
	} else if (t == Prize_Coin) {
		[UserInventory add_coins:1];
		
	} else if (t == Prize_Bone) {
		[UserInventory add_bones:300];
		
	}
}

-(void)spin {
	if ([UserInventory get_current_bones] < SPIN_COST) return;
	[UserInventory add_bones:-SPIN_COST];
	mode = PrizesPaneMode_SPINNING;
	wheel_pointer_vr = float_random(35, 45);
	[DataStore set_long_for_key:KEY_LAST_TIME_SPIN long_value:sys_time()];
}

-(void)update {
	if (!self.visible) return;
	
	for (CCSprite *spr in lights) [spr setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"menu_wheel_light_off"]];
	for (id b in touches) if ([b respondsToSelector:@selector(update)]) [b update];
	[self refresh_page];
	
	Vec3D v = [VecLib cons_x:cosf([Common deg_to_rad:wheel_pointer.rotation+90]) y:sinf([Common deg_to_rad:wheel_pointer.rotation+90]) z:0];
	float rad = fmodf([Common deg_to_rad:[VecLib get_rotation:v offset:0]],(3.14*2));
	if (rad < 0) rad = 3.14*2 - ABS(rad);
	int i_tar = rad / (3.14/6);
	
	if (i_tar > lights.count) {
		i_tar = 0;
	}
	CCSprite *light = lights[i_tar];
	[light setTextureRect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"menu_wheel_light_on"]];
	
	if (mode == PrizesPaneMode_SPINNING) {
		[wheel_pointer setRotation:wheel_pointer.rotation + wheel_pointer_vr * [Common get_dt_Scale]];
		if (wheel_pointer_vr > 0.1 && wheel_pointer_vr * 0.95 < 0.1) {
			wheel_pointer_vr = 0;
			[self give_prize:((PrizeIcon*)prizes[i_tar]).prize_type];
			mode = PrizesPaneMode_GIVE_PRIZE;
		}
		wheel_pointer_vr *= 0.975;
	
	} else if (mode == PrizesPaneMode_GIVE_PRIZE) {
		mode = PrizesPaneMode_REST;
		
	}

}

-(void)setVisible:(BOOL)visible {
	if (visible) [self refresh_page];
	[super setVisible:visible];
}

-(void)touch_begin:(CGPoint)pt {
	if (!self.visible) return;
	for (TouchButton *b in touches) if (b.visible) [b touch_begin:pt];
}

-(void)touch_move:(CGPoint)pt {
	if (!self.visible) return;
	for (TouchButton *b in touches) if (b.visible) [b touch_move:pt];
}

-(void)touch_end:(CGPoint)pt {
	if (!self.visible) return;
	for (TouchButton *b in touches) if (b.visible) [b touch_end:pt];
}

-(void)set_pane_open:(BOOL)t {
	[self setVisible:t];
}

@end
