#import "World1ParticleGenerator.h"
#import "Player.h"
#import "GameEngineLayer.h"

@implementation World1ParticleGenerator

+(World1ParticleGenerator*)cons {
    return [World1ParticleGenerator node];
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
    for (GameObject* i in g.game_objects) {
        if ([i class] == [CaveWall class] && [Common hitrect_touch:[i get_hit_rect] b:[player get_hit_rect]]) {
            return;
        }
    }
    
    if (arc4random_uniform(25) == 0) {
        [g add_particle:[WaveParticle cons_x:player.position.x+500 y:player.position.y+float_random(100, 300) vx:float_random(-2, -5) vtheta:float_random(0.01, 0.075)]];
    }
    return;
}

@end
