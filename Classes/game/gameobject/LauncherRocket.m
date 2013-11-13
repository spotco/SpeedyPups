#import "LauncherRocket.h"
#import "LauncherRobot.h"
#import "JumpPadParticle.h"
#import "GameEngineLayer.h"
#import "HitEffect.h" 
#import "DazedParticle.h"
#import "ExplosionParticle.h"
#import "MinionRobot.h" 

@implementation LauncherRocket

#define PARTICLE_FREQ 10
#define REMOVE_BEHIND_BUFFER 2000

#define DEFAULT_SCALE 0.75

-(CCAction*)cons_anim:(NSArray*)a speed:(float)speed {
	CCTexture2D *texture = [Resource get_tex:TEX_CANNONTRAIL];
	NSMutableArray *animFrames = [NSMutableArray array];
    for (NSString* k in a) [animFrames addObject:[CCSpriteFrame frameWithTexture:texture rect:[FileCache get_cgrect_from_plist:TEX_CANNONTRAIL idname:k]]];
    return  [Common make_anim_frames:animFrames speed:0.1];
}

+(LauncherRocket*)cons_at:(CGPoint)pt vel:(CGPoint)vel {
    return [[LauncherRocket node] cons_at:pt vel:vel];
}

-(id)cons_at:(CGPoint)pt vel:(CGPoint)vel {
    //[self setPosition:pt];
    actual_pos = pt;
    v = vel;
    active = YES;
    remlimit = -1;
    [self setRotation:[self get_tar_angle_deg_self:pt tar:ccp(pt.x+vel.x,pt.y+vel.y)]];
    [self setScale:DEFAULT_SCALE];
    
    CCSprite *body = [CCSprite spriteWithTexture:[Resource get_tex:TEX_ENEMY_ROCKET]];
    [self addChild:body z:2];
    
    trail = [CCSprite node];
    [trail setScale:0.75];
    [trail setPosition:ccp(70,0)];
    [trail runAction:[self cons_anim:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil] speed:0.1]];
    [self addChild:trail z:1];
	
	no_vibration = NO;
    
    return self;
}

-(LauncherRocket*)no_vibration {
	no_vibration = YES;
	return self;
}

-(void)update_position {
    actual_pos.x += v.x * [Common get_dt_Scale];
    actual_pos.y += v.y * [Common get_dt_Scale];
    [self setPosition:ccp(actual_pos.x+vibration.x,actual_pos.y+vibration.y)];
}

-(id)set_remlimit:(int)t {
    remlimit = t;
    return self;
}

-(void)update_vibration {
	if (no_vibration == NO) {
		vibration_ct+=0.2;
		vibration.y = 4*sinf(vibration_ct);
	}
}

-(BOOL)is_active {
	return (broken_ct <= 0);
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
    if(shadow == NULL) {
        shadow = [ObjectShadow cons_tar:self];
        [g add_gameobject:shadow];
    }
    [self update_vibration];
    [super update:player g:g];
    [self update_position];
    
    Vec3D dv = [VecLib cons_x:v.x y:v.y z:0];
    dv =[VecLib normalize:dv];
    dv =[VecLib scale:dv by:-1];
    dv =[VecLib scale:dv by:90];
    ct++;
    ct%PARTICLE_FREQ==0?[g add_particle:[RocketLaunchParticle cons_x:position_.x+dv.x y:position_.y+dv.y vx:-v.x vy:-v.y]]:0;
    
    
    if (position_.x + REMOVE_BEHIND_BUFFER < player.position.x) {
        kill = YES;
    } else if (remlimit != -1 && ct > remlimit) {
        kill = YES;
    }
    
    if (kill || ![Common hitrect_touch:[self get_hit_rect] b:[g get_world_bounds]]) {
        [g remove_gameobject:shadow];
        [g remove_gameobject:self];
        return;
        
    } else if (broken_ct > 0) {
        [trail setVisible:NO];
        [self setOpacity:150];
        [self setRotation:self.rotation+30];
        broken_ct--;
        if (broken_ct == 0) {
            [self remove_from:g];
            return;
        }
        
    } else if (broken_ct == 0 && !player.dead && !player.dashing && player.current_island == NULL && player.vy <= 0 && [Common hitrect_touch:[self get_hit_rect] b:[player get_jump_rect]]  && !player.dead) {
        [self flyoff:ccp(player.vx,player.vy) norm:6];
        [AudioManager playsfx:SFX_BOP];
        
        [MinionRobot player_do_bop:player g:g];
        
    } else if (broken_ct == 0 && [Common hitrect_touch:[self get_hit_rect] b:[player get_hit_rect]]  && !player.dead) {
        if (player.dashing || [player is_armored]) {
            [self flyoff:ccp(player.vx,player.vy) norm:7];
            [AudioManager playsfx:SFX_ROCKBREAK];
            
        } else if (!player.dead) {
            [player add_effect:[HitEffect cons_from:[player get_default_params] time:40]];
            [DazedParticle cons_effect:g tar:player time:40];
            [self remove_from:g];
            [g.get_stats increment:GEStat_ROBOT];
            return;
        }
        
        
    }
}

