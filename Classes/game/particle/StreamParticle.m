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
	if (has_set_gravity) {
		vx += gravity.x;
		vy += gravity.y;
	}
	if (has_set_final_color) {
		float pct = ct/STREAMPARTICLE_CT_DEFAULT;
		[self setColor:ccc3(pct*(initial_color.r-final_color.r)+final_color.r,
							pct*(initial_color.g-final_color.g)+final_color.g,
							pct*(initial_color.b-final_color.b)+final_color.b)];
	}
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

-(StreamParticle*)set_gravity:(CGPoint)g {
	has_set_gravity = YES;
	gravity = g;
	return self;
}
-(StreamParticle*)set_final_color:(ccColor3B)color {
	has_set_final_color = YES;
	final_color = color;
	initial_color = [self color];
	return self;
}
-(StreamParticle*)set_render_ord:(int)ord {
	has_set_render_ord = YES;
	render_ord = ord;
	return self;
}

-(int)get_render_ord {
	if (has_set_render_ord) return render_ord;
	return [super get_render_ord];
}

@end
