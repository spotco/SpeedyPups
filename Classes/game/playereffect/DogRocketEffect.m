#import "DogRocketEffect.h"
#import "GEventDispatcher.h"
#import "GameItemCommon.h"

@implementation DogRocketEffect

+(DogRocketEffect*)cons_from:(PlayerEffectParams*)base time:(int)time {
    DogRocketEffect *n = [[DogRocketEffect alloc] init];
    [PlayerEffectParams copy_params_from:base to:n];
    n.time_left = time;
    [n recft];
    n.cur_airjump_count = 2;
    n.cur_gravity = -0.1;
    return n;
}

-(void)recft {
    fulltime = time_left;
}

-(void)update:(Player*)p g:(GameEngineLayer *)g{
    if (p.vy > 0) {
        p.vy *= 0.9;
    }
    if (p.vx < 20) {
        p.vx += 1;
    }
    [GEventDispatcher push_event:[[GEvent cons_type:GEventType_ITEM_DURATION_PCT] add_f1:((float)time_left)/fulltime f2:0]];
}

-(void)effect_end {
    [GEventDispatcher push_event:[[[GEvent cons_type:GEventType_ITEM_DURATION_PCT] add_f1:0 f2:0] add_i1:Item_Rocket i2:0]];
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
