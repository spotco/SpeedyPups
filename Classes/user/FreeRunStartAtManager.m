#import "FreeRunStartAtManager.h"
#import "Common.h"
#import "DataStore.h"
#import "Resource.h"
#import "FileCache.h"

@implementation FreeRunStartAtManager

#define STARTING_LOC_KEY @"STARTING_AT"
+(FreeRunStartAt)get_starting_loc {
	return [DataStore get_int_for_key:STARTING_LOC_KEY];
}

+(void)set_starting_loc:(FreeRunStartAt)loc {
	[DataStore set_key:STARTING_LOC_KEY int_value:loc];
}

+(NSString*)string_for_loc:(FreeRunStartAt)loc {
	return strf("START_AT_%d",loc);
}

+(BOOL)get_can_start_at:(FreeRunStartAt)loc {
	if (loc == FreeRunStartAt_TUTORIAL) {
		return YES;
	}
	return [DataStore get_int_for_key:[self string_for_loc:loc]];
}

+(void)set_can_start_at:(FreeRunStartAt)loc {
	[DataStore set_key:[self string_for_loc:loc] int_value:1];
}

+(TexRect*)get_icon_for_loc:(FreeRunStartAt)loc {
	if (loc == FreeRunStartAt_TUTORIAL) {
		return [TexRect cons_tex:[Resource get_tex:TEX_FREERUNSTARTICONS] rect:[FileCache get_cgrect_from_plist:TEX_FREERUNSTARTICONS idname:@"icon_tutorial"]];
		
	} else if (loc == FreeRunStartAt_LAB1 || loc == FreeRunStartAt_LAB2 || loc == FreeRunStartAt_LAB3) {
		return [TexRect cons_tex:[Resource get_tex:TEX_FREERUNSTARTICONS] rect:[FileCache get_cgrect_from_plist:TEX_FREERUNSTARTICONS idname:@"icon_lab"]];
		
	} else if (loc == FreeRunStartAt_WORLD1 || loc == FreeRunStartAt_WORLD2 || loc == FreeRunStartAt_WORLD3) {
		return [TexRect cons_tex:[Resource get_tex:TEX_FREERUNSTARTICONS] rect:[FileCache get_cgrect_from_plist:TEX_FREERUNSTARTICONS idname:@"icon_world1"]];
		
	} else {
		NSLog(@"FreeRunStartAtManager get_icon_for_loc is null");
		return NULL;
	}
}

+(NSString*)name_for_loc:(FreeRunStartAt)loc {
	if (loc == FreeRunStartAt_WORLD1) {
		return @"World 1";
	} else if (loc == FreeRunStartAt_TUTORIAL) {
		return @"Tutorial";
	} else if (loc == FreeRunStartAt_LAB1) {
		return @"Lab 1";
	} else if (loc == FreeRunStartAt_WORLD2) {
		return @"World 2";
	} else if (loc == FreeRunStartAt_LAB2) {
		return @"Lab 2";
	} else if (loc == FreeRunStartAt_WORLD3) {
		return @"World 3";
	} else if (loc == FreeRunStartAt_LAB3) {
		return @"Lab 3";
	} else {
		return @"ERROR";
	}
}

+(FreeRunStartAt)get_for_progress:(FreeRunProgress)prog {
	if (prog == FreeRunProgress_PRE_1) {
		return FreeRunStartAt_WORLD1;
	} else if (prog == FreeRunProgress_1) {
		return FreeRunStartAt_LAB1;
	} else if (prog == FreeRunProgress_PRE_2) {
		return FreeRunStartAt_WORLD2;
	} else if (prog == FreeRunProgress_2) {
		return FreeRunStartAt_LAB2;
	} else if (prog == FreeRunProgress_PRE_3) {
		return FreeRunStartAt_WORLD3;
	} else if (prog == FreeRunProgress_3) {
		return FreeRunStartAt_LAB3;
	} else {
		return FreeRunStartAt_ERRVAL;
	}
}

@end