-(void)flyoff:(CGPoint)pv norm:(int)norm {
    broken_ct = 35;
    Vec3D pvec = [VecLib cons_x:pv.x y:pv.y z:0];
    if (norm > 0) {
        [VecLib normalize:pvec];
        [VecLib scale:pvec by:norm];
    }
    v.x = pvec.x;
    v.y = pvec.y;
}

-(void)remove_from:(GameEngineLayer*)g {
    [AudioManager playsfx:SFX_EXPLOSION];
    [g add_particle:[ExplosionParticle cons_x:position_.x y:position_.y]];
    //[LauncherRobot explosion:g at:position_];
    [g remove_gameobject:shadow];
    [g remove_gameobject:self];
}

-(float)get_tar_angle_deg_self:(CGPoint)s tar:(CGPoint)t {
    //calc coord:       cocos2d coord:
    //+                    +
    //---0              0---
    //-                    -
    float ccwt = [Common rad_to_deg:atan2f(t.y-s.y, t.x-s.x)];
    return ccwt > 0 ? 180-ccwt : -(180-ABS(ccwt));
}

-(int)get_render_ord{ return [GameRenderImplementation GET_RENDER_PLAYER_ON_FG_ORD];}
-(void)reset{[super reset];kill = YES;}
-(void)set_active:(BOOL)t_active {active = t_active;}
-(HitRect)get_hit_rect {return [Common hitrect_cons_x1:position_.x-30 y1:position_.y-25 wid:60 hei:50];}

@end


@implementation RelativePositionLauncherRocket

+(RelativePositionLauncherRocket*)cons_at:(CGPoint)pt player:(CGPoint)player vel:(CGPoint)vel {
    return [[RelativePositionLauncherRocket node] cons_at:pt player:player vel:vel];
}

-(id)cons_at:(CGPoint)pt player:(CGPoint)player vel:(CGPoint)vel {
    player_pos = player;
    [self setPosition:pt];
    rel_pos = ccp(pt.x-player.x,0);
    v = vel;
    [self update_position];
    [self setScale:DEFAULT_SCALE];
    
    CCSprite *body = [CCSprite spriteWithTexture:[Resource get_tex:TEX_ENEMY_ROCKET]];
    [self addChild:body z:2];
    
    trail = [CCSprite node];
    [trail setScale:0.75];
    [trail setPosition:ccp(70,0)];
    [trail runAction:[self cons_anim:[NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil] speed:0.1]];
    [self addChild:trail z:1];
    
    active = YES;
    [self setRotation:[self get_tar_angle_deg_self:pt tar:ccp(pt.x+vel.x,pt.y+vel.y)]];
    return self;
}

-(void)update:(Player *)player g:(GameEngineLayer *)g {
    player_pos = player.position;
    rel_pos.x += v.x * [Common get_dt_Scale];
    [super update:player g:g];
}

-(void)update_vibration {
    vibration_ct+=0.1;
    vibration.y = sinf(vibration_ct);
}

-(void)update_position {
    //only for horizontal relative, todo: make general
    //[self setPosition:ccp(rel_pos.x+player_pos.x,position_.y+v.y)];
    actual_pos.x = rel_pos.x+player_pos.x;
    actual_pos.y = position_.y+v.y * [Common get_dt_Scale];
    [self setPosition:ccp(actual_pos.x+vibration.x,actual_pos.y+vibration.y)];
}

@end
