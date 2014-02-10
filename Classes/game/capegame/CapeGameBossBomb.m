#import "CapeGameBossBomb.h"
#import "Resource.h"
#import "Common.h"
#import "EnemyBomb.h"
#import "CapeGamePlayer.h"
#import "ExplosionParticle.h"

@implementation CapeGameBossBomb

+(CapeGameBossBomb*)cons_pos:(CGPoint)pos {
	return [[CapeGameBossBomb spriteWithTexture:[Resource get_tex:TEX_ENEMY_BOMB]] cons_pos:pos];
}

-(id)cons_pos:(CGPoint)pos {
	[super setPosition:pos];
	[self setAnchorPoint:ccp(15/31.0,16/45.0)];
	return self;
}

-(void)update:(CapeGameEngineLayer *)g {
	[self setRotation:self.rotation+6*[Common get_dt_Scale]];
	[super setPosition:CGPointAdd(self.position, ccp(-3.5*[Common get_dt_Scale],0))];
	[g add_particle:[[BombSparkParticle cons_pt:[self get_tip] v:ccp(float_random(-5,5),float_random(-5, 5))] set_scale:0.4]];
	
	if ([Common hitrect_touch:[self get_hit_rect] b:g.player.get_hitrect]) {
		[g add_particle:[ExplosionParticle cons_x:position_.x y:position_.y]];
		[g remove_gameobject:self];
		
	} else if (self.position.x < -100) {
		[g remove_gameobject:self];
	}
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:position_.x-20 y1:position_.y-20 wid:40 hei:40];
}

#define TIPSCALE 30
-(CGPoint)get_tip {
    float arad = -[Common deg_to_rad:[self rotation]]+45;
    return ccp(position_.x+cosf(arad)*TIPSCALE*0.65,position_.y+sinf(arad)*TIPSCALE);
}

-(void)setPosition:(CGPoint)position{}

@end
