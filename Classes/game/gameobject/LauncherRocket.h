#import "GameObject.h"
#import "DogShadow.h"

@interface LauncherRocket : GameObject {
    CGPoint v;
    CGPoint vibration,actual_pos;
    CCSprite* trail;
    BOOL kill;
	BOOL no_vibration;
    int ct,remlimit,broken_ct;
    float vibration_ct;
	
	float trail_scale;
    
    ObjectShadow *shadow;
}

+(LauncherRocket*)cons_at:(CGPoint)pt vel:(CGPoint)vel;
-(void)update_position;
-(id)set_remlimit:(int)t;
-(LauncherRocket*)no_vibration;
-(BOOL)is_active;
-(GameObject*)get_shadow;

-(id)set_scale:(float)sc;

@end

@interface RelativePositionLauncherRocket : LauncherRocket {
    CGPoint rel_pos,player_pos;
	BOOL homing;
}
+(RelativePositionLauncherRocket*)cons_at:(CGPoint)pt player:(CGPoint)player vel:(CGPoint)vel;
-(id)set_homing;
@end