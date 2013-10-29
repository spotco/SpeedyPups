#import "BGLayer.h"

typedef enum Lab2BGLayerSetState {
	Lab2BGLayerSetState_Normal,
	Lab2BGLayerSetState_Sinking,
	Lab2BGLayerSetState_Sunk
} Lab2BGLayerSetState;

@interface SubBossBGObject : BackgroundObject {
	CCNode __unsafe_unretained *anchor;
	CGPoint actual_position;
	CGPoint recoil_delta;
}
+(SubBossBGObject*)cons_anchor:(CCNode*)anchor;
-(void)set_recoil_delta:(CGPoint)delta;
-(CGPoint)get_nozzle;

-(void)anim_hatch_closed;
-(void)anim_hatch_closed_to_cannon;
-(void)anim_hatch_closed_to_open;

-(void)explosion_at:(CGPoint)pt;
-(void)launch_rocket;
-(void)reset;

@property(readwrite,strong) CCSprite *body, *hatch;
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
	NSMutableArray *tankersfront_particles_tba;
	CCSprite *tankersfront_particleholder;
	CCSprite *particleholder;
	Lab2BGLayerSetState current_state;
	
	SubBossBGObject *subboss;
}

+(Lab2BGLayerSet*)cons;
-(SubBossBGObject*)get_subboss_bgobject;
-(void)do_sink_anim;
-(void)reset;
@end
