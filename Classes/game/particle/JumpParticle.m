#import "JumpParticle.h"
#import "FileCache.h"
#import "GameRenderImplementation.h"

@implementation JumpParticle

static const float TIME = 15.0;
static const float MINSCALE = 3;
static const float MAXSCALE = 5;

+(JumpParticle*)cons_pt:(CGPoint)pt vel:(CGPoint)vel up:(CGPoint)up {
	return [[JumpParticle node] cons_pt:pt vel:vel up:up];
}

-(id)cons_pt:(CGPoint)pt vel:(CGPoint)vel up:(CGPoint)up  {
    [self setTexture:[Resource get_tex:TEX_DASHJUMPPARTICLES_SS]];
	[self setTextureRect:[FileCache get_cgrect_from_plist:TEX_DASHJUMPPARTICLES_SS
												   idname:@"jumpparticle"]];
    [self setPosition:pt];
	[self setScale:3];
	
	Vec3D velvec = [VecLib cons_x:vel.x y:vel.y z:0];;
	velvec = [VecLib negate:velvec];
	Vec3D dirvec = [VecLib normalize:
					[VecLib add:[VecLib normalize:velvec]
							 to:[VecLib scale:[VecLib normalize:[VecLib cons_x:up.x y:up.y z:0]]
										   by:0.75]
					 ]
					];
	//NSLog(@"dir(%f,%f)",dirvec.x,dirvec.y);
	float ccwt = [Common rad_to_deg:[VecLib get_angle_in_rad:dirvec]+45];
	[self setRotation:ccwt > 0 ? 180-ccwt : -(180-ABS(ccwt))];
	
    ct = TIME;
    
    return self;
	
}

-(void)update:(GameEngineLayer*)g{
    ct--;
	[self setScale:(1-ct/TIME)*(MAXSCALE-MINSCALE)+MINSCALE];
    [self setOpacity:(int)(200*(ct/TIME))+55];
}

-(BOOL)should_remove {
    return ct <= 0;
}

-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_FG_ISLAND_ORD];
}

@end
