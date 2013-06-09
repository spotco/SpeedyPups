#import "GameObject.h"
#import "WaveParticle.h"
#import "CaveWall.h"
#import "GameMain.h"

@interface World1ParticleGenerator : GameObject <GEventListener> {
	bool stop;
}

+(World1ParticleGenerator*)cons;

@end
