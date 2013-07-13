#import "UserInventory.h"
#import "DataStore.h"
#import "Resource.h"

@implementation UserInventory

#define STO_CURRENT_BONES @"current_bones"
#define STO_MAIN_SLOT @"main_slot"

+(void)initialize {
	valid_characters = @[TEX_DOG_RUN_1,TEX_DOG_RUN_2,TEX_DOG_RUN_3,TEX_DOG_RUN_4,TEX_DOG_RUN_5,TEX_DOG_RUN_6,TEX_DOG_RUN_7];
}

+(NSString*)gameitem_to_string:(GameItem)t {
    return [NSString stringWithFormat:@"inventory_%d",t];
}

+(int)get_current_bones {
    return [DataStore get_int_for_key:STO_CURRENT_BONES];
}

+(void)add_bones:(int)ct {
    [DataStore set_key:STO_CURRENT_BONES int_value:[self get_current_bones]+ct];
}

+(GameItem)get_current_gameitem {
	return (GameItem)[DataStore get_int_for_key:STO_MAIN_SLOT];
}

+(void)set_current_gameitem:(GameItem)g {
	[DataStore set_key:STO_MAIN_SLOT int_value:(int)g];
}

//upgrade system
+(NSString*)gameitem_to_upgrade_level_string:(GameItem)gi {
    return [NSString stringWithFormat:@"upgrade_%d",gi];
}

+(int)get_upgrade_level:(GameItem)gi {
    return [DataStore get_int_for_key:[self gameitem_to_upgrade_level_string:gi]];
}

+(void)upgrade:(GameItem)gi {
    [DataStore set_key:[self gameitem_to_upgrade_level_string:gi] int_value:[self get_upgrade_level:gi]+1];
}

+(BOOL)can_upgrade:(GameItem)g {
	return YES;
}

static NSArray *valid_characters;
+(void)assert_valid_character:(NSString*)character {
	BOOL valid = NO;
	for (NSString *i in valid_characters) {
		if ([i isEqualToString:character]) valid = YES;
	}
	if (!valid) [NSException raise:@"invalid character" format:@""];
}

//character unlock
+(BOOL)get_character_unlocked:(NSString*)character {
	[self assert_valid_character:character];
	[self unlock_character:TEX_DOG_RUN_1];
	return [DataStore get_int_for_key:character];
}

+(void)unlock_character:(NSString*)character {
	[self assert_valid_character:character];
	[DataStore set_key:character int_value:1];
}

//item global cooldown
static int item_cooldown;
+(void)set_item_cooldown:(int)i {
	item_cooldown = i;
}
+(int)get_item_cooldown {
	return item_cooldown;
}
+(void)cooldown_tick {
	item_cooldown > 0 ? item_cooldown-- : 0;
}

@end
