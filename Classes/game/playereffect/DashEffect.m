#import "DashEffect.h"
#import "GameEngineLayer.h"
#import "JumpPadParticle.h"

@implementation DashEffect

@synthesize vx,vy;

+(DashEffect*)cons_from:(PlayerEffectParams*)base vx:(float)vx vy:(float)vy {
    DashEffect *n = [[DashEffect alloc] init];
    [PlayerEffectParams copy_params_from:base to:n];
    
    n.vx = vx;
    n.vy = vy;
    
    n.time_left = [self dash_effect_length];
    n.cur_gravity = 0;
    return n;
}

+(int)dash_effect_length {
	return 30 * 1/[Common get_dt_Scale];
}

-(void)update:(Player*)p g:(GameEngineLayer *)g{
	self.player = p;
    if (p.current_island != NULL) {
        Vec3D t = [p.current_island get_tangent_vec];
        self.vx = t.x;
        self.vy = t.y;
    } else {    
        p.vx = self.vx*12;
        p.vy = self.vy*12;
    }
}



-(player_anim_mode)get_anim {
    return player_anim_mode_DASH;
}

-(NSString*)info {
    return [NSString stringWithFormat:@"DashEffect(timeleft:%i)",time_left];
}


@end
