#import "Lab2BGLayerSet.h"
#import "ExplosionParticle.h"
#import "SubBoss.h"

@implementation SubBossBGObject
static CCAction* _anim_body_normal;
static CCAction* _anim_hatch_closed;
static CCAction* _anim_hatch_closed_to_cannon;
static CCAction* _anim_hatch_cannon_to_closed;
static CCAction* _anim_wake;

+(SubBossBGObject*)cons_anchor:(CCNode*)anchor { return [[SubBossBGObject node] cons_anchor:anchor]; }
-(id)cons_anchor:(CCNode*)tanchor {
	_body = [CCSprite node];
	_hatch = [CCSprite node];
	_wake = [CCSprite node];
	[self addChild:_body];
	[_hatch setAnchorPoint:ccp(0.5,0)];
	[_body addChild:_hatch];
	[_wake setAnchorPoint:ccp(1,0.5)];
	[self addChild:_wake];
	[SubBossBGObject cons_anims];
	
	[_hatch setPosition:ccp(215*0.35,195*0.35)];
	[_wake setPosition:ccp(-70*0.35,-0)];
	
	[_body runAction:_anim_body_normal];
	[_hatch runAction:_anim_hatch_closed];
	[_wake runAction:_anim_wake];
	
	[_body setRotation:-15];
	
	[self setPosition:ccp(-500,anchor.position.y + 175)];
	
	anchor = tanchor;
	return self;
}
-(void)reset {
	[_hatch stopAllActions];
	[_hatch runAction:_anim_hatch_closed];
}
-(void)update_posx:(float)posx posy:(float)posy{}
+(void)cons_anims {
	if (_anim_body_normal != NULL) return;
	_anim_body_normal = [Common cons_anim:@[@"bg_body_normal"] speed:20 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_hatch_closed = [Common cons_anim:@[@"bg_hatch_0"] speed:20 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_hatch_closed_to_cannon = [Common cons_nonrepeating_anim:@[@"bg_hatch_0",
													   @"bg_hatch_1",
													   @"bg_hatch_cannon_0",
													   @"bg_hatch_cannon_1",
													   @"bg_hatch_cannon_2"]
											   speed:0.1
											 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_hatch_cannon_to_closed = [Common cons_nonrepeating_anim:@[@"bg_hatch_cannon_2",
													   @"bg_hatch_cannon_1",
													   @"bg_hatch_cannon_0",
													   @"bg_hatch_1",
													   @"bg_hatch_0"]
											   speed:0.1
											 tex_key:TEX_ENEMY_SUBBOSS];
	_anim_wake = [Common cons_anim:@[@"bg_wake_0",@"bg_wake_1",@"bg_wake_2"] speed:0.15 tex_key:TEX_ENEMY_SUBBOSS];
}
-(void)anim_hatch_closed_to_cannon {
	[_hatch stopAllActions];
	[_hatch runAction:_anim_hatch_closed_to_cannon];
}
@end

@implementation Lab2BGLayerSet
+(Lab2BGLayerSet*)cons {
	Lab2BGLayerSet *rtv = [Lab2BGLayerSet node];
	return [rtv cons];
}

-(Lab2BGLayerSet*)cons {
	bg_objects = [NSMutableArray array];
	
	sky = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG2_SKY] scrollspd_x:0 scrollspd_y:0];
	[bg_objects addObject:sky];
	
	clouds = [[[CloudGenerator cons_texkey:TEX_BG2_CLOUDS_SS scaley:0.003] set_speedmult:0.3] set_generate_speed:140];
	[bg_objects addObject:clouds];
	[bg_objects addObject:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_WINDOWWALL] scrollspd_x:0.01 scrollspd_y:0]];
	
	BackgroundObject *backwater = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_WATER_BACK] scrollspd_x:0.06 scrollspd_y:0.0075];
	
	subboss = [SubBossBGObject cons_anchor:backwater];
	[bg_objects addObject:subboss];
	
	
	[bg_objects addObject:backwater];
	tankers = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_TANKER_BACK] scrollspd_x:0.08 scrollspd_y:0.0125];
	[bg_objects addObject:tankers];
	docks = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_DOCKS] scrollspd_x:0.08 scrollspd_y:0.02];
	[bg_objects addObject:docks];
	tankersfront = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_TANKER_FRONT] scrollspd_x:0.08 scrollspd_y:0.02];
	[bg_objects addObject:tankersfront];
	[bg_objects addObject:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_LAB2_WATER_FRONT] scrollspd_x:0.1 scrollspd_y:0.02]];
	
	particles = [NSMutableArray array];
	particles_tba = [NSMutableArray array];
	particleholder = [CCSprite node];
	[tankersfront addChild:particleholder];
	
	BGTimeManager *time = [BGTimeManager cons];
	[time setVisible:NO];
	[bg_objects addObject:time];
	
	
	for (BackgroundObject *o in bg_objects) {
		[self addChild:o];
	}
	
	current_state = Lab2BGLayerSetState_Normal;
	
	return self;
}

