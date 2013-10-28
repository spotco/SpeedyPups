#import "BGLayer.h"

typedef enum Lab2BGLayerSetState {
	Lab2BGLayerSetState_Normal,
	Lab2BGLayerSetState_Sinking,
	Lab2BGLayerSetState_Sunk
} Lab2BGLayerSetState;

@interface SubBossBGObject : BackgroundObject {
	CCNode __unsafe_unretained *anchor;
}
+(SubBossBGObject*)cons_anchor:(CCNode*)anchor;

-(void)anim_hatch_closed_to_cannon;

@property(readwrite,strong) CCSprite *body, *hatch, *wake;
@end

@interface Lab2BGLayerSet : BGLayerSet {
	NSMutableArray *bg_objects;
	BackgroundObject *tankers;
	BackgroundObject *tankersfront;
	BackgroundObject *docks;
	float tankers_theta;
	
	BackgroundObject *sky;
	BackgroundObject *clouds;
	
	NSMutableArray *particles;
	NSMutableArray *particles_tba;
	CCSprite *particleholder;
	Lab2BGLayerSetState current_state;
	
	SubBossBGObject *subboss;
}

+(Lab2BGLayerSet*)cons;
-(SubBossBGObject*)get_subboss_bgobject;
-(void)do_sink_anim;
-(void)reset;
@end
