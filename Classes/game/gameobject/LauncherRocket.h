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
    
    ObjectShadow *shadow;
}

+(LauncherRocket*)cons_at:(CGPoint)pt vel:(CGPoint)vel;
-(void)update_position;
-(id)set_remlimit:(int)t;
-(LauncherRocket*)no_vibration;
-(BOOL)is_active;
-(GameObject*)get_shadow;

@end

@interface RelativePositionLauncherRocket : LauncherRocket {
    CGPoint rel_pos,player_pos;
}
+(RelativePositionLauncherRocket*)cons_at:(CGPoint)pt player:(CGPoint)player vel:(CGPoint)vel;

@end