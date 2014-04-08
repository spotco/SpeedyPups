#import "GameWorldMode.h"

@implementation GameWorldMode
@synthesize cur_world;
@synthesize cur_mode;

+(GameWorldMode*)cons_worldnum:(WorldNum)world {
	GameWorldMode *rtv = [[GameWorldMode alloc] init];
	rtv.cur_world = world;
	rtv.cur_mode = BGMode_NORMAL;
	return rtv;
}

-(void)set_to_lab {
	cur_mode = BGMode_LAB;
}

-(void)increment_world {
	cur_world++;
	if (cur_world != WorldNum_1 && cur_world != WorldNum_2 && cur_world != WorldNum_3) {
		cur_world = WorldNum_1;
	}
}

-(FreeRunProgress)get_freerun_progress {
	if (cur_world == WorldNum_1) {
		return FreeRunProgress_1;
	} else if (cur_world == WorldNum_2) {
		return FreeRunProgress_2;
	} else if (cur_world == WorldNum_3) {
		return FreeRunProgress_3;
	} else {
		NSLog(@"get_freerun_progress erreur");
		return FreeRunProgress_1;
	}
}

@end
