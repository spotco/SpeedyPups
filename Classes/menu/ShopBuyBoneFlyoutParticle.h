#import "Particle.h"

@interface ShopBuyBoneFlyoutParticle : Particle {
	int ct;
	CGPoint vel;
	float vr;
	float init_scale;
}

+(ShopBuyBoneFlyoutParticle*)cons_pt:(CGPoint)pt vel:(CGPoint)vel;

@end
