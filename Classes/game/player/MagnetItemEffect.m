#import "MagnetItemEffect.h"
#import "FileCache.h"
#import "Resource.h"
#import "GEventDispatcher.h"
#import "GameEngineLayer.h"
#import "GameItemCommon.h"

@interface MagnetItemEffectParticle : CCSprite {
    CGPoint center;
    float radius,ctheta;
}
@end
@implementation MagnetItemEffectParticle

+(MagnetItemEffectParticle*)cons_center:(CGPoint)center radius:(float)radius phase:(float)phase {
    return [[MagnetItemEffectParticle spriteWithTexture:[Resource get_tex:TEX_ITEM_SS] rect:[FileCache get_cgrect_from_plist:TEX_ITEM_SS idname:@"item_magnet"]] cons_center:center radius:radius phase:phase];
}

-(id)cons_center:(CGPoint)tcenter radius:(float)tradius phase:(float)tphase {
    [self setScale:0.5];
    center = tcenter;
    radius = tradius;
    ctheta = tphase;
    [self update];
    return self;
}

-(void)update {
    ctheta+=0.1;
    [self setPosition:CGPointAdd(center, ccp(radius*cosf(ctheta), radius*sinf(ctheta)))];
}

@end

@implementation MagnetItemEffect

+(MagnetItemEffect*)cons {
    return [MagnetItemEffect node];
}

-(id)init {
    self = [super init];
    [GEventDispatcher add_listener:self];
    NSMutableArray* tparticles = [NSMutableArray array];
    for(float i = 0; i < M_PI*2; i+=M_PI/2) {
        [tparticles addObject:[MagnetItemEffectParticle cons_center:CGPointZero radius:60 phase:i]];
        particles = tparticles;
    }
    
    for (MagnetItemEffectParticle *i in particles) {
        [self addChild:i];
    }
    active = YES;
    return self;
}

-(void)check_should_render:(GameEngineLayer *)g {
    do_render = YES;
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
    if (kill) {
        [GEventDispatcher remove_listener:self];
        [g remove_gameobject:self];
        return;
    }
    
    [self setPosition:[player get_center]];
    for (MagnetItemEffectParticle *i in particles) {
        [i update];
    }
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_ITEM_DURATION_PCT && e.f1 ==0) {
        NSLog(@"f1:0 rocket:%d magnet:%d",e.i1==Item_Rocket,e.i1==Item_Magnet);
    }
    
    if (e.type == GEventType_ITEM_DURATION_PCT && e.f1 == 0 && e.i1 == Item_Magnet) {
        kill = YES;
    }
}

@end
