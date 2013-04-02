#import "Player.h"
#import "PlayerEffectParams.h"
#import "GameEngineLayer.h"
#import "GameItemCommon.h"
#import "UsedItem.h"
#import "MagnetItemEffect.h"

#define IMGWID 64
#define IMGHEI 58
#define IMG_OFFSET_X -31
#define IMG_OFFSET_Y -3

#define DEFAULT_GRAVITY -0.5

#define HITBOX_RESCALE 0.7

#define TRAIL_MIN 8
#define TRAIL_MAX 15


@implementation Player
@synthesize vx,vy;
@synthesize player_img;
@synthesize current_island;
@synthesize up_vec;
@synthesize start_pt;
@synthesize last_ndir,movedir;
@synthesize floating,dashing,dead;
@synthesize current_swingvine;

@synthesize current_anim;
@synthesize _RUN_ANIM_SLOW,_RUN_ANIM_MED,_RUN_ANIM_FAST,_RUN_ANIM_NONE;
@synthesize _ROCKET_ANIM,_CAPE_ANIM,_HIT_ANIM,_SPLASH_ANIM, _DASH_ANIM, _SWING_ANIM,_FLASH_ANIM,_FLIP_ANIM;

/* static set player character */

static NSString* CURRENT_CHARACTER = TEX_DOG_RUN_1;
+(void)set_character:(NSString*)tar {
    CURRENT_CHARACTER = tar;
}
+(NSString*)get_character {
    return CURRENT_CHARACTER;
}

+(Player*)cons_at:(CGPoint)pt {
	Player *new_player = [Player node];
    [new_player reset_params];
	CCSprite *player_img = [CCSprite node];
    new_player.player_img = player_img;
    new_player.last_ndir = 1;
    new_player.movedir = 1;
    new_player.current_island = NULL;
	player_img.anchorPoint = ccp(0,0);
	player_img.position = ccp(IMG_OFFSET_X,IMG_OFFSET_Y);
	
    new_player.up_vec = [VecLib cons_x:0 y:1 z:0];
	[new_player addChild:player_img];
	
    [new_player cons_anim];
	
    new_player.start_pt = pt;
    new_player.position = new_player.start_pt;
	return new_player;
}

-(id)init {
    self = [super init];
    prevndir = 1;
    cur_scy = 1;
    inair_ct = 0;
    return self;
}

-(void)start_anim:(id)anim {
    if (current_anim == anim) {
        return;
    } else if (current_anim != NULL) {
        [player_img stopAction:current_anim];
    }
    [player_img runAction:anim];
    current_anim = anim;
}

-(void)update:(GameEngineLayer*)g {
    game_engine_layer = g;
    
    [self update_ieffects];
    
    if (current_island == NULL && current_swingvine == NULL) {
        [self mov_center_rotation];
        
    } else if (current_island != NULL) {
        [self add_running_dust_particles:g];
    }
    
    if (floating && !dead) {
        [self add_floating_particle:g];
    }
    
    player_anim_mode cur_anim_mode = [[self get_current_params] get_anim];
    
    dashing = (cur_anim_mode == player_anim_mode_DASH) || ([[self get_current_params] is_also_dashing]);
    
    if (current_swingvine != NULL) {
        [self swingvine_attach_anim];
        
    } else if (cur_anim_mode == player_anim_mode_RUN) {
        [self runanim_update];
        
    } else if (cur_anim_mode == player_anim_mode_DASH) {
        if (current_island != NULL) {
            cur_scy = last_ndir;
        } else {
            cur_scy = 1;
            self.last_ndir = 1;
        }
        [self dashanim_update:g];
        
    } else if (cur_anim_mode == player_anim_mode_CAPE) {
        [self start_anim:_CAPE_ANIM];
        
    } else if (cur_anim_mode == player_anim_mode_ROCKET) {
        if (current_island != NULL) {
            cur_scy = last_ndir;
        } else {
            cur_scy = 1;
            self.last_ndir = 1;
        }
        [self start_anim:_ROCKET_ANIM];
        [g add_particle:[RocketParticle cons_x:position_.x-40 y:position_.y+20]];
        
    } else if (cur_anim_mode == player_anim_mode_HIT) { 
        [self start_anim:_HIT_ANIM];
        
    } else if (cur_anim_mode == player_anim_mode_FLASH) {
        [self start_anim:_FLASH_ANIM];
        
    } else if (cur_anim_mode == player_anim_mode_SPLASH) {
        cur_scy = 1;
        [self start_anim:_SPLASH_ANIM];
        
    }
    [self setScaleY:cur_scy];
    [self update_params:g];
    refresh_hitrect = YES;
}

