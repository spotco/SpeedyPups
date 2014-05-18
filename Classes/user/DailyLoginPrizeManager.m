#import "DailyLoginPrizeManager.h"
#import "Common.h" 
#import "MenuCommon.h"
#import "DataStore.h"

@implementation DailyLoginPrizeManager

#define KEY_LAST_DAY_TIME @"key_last_day_time"
#define KEY_TODAY_IS_TAKEN @"key_today_is_taken"
#define DAY_TIME 24 * 60 * 60

+(BOOL)is_new_day {
	return ![DataStore get_int_for_key:KEY_TODAY_IS_TAKEN] && (sys_time() - [DataStore get_long_for_key:KEY_LAST_DAY_TIME] > DAY_TIME);
}

+(void)take_daily_prize {
	[DataStore set_key:KEY_TODAY_IS_TAKEN int_value:1];
}

+(void)new_day {
	[DataStore set_key:KEY_TODAY_IS_TAKEN int_value:0];
}

+(long)get_time_until_new_day {
	return MAX(0,DAY_TIME - (sys_time() - [DataStore get_long_for_key:KEY_LAST_DAY_TIME]));
}

@end
