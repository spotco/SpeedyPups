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
			  action:(ShopAction)action
				 key:(id)tkey {
	
	ItemInfo *i = [[ItemInfo alloc] init];
	i.tex = [Resource get_tex:texn];
	i.rect = [FileCache get_cgrect_from_plist:texn idname:rectid];
	i.name = name;
	i.desc = desc;
	i.price = price;
	
	i.action = action;
	i.action_key = tkey;
	
	return i;
}
@end

@implementation ShopRecord

+(NSArray*)get_items_for_tab:(ShopTab)t {
	NSMutableArray *a = [NSMutableArray array];
	if (t == ShopTab_ITEMS) [self fill_items_tab:a];
	if (t == ShopTab_CHARACTERS) [self fill_characters_tab:a];
	if (t == ShopTab_MISC) [self fill_misc_tab:a];
	if (t == ShopTab_UPGRADE) [self fill_upgrade_tab:a];
	return a;
}

+(void)fill_items_tab:(NSMutableArray*)a {
	[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS
							 rectid:@"item_magnet"
							   name:[GameItemCommon name_from:Item_Magnet]
							   desc:@"Magnet that does shit"
							  price:1
							 action:ShopAction_BUY_ITEM_UPGRADE
								key:[NSNumber numberWithInt:Item_Magnet]]];
	
	[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS
							 rectid:@"item_rocket"
							   name:[GameItemCommon name_from:Item_Rocket]
							   desc:@"Rocket that does shit"
							  price:1
							 action:ShopAction_BUY_ITEM_UPGRADE
								key:[NSNumber numberWithInt:Item_Rocket]]];
	
	[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS
							 rectid:@"item_shield"
							   name:[GameItemCommon name_from:Item_Shield]
							   desc:@"Shield that does shit"
							  price:1
							 action:ShopAction_BUY_ITEM_UPGRADE
								key:[NSNumber numberWithInt:Item_Shield]]];
	
	[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS
							 rectid:@"item_clock"
							   name:[GameItemCommon name_from:Item_Clock]
							   desc:@"Clock that does shit"
							  price:1
							 action:ShopAction_BUY_ITEM_UPGRADE
								key:[NSNumber numberWithInt:Item_Clock]]];
}

+(void)fill_characters_tab:(NSMutableArray*)a {
	NSString *dogs[] = {TEX_DOG_RUN_2,TEX_DOG_RUN_3,TEX_DOG_RUN_4,TEX_DOG_RUN_5,TEX_DOG_RUN_6,TEX_DOG_RUN_7};
	for(int i = 0; i < sizeof(dogs)/sizeof(NSString*); i++) {
		NSString *dog = dogs[i];
		if (![UserInventory get_character_unlocked:dog]) {
			[a addObject:[ItemInfo cons_tex:dog
									 rectid:@"run_0"
									   name:[Player get_name:dog]
									   desc:[NSString stringWithFormat:@"Unlock %@.\nSpecial ability:%@",
												[Player get_name:dog],
												[Player get_power_desc:dog]]
									  price:1
									 action:ShopAction_UNLOCK_CHARACTER
										key:dog]];
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
