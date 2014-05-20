#import "DailyLoginPrizeManager.h"
#import "Common.h" 
#import "MenuCommon.h"
#import "DataStore.h"
#import "DailyLoginPopup.h"
#import "MenuCommon.h"
#import "UserInventory.h"

@implementation DailyLoginPrizeManager

#define KEY_LAST_DAY_TIME @"key_last_day_time"
#define KEY_FIRST_LOGIN @"key_first_login"
#define KEY_DAILY_PRIZE_TAKEN @"key_daily_prize_taken"
#define KEY_DAILY_WHEEL_RESET_TAKEN @"key_daily_wheel_reset_taken"
#define KEY_COINS_SPAWNED_TODAY @"key_coins_spawned_today"
#define DAY_TIME 24 * 60 * 60

+(BOOL)daily_prize_open {
	return [DataStore get_int_for_key:KEY_DAILY_PRIZE_TAKEN] == 0;
}

+(BOOL)daily_wheel_reset_open {
	return [DataStore get_int_for_key:KEY_DAILY_WHEEL_RESET_TAKEN] == 0;
}

+(void)take_daily_prize {
	[DataStore set_key:KEY_DAILY_PRIZE_TAKEN int_value:1];
}

+(void)take_daily_wheel_reset {
	[DataStore set_key:KEY_DAILY_WHEEL_RESET_TAKEN flt_value:1];
}

+(void)new_day {
	[DataStore set_long_for_key:KEY_LAST_DAY_TIME long_value:sys_time()];
	[DataStore set_key:KEY_DAILY_PRIZE_TAKEN int_value:0];
	[DataStore set_key:KEY_DAILY_WHEEL_RESET_TAKEN int_value:0];
	[DataStore set_key:KEY_COINS_SPAWNED_TODAY int_value:0];
}

+(long)get_time_until_new_day {
	return MAX(0,DAY_TIME - (sys_time() - [DataStore get_long_for_key:KEY_LAST_DAY_TIME]));
}

+(void)menu_popup_check {
	if ([self get_time_until_new_day] <= 0) {
		[self new_day];
	}
	
	if ([DataStore get_int_for_key:KEY_FIRST_LOGIN] == 0) {
		[DataStore set_key:KEY_FIRST_LOGIN int_value:1];
		[self take_daily_prize];
		
		BasePopup *p = [DailyLoginPopup cons];
		[self basepopup:p
				 add_h1:@"Welcome!"
					 h2:@"To celebrate your first day, here's 3 coins!"
					 h3:@"(Play every day for some great prizes)"
					amt:3];
		[UserInventory add_coins:3];
		[MenuCommon popup:p];
		
	} else if ([self daily_prize_open]) {
		[self take_daily_prize];
		BasePopup *p = [DailyLoginPopup cons];
		[self basepopup:p
				 add_h1:@"Welcome back!"
					 h2:@"For playing today, here's a coin!"
					 h3: int_random(0, 2) == 0 ? @"(Use these to continue after a game over)" : @"(Save up and buy something nice at the store)"
					amt:1];
		[UserInventory add_coins:1];
		[MenuCommon popup:p];
		
	}
}

+(void)basepopup:(BasePopup*)p add_h1:(NSString*)h1 h2:(NSString*)h2 h3:(NSString*)h3 amt:(int)amt {
	[p addChild:[Common cons_label_pos:[Common pct_of_obj:p pctx:0.5 pcty:0.875]
								 color:ccc3(20,20,20)
							  fontsize:35
								   str:h1]];
	[p addChild:[Common cons_label_pos:[Common pct_of_obj:p pctx:0.5 pcty:0.75]
								 color:ccc3(20,20,20)
							  fontsize:15
								   str:h2]];
	[p addChild:[Common cons_label_pos:[Common pct_of_obj:p pctx:0.5 pcty:0.675]
								 color:ccc3(20,20,20)
							  fontsize:12
								   str:h3]];
	[p addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_ITEM_SS]
										rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"star_coin"]]
				 pos:[Common pct_of_obj:p pctx:0.425 pcty:0.5]]];
	[p addChild:[Common cons_label_pos:[Common pct_of_obj:p pctx:0.5325 pcty:0.5]
								 color:ccc3(200,30,30)
							  fontsize:12
								   str:@"x"]];
	[p addChild:[[Common cons_label_pos:[Common pct_of_obj:p pctx:0.575 pcty:0.5]
								  color:ccc3(200,30,30)
							   fontsize:25
									str:strf("%d",amt)] anchor_pt:ccp(0,0.5)]];
}

+(int)coins_spawned_today {
	return [DataStore get_int_for_key:KEY_COINS_SPAWNED_TODAY];
}
+(void)increment_coins_spawned_today {
	[DataStore set_key:KEY_COINS_SPAWNED_TODAY int_value:[self coins_spawned_today]+1];
}
+(BOOL)conditional_do_coin_level {
	int som = [self coins_spawned_today] + 1;
	return int_random(0, som) == 0;
}

@end
