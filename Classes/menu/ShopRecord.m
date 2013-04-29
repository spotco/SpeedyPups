#import "ShopRecord.h"
#import "Resource.h"
#import "FileCache.h"

@implementation ItemInfo
@synthesize tex;
@synthesize rect;
@synthesize price;
@synthesize name,desc;
+(ItemInfo*)cons_tex:(NSString*)texn rectid:(NSString*)rectid name:(NSString*)name desc:(NSString*)desc price:(int)price {
	ItemInfo *i = [[ItemInfo alloc] init];
	i.tex = [Resource get_tex:texn];
	i.rect = [FileCache get_cgrect_from_plist:texn idname:rectid];
	i.name = name;
	i.desc = desc;
	i.price = price;
	return i;
}
@end

@implementation ShopRecord

+(NSArray*)get_items_for_tab:(ShopTab)t {
	NSMutableArray *a = [NSMutableArray array];
	if (t == ShopTab_ITEMS) [self fill_items_tab:a];
	if (t == ShopTab_CHARACTERS) [self fill_characters_tab:a];
	if (t == ShopTab_MISC) [self fill_misc_tab:a];
	return a;
}

+(void)fill_items_tab:(NSMutableArray*)a {
	[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS rectid:@"item_magnet" name:@"magnet" desc:@"some magnet" price:1]];
	[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS rectid:@"item_rocket" name:@"rocket" desc:@"some rocket" price:1]];
	[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS rectid:@"item_shield" name:@"armor" desc:@"some armor" price:1]];
	[a addObject:[ItemInfo cons_tex:TEX_ITEM_SS rectid:@"item_heart" name:@"heart" desc:@"some heart" price:1]];
}

+(void)fill_characters_tab:(NSMutableArray*)a {
	[a addObject:[ItemInfo cons_tex:TEX_DOG_RUN_2 rectid:@"run_0" name:@"Cate" desc:@"Unlock Cate the Corgi.\nSpecial ability:\nDodge bullets" price:1]];
	[a addObject:[ItemInfo cons_tex:TEX_DOG_RUN_3 rectid:@"run_0" name:@"Penny" desc:@"Unlock Penny the Poodle.\nSpecial ability:\nDodge bullets" price:1]];
	[a addObject:[ItemInfo cons_tex:TEX_DOG_RUN_4 rectid:@"run_0" name:@"Spot" desc:@"Unlock Spot the Dalmation.\nSpecial ability:\nDodge bullets" price:1]];
	[a addObject:[ItemInfo cons_tex:TEX_DOG_RUN_5 rectid:@"run_0" name:@"Pugsy" desc:@"Unlock Pugsy the Pug.\nSpecial ability:\nDodge bullets" price:1]];
	[a addObject:[ItemInfo cons_tex:TEX_DOG_RUN_6 rectid:@"run_0" name:@"Husky" desc:@"Unlock Husky the Husky.\nSpecial ability:\nDodge bullets" price:1]];
	[a addObject:[ItemInfo cons_tex:TEX_DOG_RUN_7 rectid:@"run_0" name:@"Max" desc:@"Unlock Max the Labrador.\nSpecial ability:\nDodge bullets" price:1]];
}

+(void)fill_misc_tab:(NSMutableArray*)a {
}

@end
