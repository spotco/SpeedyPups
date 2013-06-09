#import "World1ParticleGenerator.h"
#import "Player.h"
#import "GameEngineLayer.h"

@implementation World1ParticleGenerator

+(World1ParticleGenerator*)cons {
	World1ParticleGenerator *p = [World1ParticleGenerator node];
	[GEventDispatcher add_listener:p];
    return p;
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
	
	if (stop) return;
	
    if (arc4random_uniform(25) == 0) {
        [g add_particle:[WaveParticle cons_x:player.position.x+500 y:player.position.y+float_random(100, 300) vx:float_random(-2, -5) vtheta:float_random(0.01, 0.075)]];
    }
    return;
}

-(void)dispatch_event:(GEvent *)e {
	if (e.type == GEventType_ENTER_LABAREA) {
		stop = YES;
	} else if (e.type == GEventType_EXIT_TO_DEFAULTAREA) {
		stop = NO;
	}
}

@end
