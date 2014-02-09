#import "RobotBossFistProjectile.h"
#import "GameEngineLayer.h"
#import "BreakableWallRockParticle.h"
#import "Player.h" 
#import "HitEffect.h"

#define MODE_LINE 0
#define MODE_PARABOLA_A 1
#define MODE_PARABOLA_AT_CAT 2

#define ROBOT_DEFAULT_POS ccp(725,0)

@implementation RobotBossFistProjectile
@synthesize direction;

+(RobotBossFistProjectile*)cons_g:(GameEngineLayer*)g relpos:(CGPoint)relpos tarpos:(CGPoint)tarpos time:(float)time groundlevel:(float)groundlevel {
	return [[RobotBossFistProjectile spriteWithTexture:[Resource get_tex:TEX_ENEMY_ROBOTBOSS]
												  rect:[FileCache get_cgrect_from_plist:TEX_ENEMY_ROBOTBOSS idname:@"fist"]]
			cons_g:g relpos:relpos tarpos:tarpos time:time groundlevel:groundlevel];
}

-(id)cons_g:(GameEngineLayer*)g relpos:(CGPoint)_relpos tarpos:(CGPoint)_tarpos time:(float)time groundlevel:(float)_groundlevel {
	time_total = time;
	time_left = time;
	startpos = _relpos;
	tarpos = _tarpos;
	groundlevel = _groundlevel;
	
	mode = MODE_LINE;
	
	[self setPosition:CGPointAdd(ccp(g.player.position.x,groundlevel), startpos)];
	
	self.active = YES;
	return self;
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
	time_left -= [Common get_dt_Scale];
	
	float time_pct = time_left/time_total;
	float x = tarpos.x + (startpos.x - tarpos.x)*time_pct;
	float y;
	
	if (mode == MODE_PARABOLA_A) {
		y = 3.39*x - 0.0047*x*x; //quadratic fit {0,0}, {585,350}, {250,550}
		
	} else if (mode == MODE_PARABOLA_AT_CAT) {
		y = -0.0115646*x*x + 17.649*x - 6017.35; //quadratic fit {900,500}, {585,350}, {725,700}
		
	} else {
		y = tarpos.y + (startpos.y - tarpos.y)*time_pct;
	
	}
	
	[self setPosition:CGPointAdd(ccp(g.player.position.x,groundlevel), ccp(x,y))];
	
	self.rotation += [Common get_dt_Scale] * (direction == RobotBossFistProjectileDirection_AT_PLAYER ? 5 : 12);
	
	if (direction == RobotBossFistProjectileDirection_AT_PLAYER && !player.dead) {
		if ([Common hitrect_touch:[self get_hit_rect] b:[player get_hit_rect]] && (player.dashing || [player is_armored])) {
            time_total = 55;
			time_left = 55;
			startpos = ccp(x,y);
			tarpos = ccp(ROBOT_DEFAULT_POS.x,ROBOT_DEFAULT_POS.y+150);
			direction = RobotBossFistProjectileDirection_AT_BOSS;
			[self mode_line];
			[AudioManager playsfx:SFX_ROCKBREAK];
			
		} else if ([Common hitrect_touch:[self get_small_hit_rect] b:[player get_hit_rect]]) {
            [player add_effect:[HitEffect cons_from:[player get_default_params] time:40]];
			[self explosion_effect:g];
            [AudioManager playsfx:SFX_EXPLOSION];
            [g remove_gameobject:self];
            [g.get_stats increment:GEStat_ROBOT];
		}
		
	}
}

-(id)set_startpos:(CGPoint)_startpos tarpos:(CGPoint)_tarpos time_left:(float)_time_left time_total:(float)_time_total {
	startpos = _startpos;
	tarpos = _tarpos;
	time_left = _time_left;
	time_total = _time_total;
	return self;
}

-(float)time_left {
	return time_left;
}

-(id)mode_parabola_a {
	mode = MODE_PARABOLA_A;
	return self;
}

-(id)mode_parabola_at_cat {
	mode = MODE_PARABOLA_AT_CAT;
	return self;
}

-(id)mode_line {
	mode = MODE_LINE;
	return self;
}

-(HitRect)get_hit_rect {
    return [Common hitrect_cons_x1:position_.x-40 y1:position_.y-40 wid:80 hei:80];
}

-(HitRect)get_small_hit_rect {
	return [Common hitrect_cons_x1:position_.x-20 y1:position_.y-20 wid:40 hei:40];
}

-(BOOL)should_remove {
	return time_left <= 0;
}

-(void)do_remove:(GameEngineLayer *)g {
	[self explosion_effect:g];
}

-(void)explosion_effect:(GameEngineLayer*)g {
	DO_FOR(20, [g add_particle:
				[[BreakableWallRockParticle cons_lab_x:position_.x
													y:position_.y
												   vx:float_random(-10, 10)
												   vy:float_random(-1, 15)] set_gravity:0.8] ];)
}

-(void)check_should_render:(GameEngineLayer *)g { do_render = YES; }

@end
