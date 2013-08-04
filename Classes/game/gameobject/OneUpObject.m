#import "OneUpObject.h"
#import "OneUpParticle.h"
#import "GameEngineLayer.h"

@implementation OneUpObject
+(OneUpObject*)cons_pt:(CGPoint)pt {
	return [[OneUpObject spriteWithTexture:[Resource get_tex:TEX_ONEUP_OBJECT]] cons_pt:pt];
}
-(id)cons_pt:(CGPoint)pt {
	[self setPosition:pt];
	active = YES;
	[self setScale:0.75];
	return self;
}
-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:position_.x-30 y1:position_.y-30 wid:60 hei:60];
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
	_g = g;
	[super update:player g:g];
}

-(void)hit {
	[_g incr_lives];
	[_g add_particle:[OneUpParticle cons_pt:[_g.player get_center]]];
	active = NO;
}

-(void)reset {
    [self setPosition:initial_pos];
    follow = NO;
    vx = 0;
    vy = 0;
	active = YES;
}
@end
