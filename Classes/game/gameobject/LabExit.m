#import "LabExit.h"
#import "AudioManager.h"
#import "BGTimeManager.h"

@implementation LabExit

+(LabExit*)cons_pt:(CGPoint)pt {
    return [[LabExit node] cons_pt:pt];
}

-(id)cons_pt:(CGPoint)pt {
    return [super cons_pt:pt];
}

-(void)entrance_event {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_EXIT_TO_DEFAULTAREA]];
	[AudioManager playbgm:BGM_GROUP_WORLD1];
	
	if ([BGTimeManager get_global_time] == MODE_NIGHT) {
		[AudioManager transition_mode2];
	}
	
}


@end
