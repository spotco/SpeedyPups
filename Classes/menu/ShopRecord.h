#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    ShopTab_ITEMS,
    ShopTab_CHARACTERS,
	ShopTab_MISC,
	ShopTab_UPGRADE
} ShopTab;

typedef enum {
	ShopAction_UNLOCK_CHARACTER,
	ShopAction_BUY_ITEM,
	ShopAction_BUY_ITEM_UPGRADE,
	ShopAction_BUY_SLOT_UPGRADE
} ShopAction;

@interface ItemInfo : NSObject
@property(readwrite,strong) CCTexture2D* tex;
@property(readwrite,assign) CGRect rect;
@property(readwrite,assign) int price;
@property(readwrite,strong) NSString *name, *desc;

@property(readwrite,assign) ShopAction action;
@property(readwrite,strong) id action_key;
@end

@interface ShopRecord : NSObject
+(NSArray*)get_items_for_tab:(ShopTab)t;
@end
