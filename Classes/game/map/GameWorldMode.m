#import "GameWorldMode.h"

@implementation GameWorldMode

static BGMode cur_bgmode;
static WorldNum cur_worldnum;
static LabNum cur_labnum;

+(BGMode)get_bgmode {
	return cur_bgmode;
}
+(WorldNum)get_worldnum {
	if ([self get_bgmode] == BGMode_LAB) {
		return cur_worldnum + 1 > MAX_WORLD ? WorldNum_1 : cur_worldnum + 1;
	}
	return cur_worldnum;
}
+(WorldNum)get_actual_worldnum {
	return cur_worldnum;
}
+(LabNum)get_labnum {
	return cur_labnum;
}

+(void)reset {
	cur_bgmode = BGMode_NORMAL;
}

static BOOL about_to_enter_lab = NO;
+(void)freerun_progress_about_to_enter_lab {
	about_to_enter_lab = YES;
}

+(FreeRunProgress)get_freerun_progress {
	if ([self get_worldnum] == WorldNum_1) {
		return about_to_enter_lab ? FreeRunProgress_1 : FreeRunProgress_PRE_1;
	
	} else if ([self get_worldnum] == WorldNum_2) {
		return about_to_enter_lab ? FreeRunProgress_2 : FreeRunProgress_PRE_2;
		
	} else if ([self get_worldnum] == WorldNum_3) {
		return about_to_enter_lab ? FreeRunProgress_3 : FreeRunProgress_PRE_3;
		
	}
	return FreeRunProgress_PRE_1;
}

+(void)increment_world {
	cur_worldnum = cur_worldnum + 1 > MAX_WORLD ? WorldNum_1 : cur_worldnum + 1;
	cur_labnum = MIN(cur_worldnum,MAX_LAB);
	about_to_enter_lab = NO;
}

+(void)set_bgmode:(BGMode)b {
	cur_bgmode = b;
	about_to_enter_lab = NO;
}
+(void)set_worldnum:(WorldNum)w {
	cur_worldnum = MIN(w,MAX_WORLD);
	cur_labnum = MIN(w,MAX_LAB);
	about_to_enter_lab = NO;
}

@end
