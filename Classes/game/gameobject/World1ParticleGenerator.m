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
	
	ct -= [Common get_dt_Scale];
	
    if (ct <= 0) {
		ccColor3B color;
		if ([GameWorldMode get_worldnum] == WorldNum_2) {
			color = ccc3(float_random(188, 224), float_random(128, 154), float_random(56, 69));
			
		} else {
			color = ccc3(float_random(197, 217),float_random(225, 250),float_random(128, 148));
		}
		
        [g add_particle:[[WaveParticle cons_x:player.position.x+900
										   y:player.position.y+float_random(100, 300)
										  vx:float_random(-2, -5)
									  vtheta:float_random(0.01, 0.075)] set_color:color]];
		ct = float_random(15, 40);
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
