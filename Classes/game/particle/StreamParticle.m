#import "StreamParticle.h"
#import "FileCache.h"

@implementation StreamParticle
@synthesize ct;

+(StreamParticle*)cons_x:(float)x y:(float)y {
    StreamParticle* p = [StreamParticle spriteWithTexture:[Resource get_tex:TEX_PARTICLES] rect:[FileCache get_cgrect_from_plist:TEX_PARTICLES idname:@"grey_particle"]];
    [p cons];
    p.position = ccp(x,y);
    return p;
}

+(StreamParticle*)cons_x:(float)x y:(float)y vx:(float)vx vy:(float)vy {
    StreamParticle* p = [StreamParticle spriteWithTexture:[Resource get_tex:TEX_PARTICLES] rect:[FileCache get_cgrect_from_plist:TEX_PARTICLES idname:@"grey_particle"]];
    p.position = ccp(x,y);
    [p cons_vx:vx vy:vy];
    return p;
}

-(void)cons_vx:(float)tvx vy:(float)tvy {
	STREAMPARTICLE_CT_DEFAULT = 40;
    vx = tvx;
    vy = tvy;
    [self setScale:float_random(0.5, 2)];
    ct = (int)STREAMPARTICLE_CT_DEFAULT;
    [self setColor:ccc3(200, 200, 200)];
}

-(void)cons {
	STREAMPARTICLE_CT_DEFAULT = 40;
    vx = float_random(-2, -4);
    vy = float_random(0, 2);
    [self setScale:float_random(0.5, 2)];
    ct = (int)STREAMPARTICLE_CT_DEFAULT;
}

-(void)update:(GameEngineLayer*)g{
    [self setPosition:ccp(position_.x+vx,position_.y+vy)];
    [self setOpacity:((int)(ct/STREAMPARTICLE_CT_DEFAULT*255))];
    ct--;
}

-(BOOL)should_remove {
    return ct <= 0;
}

-(StreamParticle*)set_scale:(float)scale {
	[self setScale:scale];
	return self;
}

-(StreamParticle*)set_ctmax:(int)ctmax {
	STREAMPARTICLE_CT_DEFAULT =  ctmax;
	ct = ctmax;
	return self;
}

@end
