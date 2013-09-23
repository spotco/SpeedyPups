#import <Foundation/Foundation.h>
#import "FreeRunProgressAnimation.h"
#import "GameEngineLayer.h"
@class TexRect;

typedef enum {
	FreeRunStartAt_ERRVAL = -1,
	FreeRunStartAt_TUTORIAL = 0,
	FreeRunStartAt_WORLD1 = 1,
	FreeRunStartAt_LAB1 = 2,
	FreeRunStartAt_WORLD2 = 3,
	FreeRunStartAt_LAB2 = 4,
	FreeRunStartAt_WORLD3 = 5,
	FreeRunStartAt_LAB3 = 6
} FreeRunStartAt;

@interface FreeRunStartAtManager : NSObject

+(BOOL)get_can_start_at:(FreeRunStartAt)loc;
+(void)set_can_start_at:(FreeRunStartAt)loc;
+(TexRect*)get_icon_for_loc:(FreeRunStartAt)loc;
+(NSString*)name_for_loc:(FreeRunStartAt)loc;

+(FreeRunStartAt)get_starting_loc;
+(void)set_starting_loc:(FreeRunStartAt)loc;

+(FreeRunStartAt)get_for_progress:(FreeRunProgress)prog;

+(WorldNum)worldnum_for_startingloc;

@end
