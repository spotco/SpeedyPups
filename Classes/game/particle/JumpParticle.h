#import "Particle.h"

@interface JumpParticle : Particle {
	int ct;
}
+(JumpParticle*)cons_pt:(CGPoint)pt vel:(CGPoint)vel up:(CGPoint)up;
@end