//internal effects system (for effects that should persist)
-(void)update_ieffects {
    if (new_spd_ct)new_spd_ct--;
    if (new_magnetrad_ct) {
        new_magnetrad_ct--;
        if (new_magnetrad_ct) {
            [GEventDispatcher push_event:[[[GEvent cons_type:GEventType_ITEM_DURATION_PCT] add_f1:((float)new_magnetrad_ct)/[GameItemCommon get_uselength_for:Item_Magnet] f2:0] add_i1:Item_Magnet i2:0]];
        } else {
            [self reset_magnet_ieffect];
        }
    }
}

#define DEFAULT_SPEED 7
-(int)get_speed {
    return new_spd_ct > 0 ? new_spd : DEFAULT_SPEED;
}

-(void)set_new_spd:(int)spd ct:(int)ct {
    new_spd = spd;
    new_spd_ct = ct;
}

-(void)reset_speed_ieffect {
    new_spd_ct = 0;
}

#define DEFAULT_DASH_MAGNET_RAD 150
-(void)set_magnet_rad:(int)rad ct:(int)ct {
    [self reset_magnet_ieffect];
    new_magnetrad = rad;
    new_magnetrad_ct = ct;
    [game_engine_layer add_gameobject:[MagnetItemEffect cons]];
}

-(int)get_magnet_rad {
    if (new_magnetrad_ct > 0) {
        return new_magnetrad;
    } else if (dashing) {
        return DEFAULT_DASH_MAGNET_RAD;
    } else {
        return 20;
    }
}

-(void)reset_all_ieffects {
    [self reset_magnet_ieffect];
    [self reset_speed_ieffect];
}

-(void)reset_magnet_ieffect {
    new_magnetrad_ct = 0;
    [GEventDispatcher immediate_event:[[[GEvent cons_type:GEventType_ITEM_DURATION_PCT] add_f1:0 f2:0] add_i1:Item_Magnet i2:0]];
}

-(void)mov_center_rotation {
    Vec3D dv = [VecLib cons_x:vx y:vy z:0];
    dv = [VecLib normalize:dv];
    
    float rot = -[Common rad_to_deg:[VecLib get_angle_in_rad:dv]];
    float sig = [Common sig:rot];
    rot = sig*sqrtf(ABS(rot));
    [self setRotation:rot];
    
}

-(CGPoint)get_center {
    HitRect phit = [self get_hit_rect_ignore_noclip];
    return ccp((phit.x2-phit.x1)/2+phit.x1,(phit.y2-phit.y1)/2+phit.y1);
}

-(void)add_running_dust_particles:(GameEngineLayer*)g {
    float vel = sqrtf(powf(vx,2)+powf(vy,2));
    if (vel > TRAIL_MIN) {
        float ch = (vel-TRAIL_MIN)/(TRAIL_MAX - TRAIL_MIN)*100;
        if (arc4random_uniform(100) < ch) {
            Vec3D dv = [current_island get_tangent_vec];
            dv=[VecLib normalize:dv];
            dv=[VecLib scale:dv by:-2.5];
            dv.x += float_random(-3, 3);
            dv.y += float_random(-3, 3);
            [g add_particle:[StreamParticle cons_x:position_.x y:position_.y vx:dv.x vy:dv.y]];
        }
    }
}

