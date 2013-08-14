#import "ShopRecord.h"
#import "Resource.h"
#import "FileCache.h"
#import "GameItemCommon.h"
#import "UserInventory.h"
#import "Player.h"

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
@end

@implementation ShopRecord

+(NSArray*)get_items_for_tab:(ShopTab)t {
	NSMutableArray *a = [NSMutableArray array];
	if (t == ShopTab_UPGRADE) [self fill_items_tab:a];
	if (t == ShopTab_CHARACTERS) [self fill_characters_tab:a];
	if (t == ShopTab_UNLOCK) [self fill_misc_tab:a];
	if (t == ShopTab_REALMONEY) [self fill_upgrade_tab:a];
	return a;
}

+(void)fill_items_tab:(NSMutableArray*)a {
	if ([UserInventory get_upgrade_level:Item_Magnet] == 0) {
		[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS
								 rectid:@"item_magnet"
								   name:[GameItemCommon name_from:Item_Magnet]
								   desc:@"Unlock the rocket to equip in the inventory!"
								  price:1000
									val:SHOP_ITEM_MAGNET]];
	}
	
	if ([UserInventory get_upgrade_level:Item_Rocket] == 0) {
		[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS
								 rectid:@"item_rocket"
								   name:[GameItemCommon name_from:Item_Rocket]
								   desc:@"Unlock the rocket to equip in the inventory!"
								  price:2000
									val:SHOP_ITEM_ROCKET]];
	}
	
	if ([UserInventory get_upgrade_level:Item_Shield] == 0) {
		[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS
								 rectid:@"item_shield"
								   name:[GameItemCommon name_from:Item_Shield]
								   desc:@"Unlock the shield to equip in the inventory!"
								  price:3000
									val:SHOP_ITEM_ARMOR]];
	}
	
	if ([UserInventory get_upgrade_level:Item_Clock] == 0) {
		[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS
								 rectid:@"item_clock"
								   name:[GameItemCommon name_from:Item_Clock]
								   desc:@"Unlock the clock to equip in the inventory!"
								  price:4000
									val:SHOP_ITEM_CLOCK]];
	}
}

+(void)fill_characters_tab:(NSMutableArray*)a {
	NSString *dogs[] = {	TEX_DOG_RUN_2,	TEX_DOG_RUN_3,	TEX_DOG_RUN_4,	TEX_DOG_RUN_5,	TEX_DOG_RUN_6,	TEX_DOG_RUN_7};
	NSString *actions[] = {	SHOP_DOG_DOG2,	SHOP_DOG_DOG3,	SHOP_DOG_DOG4,	SHOP_DOG_DOG5,	SHOP_DOG_DOG6,	SHOP_DOG_DOG7};
	float prices[] = {		1500,			3000,			7500,			15000,			25000,			35000};
	for(int i = 0; i < sizeof(dogs)/sizeof(NSString*); i++) {
		NSString *dog = dogs[i];
		if (![UserInventory get_character_unlocked:dog]) {
			[a addObject:[ItemInfo cons_tex:dog
									 rectid:@"run_0"
									   name:[Player get_name:dog]
									   desc:[NSString stringWithFormat:@"Unlock %@.\nSpecial ability:%@",
												[Player get_name:dog],
												[Player get_power_desc:dog]]
									  price:prices[i]
										val:actions[i]]];
		}
	}
}

+(void)fill_upgrade_tab:(NSMutableArray*)a {
}

+(void)fill_misc_tab:(NSMutableArray*)a {
}

+(NSString*)gameitem_to_upgradeid:(GameItem)i {
	if (i == Item_Heart) return @"upgrade_heart";
	else if (i == Item_Magnet) return @"upgrade_magnet";
	else if (i == Item_Rocket) return @"upgrade_rocket";
	else if (i == Item_Shield) return @"upgrade_shield";
	else return @"";
}

@end
