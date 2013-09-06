#import "OneUpParticle.h"
#import "GameRenderImplementation.h"
#import "GameEngineLayer.h"

@implementation OneUpParticle

+(OneUpParticle*)cons_pt:(CGPoint)pos {
    return [[OneUpParticle spriteWithTexture:[Resource get_tex:TEX_PARTICLES] rect:[FileCache get_cgrect_from_plist:TEX_PARTICLES idname:@"1up"]] cons_pt:pos];
}

-(id)cons_pt:(CGPoint)pt {
    [self setPosition:pt];
    ct = 30;
    ctmax = ct;
    [self setScale:0.75];
    return self;
}

-(void)update:(GameEngineLayer *)g {
    [self setPosition:CGPointAdd(self.position,ccp(0,6))];
    [self setOpacity:255*((float)ct)/ctmax];
    ct--;
}

-(BOOL)should_remove {
    return ct <= 0;
}

-(int)get_render_ord {
    return [GameRenderImplementation GET_RENDER_ABOVE_FG_ORD];
}

@end
