#import "ShopRecord.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameItemCommon.h"
#import "UserInventory.h"
#import "Player.h"
#import "FreeRunStartAtManager.h"

@implementation ItemInfo
@synthesize tex;
@synthesize rect;
@synthesize price;
@synthesize name,desc;
+(ItemInfo*)cons_tex:(NSString*)texn
			  rectid:(NSString*)rectid
				name:(NSString*)name
				desc:(NSString*)desc
			   price:(int)price
				 val:(NSString*)val {
	
	ItemInfo *i = [[ItemInfo alloc] init];
	i.tex = [Resource get_tex:texn];
	i.rect = [FileCache get_cgrect_from_plist:texn idname:rectid];
	i.name = name;
	i.desc = desc;
	i.price = price;
	i.val = val;
	return i;
}

+(ItemInfo*)cons_tex:(CCTexture2D*)texn
				rect:(CGRect)rectid
				name:(NSString*)name
				desc:(NSString*)desc
			   price:(int)price
				 val:(NSString*)val {
	ItemInfo *i = [[ItemInfo alloc] init];
	i.tex = texn;
	i.rect = rectid;
	i.name = name;
	i.desc = desc;
	i.price = price;
	i.val = val;
	return i;
}

@end

@implementation ShopRecord

+(NSArray*)get_items_for_tab:(ShopTab)t {
	NSMutableArray *a = [NSMutableArray array];
	if (t == ShopTab_UPGRADE) [self fill_items_tab:a];
	if (t == ShopTab_CHARACTERS) [self fill_characters_tab:a];
	if (t == ShopTab_UNLOCK) [self fill_unlock_tab:a];
	if (t == ShopTab_REALMONEY) [self fill_realmoney_tab:a];
	return a;
}

+(void)fill_items_tab:(NSMutableArray*)a {
	[self add_item:Item_Magnet into:a];
	[self add_item:Item_Rocket into:a];
	[self add_item:Item_Shield into:a];
	[self add_item:Item_Clock into:a];
}

+(void)add_item:(GameItem)item into:(NSMutableArray*)a {
	if (![UserInventory can_upgrade:item]) return;
	int uggval = [UserInventory get_upgrade_level:item];
	NSString* shop_val = item == Item_Clock ? SHOP_ITEM_CLOCK :
		(item == Item_Magnet ? SHOP_ITEM_MAGNET :
		 (item == Item_Rocket ? SHOP_ITEM_ROCKET :
		  (item == Item_Shield ? SHOP_ITEM_ARMOR : @"top lel")));
	int price = 1;
	if (item == Item_Clock) {
		int vals[] = {900,2000,4000};
		price = vals[uggval];
	} else if (item == Item_Magnet) {
		int vals[] = {300,1000,2000};
		price = vals[uggval];
	} else if (item == Item_Rocket) {
		int vals[] = {500,1400,2500};
		price = vals[uggval];
	} else if (item == Item_Shield) {
		int vals[] = {600,1700,3000};
		price = vals[uggval];
	}
	
	NSString *item_name = [GameItemCommon name_from:item];
	NSString *use_name = uggval == 0?
		item_name:
		[NSString stringWithFormat:@"%@ %d",item_name,uggval+1];
	NSString *use_desc = uggval == 0?@"Unlock to equip in inventory.":@"Upgrade to last longer.";
	
	ItemInfo *i = [ItemInfo cons_tex:TEX_ITEM_SS
							  rectid:[ShopRecord gameitem_to_texid:item]
								name:use_name
								desc:[NSString stringWithFormat:@"%@\nUse: %@",use_desc,[GameItemCommon description_from:item]]
							   price:price
								 val:shop_val];
	[a addObject:i];
}

+(void)fill_characters_tab:(NSMutableArray*)a {
	NSString *dogs[] = {	TEX_DOG_RUN_2,	TEX_DOG_RUN_3,	TEX_DOG_RUN_4,	TEX_DOG_RUN_5,	TEX_DOG_RUN_6,	TEX_DOG_RUN_7};
	NSString *actions[] = {	SHOP_DOG_DOG2,	SHOP_DOG_DOG3,	SHOP_DOG_DOG4,	SHOP_DOG_DOG5,	SHOP_DOG_DOG6,	SHOP_DOG_DOG7};
	float prices[] = {		1500,			3000,			7500,			15000,			25000,			35000};
	for(int i = 0; i < sizeof(dogs)/sizeof(NSString*); i++) {
		NSString *dog = dogs[i];
		if (![UserInventory get_character_unlocked:dog]) {
			[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS
									 rectid:[NSString stringWithFormat:@"dog_%d",i+2]
									   name:[Player get_name:dog]
									   desc:[NSString stringWithFormat:@"Unlock %@.\nAbility: %@",
												[Player get_full_name:dog],
												[Player get_power_desc:dog]]
									  price:prices[i]
										val:actions[i]]];
		}
	}
}

