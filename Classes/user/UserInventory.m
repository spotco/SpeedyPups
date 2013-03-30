#import "UserInventory.h"
#import "DataStore.h"

@implementation UserInventory

#define STO_CURRENT_BONES @"current_bones"

#define STO_MAIN_SLOT @"main_slot"
#define STO_SLOT_1 @"slot_1"
#define STO_SLOT_2 @"slot_2"
#define STO_SLOT_3 @"slot_3"
#define STO_SLOT_4 @"slot_4"
#define STO_SLOT_5 @"slot_5"
#define STO_SLOT_6 @"slot_6"
#define STO_SLOTS_UNLOCKED @"slots_unlocked"

+(NSString*)gameitem_to_string:(GameItem)t {
    return [NSString stringWithFormat:@"inventory_%d",t];
}

+(int)get_current_bones {
    return [DataStore get_int_for_key:STO_CURRENT_BONES];
}

+(void)add_bones:(int)ct {
    [DataStore set_key:STO_CURRENT_BONES int_value:[self get_current_bones]+ct];
}

+(int)get_inventory_ct_of:(GameItem)t {
    return [DataStore get_int_for_key:[self gameitem_to_string:t]];
}

+(void)set_inventory_ct_of:(GameItem)t to:(int)val{
    [DataStore set_key:[self gameitem_to_string:t] int_value:val];
}

+(int)get_num_slots_unlocked {
    return [DataStore get_int_for_key:STO_SLOTS_UNLOCKED];
}

+(void)unlock_slot {
    [DataStore set_key:STO_SLOTS_UNLOCKED int_value:[self get_num_slots_unlocked]+1];
}

+(int)get_lowest_empty_slot {
    NSArray* a = @[STO_MAIN_SLOT,STO_SLOT_1,STO_SLOT_2,STO_SLOT_3,STO_SLOT_4,STO_SLOT_5,STO_SLOT_6];
    for (int i = 0; i < [a count]; i++) {
        if (i <= [self get_num_slots_unlocked] && [self get_item_at_slot:i] == Item_NOITEM) {
            return i;
        }
    }
    return -1;
}

+(GameItem)get_item_at_slot:(int)i {
    NSArray* a = @[STO_MAIN_SLOT,STO_SLOT_1,STO_SLOT_2,STO_SLOT_3,STO_SLOT_4,STO_SLOT_5,STO_SLOT_6];
    return [DataStore get_int_for_key:a[i]];
}

+(void)set_item:(GameItem)t to_slot:(int)i {
    NSArray* a = @[STO_MAIN_SLOT,STO_SLOT_1,STO_SLOT_2,STO_SLOT_3,STO_SLOT_4,STO_SLOT_5,STO_SLOT_6];
    [DataStore set_key:a[i] int_value:t];
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

@end
