#import "Particle.h"

@interface OneUpParticle : Particle {
    int ct,ctmax;
}

+(OneUpParticle*)cons_pt:(CGPoint)pos;

@end