-(void)add_floating_particle:(GameEngineLayer*)g {
    if (particlectr >= 10) {
        particlectr = 0;
        float pvx;
        if (arc4random_uniform(2) == 0) {
            pvx = float_random(4, 6);
        } else {
            pvx = float_random(-4, -6);
        }
        [g add_particle:[FloatingSweatParticle cons_x:position_.x+6 y:position_.y+29 vx:pvx+vx vy:float_random(3, 6)+vy]];
    } else {
        particlectr++;
    }
}

-(void)swingvine_attach_anim {
    //smoothing anim for swingvine attach, see swingvine update (does not force rotation until curanim is _SWING_ANIM
    if (![Common fuzzyeq_a:rotation_ b:-90 delta:1]) {
        float dir = [Common shortest_dist_from_cur:rotation_ to:-90]*0.8;
        self.rotation += dir;
    } else {
        [self start_anim:_SWING_ANIM];
    }
}

-(void)runanim_update {
    if (self.last_ndir != prevndir && self.last_ndir < 0) { //if land on reverse, start flip
        flipctr = 10;
    } else if (flipctr <= 0 && self.current_island == NULL && cur_scy < 0) {//if jump from reverse, startflip
        flipctr = 10;
    }
    prevndir = self.last_ndir;
    
    if (flipctr > 0) {
        cur_scy = last_ndir;
        flipctr--;
        [self start_anim:_FLIP_ANIM];
        
        if (flipctr == 0 && self.current_island == NULL && cur_scy < 0) { //finish jump from reverse flip
            cur_scy = 1;
        }
        
    } else if (current_island == NULL) {
        cur_scy = 1;
        if (floating) {
            [self start_anim:_RUN_ANIM_FAST];
        } else {
            [self start_anim:_RUN_ANIM_NONE];
        }
        
    } else {
        last_ndir = current_island.ndir;
        cur_scy = last_ndir;
        
        float vel = sqrtf(powf(vx,2)+powf(vy,2));
        if (vel > 10) {
            [self start_anim:_RUN_ANIM_FAST];
        } else if (vel > 5) {
            [self start_anim:_RUN_ANIM_MED];
        } else {
            [self start_anim:_RUN_ANIM_SLOW];
        }
    }
}

-(void)dashanim_update:(GameEngineLayer*)g {
    [self start_anim:_DASH_ANIM];
    
    if (particlectr >= 5) {
        particlectr = 0;
        Vec3D dv = [VecLib cons_x:vx y:vy z:0];
        Vec3D normal = [VecLib cross:[VecLib Z_VEC] with:dv];
        normal = [VecLib normalize:normal];
        dv = [VecLib normalize:dv];
        
        normal = [VecLib scale:normal by:35];
        float x = position_.x+normal.x;
        float y = position_.y+normal.y;
        
        normal = [VecLib normalize:normal];
        normal = [VecLib scale:normal by:float_random(-4, 4)];
        dv = [VecLib scale:dv by:float_random(-8, -10)];
        
        JumpPadParticle* pt = [JumpPadParticle cons_x:x y:y vx:dv.x+normal.x vy:dv.y+normal.y];
        [g add_particle:pt];
        
    } else {
        particlectr++;
    }
}

-(void)update_params:(GameEngineLayer*)g {
    if (temp_params != NULL) {
        [temp_params update:self g:g];
        [temp_params decrement_timer];
        if (temp_params.time_left == 0) {
            [temp_params effect_end];
            temp_params = NULL;
        }
    }
}

/* playerparam system */

