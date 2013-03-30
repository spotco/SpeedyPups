#import <Foundation/Foundation.h>
#import "GameItemCommon.h"

@interface UserInventory : NSObject

+(int)get_current_bones;
+(void)add_bones:(int)ct;
+(void)set_inventory_ct_of:(GameItem)t to:(int)val;
+(int)get_inventory_ct_of:(GameItem)t;
+(int)get_num_slots_unlocked;
+(int)get_lowest_empty_slot;
+(void)unlock_slot;
+(GameItem)get_item_at_slot:(int)i;
+(void)set_item:(GameItem)t to_slot:(int)i;

@end
