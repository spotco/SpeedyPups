#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    ShopTab_ITEMS,
    ShopTab_CHARACTERS,
	ShopTab_MISC
} ShopTab;

@interface ItemInfo : NSObject
@property(readwrite,strong) CCTexture2D* tex;
@property(readwrite,assign) CGRect rect;
@property(readwrite,assign) int price;
@property(readwrite,assign) NSString *name, *desc;
@end

@interface ShopRecord : NSObject
+(NSArray*)get_items_for_tab:(ShopTab)t;
@end
