#import "PlayerEffectParams.h"
#import "GameEngineLayer.h"

@implementation PlayerEffectParams

@synthesize cur_gravity,cur_airjump_count,time_left,cur_dash_count;
@synthesize noclip;


+(PlayerEffectParams*)cons_copy:(PlayerEffectParams*)p {
    PlayerEffectParams *n = [[PlayerEffectParams alloc] init];
    [PlayerEffectParams copy_params_from:p to:n];
    return n;
}

+(void)copy_params_from:(PlayerEffectParams *)a to:(PlayerEffectParams *)b {
    b.cur_gravity = -0.5;
    b.cur_airjump_count = a.cur_airjump_count;
    b.cur_dash_count = a.cur_dash_count;
}


-(void)decrement_timer {
    if (time_left > 0) {
        time_left--;
    }
}

-(void)add_airjump_count {
    cur_airjump_count = 2;
    cur_dash_count = 1;
}

-(void)decr_dash_count {
    if (cur_dash_count > 0) {
        cur_dash_count--;
    }
}

-(void)decr_airjump_count {
    if (cur_airjump_count > 0) {
        cur_airjump_count--;
    }
}

-(player_anim_mode)get_anim {
    return player_anim_mode_RUN;
}

-(void)update:(Player*)p g:(GameEngineLayer *)g{
}

-(NSString*)info {
    return [NSString stringWithFormat:@"DefaultEffect(timeleft:%i)",time_left];
}

-(void)effect_end{}

-(BOOL)is_also_dashing {
    return NO;
}

-(void)effect_begin:(Player *)p {}

@end
