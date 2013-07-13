#import <Foundation/Foundation.h>
#import "GameItemCommon.h"

@interface UserInventory : NSObject

+(int)get_current_bones;
+(void)add_bones:(int)ct;

+(GameItem)get_current_gameitem;
+(void)set_current_gameitem:(GameItem)g;
+(int)get_upgrade_level:(GameItem)gi;
+(void)upgrade:(GameItem)gi;
+(BOOL)can_upgrade:(GameItem)g;

+(BOOL)get_character_unlocked:(NSString*)character;
+(void)unlock_character:(NSString*)character;

+(void)set_item_cooldown:(int)i;
+(int)get_item_cooldown;
+(void)cooldown_tick;

@end
