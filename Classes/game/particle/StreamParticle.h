#import "Particle.h"

@interface StreamParticle : Particle {
    int ct;
	float STREAMPARTICLE_CT_DEFAULT;
}



@property(readwrite,assign) int ct;

+(StreamParticle*)cons_x:(float)x y:(float)y;
+(StreamParticle*)cons_x:(float)x y:(float)y vx:(float)vx vy:(float)vy;
-(void)cons;

-(StreamParticle*)set_scale:(float)scale;
-(StreamParticle*)set_ctmax:(int)ctmax;

@end
