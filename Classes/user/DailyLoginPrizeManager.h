#import <Foundation/Foundation.h>

@interface DailyLoginPrizeManager : NSObject
+(BOOL)is_new_day;
+(void)take_daily_prize;
+(void)new_day;
+(long)get_time_until_new_day;
@end
