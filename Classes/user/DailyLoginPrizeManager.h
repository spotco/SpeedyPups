#import <Foundation/Foundation.h>

@interface DailyLoginPrizeManager : NSObject
+(BOOL)daily_prize_open;
+(BOOL)daily_wheel_reset_open;

+(void)take_daily_prize;
+(void)take_daily_wheel_reset;

+(void)new_day;
+(long)get_time_until_new_day;

+(void)menu_popup_check;

+(void)increment_coins_spawned_today;
+(BOOL)conditional_do_coin_level;

@end
