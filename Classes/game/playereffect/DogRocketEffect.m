#import "DogRocketEffect.h"

@implementation DogRocketEffect

+(DogRocketEffect*)cons_from:(PlayerEffectParams*)base time:(int)time {
    DogRocketEffect *n = [[DogRocketEffect alloc] init];
    [PlayerEffectParams copy_params_from:base to:n];
    n.time_left = time;
    n.cur_airjump_count = 2;
    n.cur_gravity = -0.1;
    return n;
}

-(void)update:(Player*)p g:(GameEngineLayer *)g{
    if (p.vy > 0) {
        p.vy *= 0.9;
    }
    if (p.vx < 20) {
        p.vx += 1;
    }
}

-(player_anim_mode)get_anim {
    return player_anim_mode_ROCKET;
}

-(void)add_airjump_count {
    cur_airjump_count = 2;
}

-(NSString*)info {
    return [NSString stringWithFormat:@"DogRocketEffect(timeleft:%i)",time_left];
}

-(BOOL)is_also_dashing {
    return YES;
}

@end
