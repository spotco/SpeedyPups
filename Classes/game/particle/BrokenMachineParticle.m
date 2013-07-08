#import "BrokenMachineParticle.h"
#import "GameRenderImplementation.h"
#import "FileCache.h"

@implementation BrokenMachineParticle

+(BrokenMachineParticle*)cons_x:(float)x y:(float)y vx:(float)vx vy:(float)vy {
    BrokenMachineParticle* p = [BrokenMachineParticle spriteWithTexture:[Resource get_tex:TEX_ROBOT_PARTICLE]];
    p.position = ccp(x,y);
    [p cons_vx:vx vy:vy];
    [p setScale:float_random(0.2, 0.5)];
    return p;
}

-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_FG_ISLAND_ORD];
}

@end


@implementation BrokenCopterMachineParticle

+(BrokenCopterMachineParticle*)cons_x:(float)x y:(float)y vx:(float)vx vy:(float)vy pimg:(int)pimg {
	BrokenCopterMachineParticle *p = [BrokenCopterMachineParticle spriteWithTexture:[Resource get_tex:TEX_ENEMY_COPTER]
																			   rect:[FileCache get_cgrect_from_plist:TEX_ENEMY_COPTER
																											  idname:[NSString stringWithFormat:@"particle_%d",pimg]]];
	[p setPosition:ccp(x,y)];
	[p cons_vx:vx vy:vy];
	return p;
}

-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_FG_ISLAND_ORD];
}

@end