-(PlayerEffectParams*) get_current_params {
    if (temp_params != NULL) {
        return temp_params;
    } else {
        return current_params;
    }
}
-(PlayerEffectParams*) get_default_params {
    return current_params;
}
-(void) reset {
    position_ = start_pt;
    current_island = NULL;
    up_vec = [VecLib cons_x:0 y:1 z:0];
    vx = 0;
    vy = 0;
    rotation_ = 0;
    last_ndir = 1;
    floating = NO;
    dashing = NO;
    dead = NO;
    current_swingvine = NULL;
    [self reset_all_ieffects];
    [self reset_params];
}
-(void) reset_params {
    if (temp_params != NULL) {
        [temp_params effect_end];
        temp_params = NULL;
    }
    if (current_params != NULL) {
        [current_params effect_end];
        current_params = NULL;
    }
    current_params = [[PlayerEffectParams alloc] init];
    current_params.cur_gravity = DEFAULT_GRAVITY;
    current_params.cur_airjump_count = 1;
    current_params.cur_dash_count = 1;
    current_params.time_left = -1;
}
-(void)add_effect:(PlayerEffectParams*)effect {
    if (temp_params != NULL) {
        if (game_engine_layer != NULL) {
            [temp_params effect_end];
        }
        temp_params = NULL;
    }
    temp_params = effect;
    [temp_params effect_begin:self];
}

-(void)add_effect_suppress_current_end_effect:(PlayerEffectParams *)effect {
    if (temp_params != NULL) {
        temp_params = NULL;
    }
    temp_params = effect;
    [temp_params effect_begin:self];
}

-(void)remove_temp_params:(GameEngineLayer*)g {
    if (temp_params != NULL) {
        [temp_params effect_end];
        temp_params = NULL;
    }
}

-(HitRect) get_hit_rect_ignore_noclip {
    PlayerEffectParams *cur = [self get_current_params];
    int cur_nc = cur.noclip;
    cur.noclip = 0;
    HitRect gets = [self get_hit_rect];
    cur.noclip = cur_nc;
    return gets;
}

-(HitRect)get_jump_rect {
    return [Common hitrect_cons_x1:position_.x-25 y1:position_.y wid:50 hei:4];
}

BOOL refresh_hitrect = YES;
HitRect cached_rect;
-(HitRect) get_hit_rect {
    if ([self get_current_params].noclip) {
        return [Common hitrect_cons_x1:0 y1:0 wid:0 hei:0];
    } else if (refresh_hitrect == NO) {
        return cached_rect;
    }
    
    Vec3D v = [VecLib cons_x:up_vec.x y:up_vec.y z:0];
    Vec3D h = [VecLib cross:v with:[VecLib Z_VEC]];
    float x = self.position.x;
    float y = self.position.y;
    h=[VecLib normalize:h];
    v=[VecLib normalize:v];
    h=[VecLib scale:h by:IMGWID/2 * HITBOX_RESCALE];
    v=[VecLib scale:v by:IMGHEI * HITBOX_RESCALE];

    CGPoint pts[4];
    pts[0] = ccp(x-h.x , y-h.y);
    pts[1] = ccp(x+h.x , y+h.y);
    pts[2] = ccp(x-h.x+v.x , y-h.y+v.y);
    pts[3] = ccp(x+h.x+v.x , y+h.y+v.y);
    
    float x1 = pts[0].x;
    float y1 = pts[0].y;
    float x2 = pts[0].x;
    float y2 = pts[0].y;

    for (int i = 0; i < 4; i++) {
        x1 = MIN(pts[i].x,x1);
        y1 = MIN(pts[i].y,y1);
        x2 = MAX(pts[i].x,x2);
        y2 = MAX(pts[i].y,y2);
    }
    
    refresh_hitrect = NO;
    cached_rect = [Common hitrect_cons_x1:x1 y1:y1 x2:x2 y2:y2];
    return cached_rect;
}

/* animation cfgs */

-(NSArray*)get_run_animstr {
    NSMutableArray *run = [NSMutableArray array];
    for(int i = 0; i < 5; i++) {
        [run addObject:@"run_0"];[run addObject:@"run_1"];[run addObject:@"run_2"];[run addObject:@"run_3"];
    }
    [run addObject:@"run_blink"];[run addObject:@"run_1"];[run addObject:@"run_2"];[run addObject:@"run_3"];
    return run;
}

-(void)do_run_anim {
    [self start_anim:_RUN_ANIM_FAST];
}

-(void)do_stand_anim {
    [self start_anim:_RUN_ANIM_NONE];
}