+(void)fill_unlock_tab:(NSMutableArray*)a {
	if (![FreeRunStartAtManager get_can_start_at:FreeRunStartAt_LAB3]) {
		TexRect *freerunstarticon = [FreeRunStartAtManager get_icon_for_loc:FreeRunStartAt_WORLD1];
		[a addObject:[ItemInfo cons_tex:freerunstarticon.tex
								   rect:freerunstarticon.rect
								   name:@"Free Run"
								   desc:@"Unlock all freerun start points!"
								  price:25000
									val:SHOP_UNLOCK_FREERUN]];
	}
}

+(void)fill_realmoney_tab:(NSMutableArray*)a {
}

+(NSString*)gameitem_to_texid:(GameItem)i {
	if ([UserInventory get_upgrade_level:i] == 0) {
		if (i == Item_Heart) return @"item_heart";
		else if (i == Item_Magnet) return @"item_magnet";
		else if (i == Item_Rocket) return @"item_rocket";
		else if (i == Item_Shield) return @"item_shield";
		else if (i == Item_Clock) return @"item_clock";
		else return @"";

	} else {
		if (i == Item_Heart) return @"upgrade_heart";
		else if (i == Item_Magnet) return @"upgrade_magnet";
		else if (i == Item_Rocket) return @"upgrade_rocket";
		else if (i == Item_Shield) return @"upgrade_shield";
		else if (i == Item_Clock) return @"item_clock";
		else return @"";

	}
}

+(BOOL)buy_shop_item:(NSString *)val price:(int)price {
	if (price > [UserInventory get_current_bones]) return NO;
	
	if (streq(val, SHOP_ITEM_MAGNET)) {
		if (![UserInventory can_upgrade:Item_Magnet]) return NO;
		[UserInventory upgrade:Item_Magnet];
		
	} else if (streq(val, SHOP_ITEM_ARMOR)) {
		if (![UserInventory can_upgrade:Item_Shield]) return NO;
		[UserInventory upgrade:Item_Shield];
		
	} else if (streq(val, SHOP_ITEM_ROCKET)) {
		if (![UserInventory can_upgrade:Item_Rocket]) return NO;
		[UserInventory upgrade:Item_Rocket];
		
	} else if (streq(val, SHOP_ITEM_CLOCK)) {
		if (![UserInventory can_upgrade:Item_Clock]) return NO;
		[UserInventory upgrade:Item_Clock];
		
	} else if (streq(val, SHOP_DOG_DOG2)) {
		if ([UserInventory get_character_unlocked:TEX_DOG_RUN_2]) return NO;
		[UserInventory unlock_character:TEX_DOG_RUN_2];
		
	} else if (streq(val, SHOP_DOG_DOG3)) {
		if ([UserInventory get_character_unlocked:TEX_DOG_RUN_3]) return NO;
		[UserInventory unlock_character:TEX_DOG_RUN_3];
		
	} else if (streq(val, SHOP_DOG_DOG4)) {
		if ([UserInventory get_character_unlocked:TEX_DOG_RUN_4]) return NO;
		[UserInventory unlock_character:TEX_DOG_RUN_4];
		
	} else if (streq(val, SHOP_DOG_DOG5)) {
		if ([UserInventory get_character_unlocked:TEX_DOG_RUN_5]) return NO;
		[UserInventory unlock_character:TEX_DOG_RUN_5];
		
	} else if (streq(val, SHOP_DOG_DOG6)) {
		if ([UserInventory get_character_unlocked:TEX_DOG_RUN_6]) return NO;
		[UserInventory unlock_character:TEX_DOG_RUN_6];
		
	} else if (streq(val, SHOP_DOG_DOG7)) {
		if ([UserInventory get_character_unlocked:TEX_DOG_RUN_7]) return NO;
		[UserInventory unlock_character:TEX_DOG_RUN_7];
		
	} else if (streq(val, SHOP_UNLOCK_FREERUN)) {
		[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD1];
		[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD2];
		[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_WORLD3];
		[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB1];
		[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB2];
		[FreeRunStartAtManager set_can_start_at:FreeRunStartAt_LAB3];
		
	}
	[UserInventory add_bones:-price];
	return YES;
}

@end
