#import "FlashEffect.h"

@implementation FlashEffect

+(FlashEffect*)cons_from:(PlayerEffectParams*)base time:(int)time {
    FlashEffect *e = [[FlashEffect alloc] init];
    [PlayerEffectParams copy_params_from:base to:e];
    e.time_left = time;
    e.noclip = 1;
    return e;
}

-(void)update:(Player*)p g:(GameEngineLayer *)g {
    pl = p;
    ct++;
    if (ct%3==0) {
        toggle = !toggle;
        if(toggle) {
            [p setOpacity:140];
        } else {
            [p setOpacity:255];
        }
    }
}

-(void)effect_end {
    [pl setOpacity:255];
}

-(NSString*)info {
    return [NSString stringWithFormat:@"FlashEffect(timeleft:%i)",time_left];
}

@end
