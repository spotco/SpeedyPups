#import "Particle.h"

@interface StreamParticle : Particle {
    int ct;
	float STREAMPARTICLE_CT_DEFAULT;
	
	BOOL has_set_gravity, has_set_final_color, has_set_render_ord;
	CGPoint gravity;
	ccColor3B final_color, initial_color;
	int render_ord;
}



@property(readwrite,assign) int ct;

+(StreamParticle*)cons_x:(float)x y:(float)y;
+(StreamParticle*)cons_x:(float)x y:(float)y vx:(float)vx vy:(float)vy;
-(void)cons;

-(StreamParticle*)set_scale:(float)scale;
-(StreamParticle*)set_ctmax:(int)ctmax;

-(StreamParticle*)set_gravity:(CGPoint)g;
-(StreamParticle*)set_final_color:(ccColor3B)color;
-(StreamParticle*)set_render_ord:(int)ord;

@end