-(void)cons_anim {
	NSArray *run = [self get_run_animstr];
    _RUN_ANIM_SLOW = [self cons_anim_repeat_texstr:CURRENT_CHARACTER speed:0.075 frames:run];
    _RUN_ANIM_MED = [self cons_anim_repeat_texstr:CURRENT_CHARACTER speed:0.06 frames:run];
    _RUN_ANIM_FAST = [self cons_anim_repeat_texstr:CURRENT_CHARACTER speed:0.05 frames:run];
    _RUN_ANIM_NONE = [self cons_anim_repeat_texstr:CURRENT_CHARACTER speed:0.075 frames:[NSArray arrayWithObjects:@"run_0",nil]];
    _ROCKET_ANIM = [self cons_anim_repeat_texstr:CURRENT_CHARACTER speed:0.1 frames:[NSArray arrayWithObjects:@"rocket_0",@"rocket_1",@"rocket_2",nil]];
    _CAPE_ANIM = [self cons_anim_repeat_texstr:CURRENT_CHARACTER speed:0.1 frames:[NSArray arrayWithObjects:@"cape_0",@"cape_1",@"cape_2",@"cape_3",nil]];
    _HIT_ANIM = [self cons_anim_once_texstr:CURRENT_CHARACTER speed:0.1 frames:[NSArray arrayWithObjects:@"hit_1",@"hit_2",@"hit_3",nil]];
    _SPLASH_ANIM = [self cons_anim_once_texstr:TEX_DOG_SPLASH speed:0.1 frames:[NSArray arrayWithObjects:@"splash1",@"splash2",@"splash3",@"",nil]];
    _DASH_ANIM = [self cons_anim_repeat_texstr:CURRENT_CHARACTER speed:0.05 frames:[NSArray arrayWithObjects:@"roll_0",@"roll_1",@"roll_2",@"roll_3",nil]];
    _SWING_ANIM = [self cons_anim_repeat_texstr:CURRENT_CHARACTER speed:1 frames:[NSArray arrayWithObjects:@"swing_0",nil]];
    _FLASH_ANIM = [self cons_anim_repeat_texstr:CURRENT_CHARACTER speed:0.1 frames:[NSArray arrayWithObjects:@"hit_0",@"hit_0_flash",nil]];
    
    _FLIP_ANIM = [self cons_anim_once_texstr:CURRENT_CHARACTER speed:0.025 frames:[NSArray arrayWithObjects:@"flip_4",@"flip_3",@"flip_2",@"flip_1",@"flip_0",nil]];
    [self start_anim:_RUN_ANIM_NONE];
}

-(id)cons_anim_repeat_texstr:(NSString*)texkey speed:(float)speed frames:(NSArray*)a {
    NSArray *animFrames = [self cons_texstr:texkey framestrs:a];
    return [Common make_anim_frames:animFrames speed:speed];
}
-(id)cons_anim_once_texstr:(NSString*)texkey speed:(float)speed frames:(NSArray*)a {
    NSArray *animFrames = [self cons_texstr:texkey framestrs:a];
    id anim = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:animFrames delay:speed] restoreOriginalFrame:NO];
    return anim;
}
-(NSArray*)cons_texstr:(NSString*)tar framestrs:(NSArray*)a {
    NSMutableArray* animFrames = [NSMutableArray array];
    for (NSString* key in a) {
        [animFrames addObject:[CCSpriteFrame frameWithTexture:[Resource get_tex:tar]
                                                         rect:[FileCache get_cgrect_from_plist:tar idname:key]]];
    }
    return animFrames;
}

-(void)setColor:(ccColor3B)color {
    [super setColor:color];
	for(CCSprite *sprite in [self children]) {
        [sprite setColor:color];
	}
}
- (void)setOpacity:(GLubyte)opacity {
	[super setOpacity:opacity];
	for(CCSprite *sprite in [self children]) {
		sprite.opacity = opacity;
	}
}

-(void)dealloc {
    [self cleanup_anims];
    [self removeAllChildrenWithCleanup:YES];
}
-(void)cleanup_anims {
    [player_img stopAction:current_anim]; 
    [self removeAllChildrenWithCleanup:YES];
}

@end