-(SubBossBGObject*)get_subboss_bgobject {
	return subboss;
}

-(void)set_day_night_color:(float)val{
	float pctm = ((float)val) / 100;
	[sky setColor:PCT_CCC3(50,50,90,pctm)];
	[clouds setColor:PCT_CCC3(80, 80, 130, pctm)];
}

static int explosion_ct;
-(void)update:(GameEngineLayer*)g curx:(float)curx cury:(float)cury {
	if (current_state == Lab2BGLayerSetState_Normal) {
		[tankers setVisible:YES];
		[docks setVisible:YES];
		[tankersfront setVisible:YES];
		[self remove_all_particles];
		
		for (BackgroundObject *o in bg_objects) {
			[o update_posx:curx posy:cury];
		}
		tankers_theta += 0.03 * [Common get_dt_Scale];
		tankers.position = CGPointAdd(ccp(0,sinf(tankers_theta)*2), tankers.position);
		tankersfront.position = CGPointAdd(ccp(0,cosf(tankers_theta)*2), tankersfront.position);
		
	} else if (current_state == Lab2BGLayerSetState_Sinking) {
		[tankers setVisible:YES];
		[docks setVisible:YES];
		[tankersfront setVisible:YES];
		
		[self update_particles];
		[self push_added_particles];
		
		explosion_ct++;
		if (explosion_ct%2==0) {
			Particle *p = [ExplosionParticle cons_x:float_random(0, 600) y:float_random(0,350)];
			[self add_particle:p];
		}
		
		for (BackgroundObject *o in bg_objects) {
			if (o == tankers || o == docks || o == tankersfront) {
				float prevy = o.position.y;
				[o update_posx:curx posy:cury];
				[o setPosition:ccp(o.position.x,prevy-3)];
				
				if (o == docks && o.position.y <= -350) current_state = Lab2BGLayerSetState_Sunk;
				
			} else {
				[o update_posx:curx posy:cury];
				
			}
			
		}
	} else if (current_state == Lab2BGLayerSetState_Sunk) {
		[tankers setVisible:NO];
		[docks setVisible:NO];
		[tankersfront setVisible:NO];
		[self remove_all_particles];
		for (BackgroundObject *o in bg_objects) {
			[o update_posx:curx posy:cury];
		}
	}
}

-(void)add_particle:(Particle*)p {
    [particles_tba addObject:p];
}
-(void)push_added_particles {
    for (Particle *p in particles_tba) {
        [particles addObject:p];
        [particleholder addChild:p z:[p get_render_ord]];
    }
    [particles_tba removeAllObjects];
}
-(void)remove_all_particles {
	if ([particles count] != 0) {
		NSMutableArray *toremove = [NSMutableArray array];
		for (Particle *i in particles) {
			[particleholder removeChild:i cleanup:YES];
			[toremove addObject:i];
		}
		[particles removeObjectsInArray:toremove];
	}
}
-(void)update_particles {
    NSMutableArray *toremove = [NSMutableArray array];
    for (Particle *i in particles) {
        [i update:NULL];
        if ([i should_remove]) {
            [particleholder removeChild:i cleanup:YES];
            [toremove addObject:i];
        }
    }
    [particles removeObjectsInArray:toremove];
}

-(void)do_sink_anim {
	current_state = Lab2BGLayerSetState_Sinking;
	tankers_theta = 0;
}

-(void)reset {
	current_state = Lab2BGLayerSetState_Normal;
	[tankers setPosition:CGPointZero];
	[tankersfront setPosition:CGPointZero];
	[docks setPosition:CGPointZero];
	[subboss setPosition:ccp(-[Common SCREEN].width,subboss.position.y)];
	[subboss reset];
}
@end
