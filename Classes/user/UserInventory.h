#import <Foundation/Foundation.h>
#import "GameItemCommon.h"

@interface UserInventory : NSObject

+(int)get_current_bones;
+(void)add_bones:(int)ct;

+(int)get_current_coins;
+(void)add_coins:(int)ct;

+(GameItem)get_current_gameitem;
+(void)set_current_gameitem:(GameItem)g;

+(BOOL)get_item_owned:(GameItem)g;
+(void)set_item:(GameItem)g owned:(BOOL)owned;

+(int)get_upgrade_level:(GameItem)gi;
+(void)upgrade:(GameItem)gi;
+(BOOL)can_upgrade:(GameItem)g;

+(BOOL)get_character_unlocked:(NSString*)character;
+(void)unlock_character:(NSString*)character;

+(GameItem)get_equipped_gameitem;
+(void)set_equipped_gameitem:(GameItem)gi;
+(void)reset_to_equipped_gameitem;

@end
