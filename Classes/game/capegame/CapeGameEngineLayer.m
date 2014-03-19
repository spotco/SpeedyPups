#import "CapeGameEngineLayer.h"
#import "Resource.h"
#import "FileCache.h"
#import "BackgroundObject.h"
#import "CapeGamePlayer.h"
#import "CapeGameUILayer.h"
#import "GameEngineLayer.h"
#import "UICommon.h"
#import "Common.h"

#import "CapeGameBossCat.h"

#import "OneUpParticle.h"
#import "DazedParticle.h"

@implementation CapeGameObject
-(void)update:(CapeGameEngineLayer*)g{}
@end

@implementation CapeGameEngineLayer
@synthesize is_boss_capegame;

static int lvl_ct = 0;
static NSString *blank = @"";
+(NSString*)get_level {
	NSString *rtv = blank;
	if (lvl_ct%3==0) {
		rtv = @"capegame_easy";
	} else if (lvl_ct%3==1) {
		rtv = @"capegame_creative";
	} else if (lvl_ct%3==2) {
		rtv = @"capegame_test";
	}
	lvl_ct++;
	return rtv;
}

+(CCScene*)scene_with_level:(NSString *)file g:(GameEngineLayer *)g boss:(BOOL)boss {
	CCScene *scene = [CCScene node];
	[scene addChild:[[CapeGameEngineLayer node] cons_with_level:file g:g boss:boss]];
	return scene;
}

#define GAME_DURATION 2100
#define BOSS_INFINITE_DURATION 9999
#define START_TARPOS [Common screen_pctwid:0.2 pcthei:0.5]
#define END_TARPOS [Common screen_pctwid:0.2 pcthei:-0.1]

-(id)cons_with_level:(NSString*)file g:(GameEngineLayer*)g boss:(BOOL)boss {
	is_boss_capegame = boss;
	main_game = g;
	
	bg = [BackgroundObject backgroundFromTex:[Resource get_tex:is_boss_capegame?TEX_CLOUDGAME_BOSS_BG:TEX_CLOUDGAME_BG] scrollspd_x:0.1 scrollspd_y:0];
	[bg setScaleX:[Common scale_from_default].x];
	[self addChild:bg];
	
	bgclouds = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_CLOUDGAME_BGCLOUDS] scrollspd_x:0.1 scrollspd_y:0];
	if (!is_boss_capegame) [self addChild:bgclouds];
	
	player = [CapeGamePlayer cons];
	[player setPosition:END_TARPOS];
	[self addChild:player z:2];
	
	
	top_scroll = [CCSprite spriteWithTexture:[Resource get_tex:is_boss_capegame?TEX_CLOUDGAME_BOSS_CLOUDFLOOR:TEX_CLOUDGAME_CLOUDFLOOR]];
	[top_scroll setScaleX:[Common scale_from_default].x];
	[top_scroll setScaleY:-1];
	[top_scroll setPosition:[Common screen_pctwid:0 pcthei:1]];
	bottom_scroll = [CCSprite spriteWithTexture:[Resource get_tex:is_boss_capegame?TEX_CLOUDGAME_BOSS_CLOUDFLOOR:TEX_CLOUDGAME_CLOUDFLOOR]];
	[bottom_scroll setScaleX:[Common scale_from_default].x];
	[top_scroll setAnchorPoint:ccp(0,0)];
	[bottom_scroll setAnchorPoint:ccp(0,0)];
	[top_scroll setOpacity:220];
	[bottom_scroll setOpacity:220];
	[self addChild:top_scroll z:3];
	[self addChild:bottom_scroll z:3];
	
	particleholder = [CCSprite node];
	[self addChild:particleholder z:5];
	particles = [NSMutableArray array];
	particles_tba = [NSMutableArray array];
	
	game_objects = [NSMutableArray array];
	if (is_boss_capegame) {
		[self add_gameobject:[CapeGameBossCat cons]];
		duration = BOSS_INFINITE_DURATION;
		
	} else {
		GameMap *map = [MapLoader load_capegame_map:file];
		for (CapeGameObject *o in map.game_objects) {
			[self add_gameobject:o];
		}
		[map.game_objects removeAllObjects];
		duration = GAME_DURATION;
	}
	
	ui = [CapeGameUILayer cons_g:self];
	[self addChild:ui z:4];
	
	
	self.isTouchEnabled = YES;
	[self schedule:@selector(update:)];
	
	touch_down = NO;
	initial_hold = YES;
	
	current_mode = CapeGameMode_FALLIN;
	gameobjects_tbr = [NSMutableArray array];
	
	count_as_death = NO;
	
	return self;
}

-(CapeGamePlayer*)player {
	return player;
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

-(void)add_gameobject:(CapeGameObject*)o {
    [game_objects addObject:o];
    [self addChild:o];
}

-(void)remove_gameobject:(CapeGameObject*)o {
	[gameobjects_tbr addObject:o];
}

-(void)update:(ccTime)dt {
	
	[Common set_dt:dt];
	[main_game incr_time:[Common get_dt_Scale]];
	[ui update];
	[ui update_pct:duration/GAME_DURATION];
	[[ui bones_disp] set_label:strf("%i",[main_game get_num_bones])];
	[[ui lives_disp] set_label:strf("\u00B7 %s",[main_game get_lives] == GAMEENGINE_INF_LIVES ? "\u221E":strf("%i",[main_game get_lives]).UTF8String)];
	[[ui time_disp] set_label:[UICommon parse_gameengine_time:[main_game get_time]]];
	
	[self push_added_particles];
    NSMutableArray *toremove = [NSMutableArray array];
    for (Particle *i in particles) {
        [i update:(id)self]; //don't do this at home
        if ([i should_remove]) {
            [particleholder removeChild:i cleanup:YES];
            [toremove addObject:i];
        }
    }
    [particles removeObjectsInArray:toremove];
	
	for (CapeGameObject *o in gameobjects_tbr) {
		[game_objects removeObject:o];
		[self removeChild:o cleanup:YES];
	}
	[gameobjects_tbr removeAllObjects];
	
	if (current_mode == CapeGameMode_FALLIN) {
		CGPoint tar = START_TARPOS;
		CGPoint last_pos = player.position;
		CGPoint neu_pos = ccp(
			last_pos.x + (tar.x - last_pos.x)/10.0,
			last_pos.y + (tar.y - last_pos.y)/10.0
		);
		player.vy = neu_pos.y - last_pos.y;
		[player set_rotation];
		[player setPosition:neu_pos];
		if (CGPointDist(neu_pos, tar) < 1) {
			[player setPosition:tar];
			player.vy = 0;
			current_mode = CapeGameMode_GAMEPLAY;
		}
		return;
	} else if (current_mode == CapeGameMode_FALLOUT) {
		CGPoint tar = END_TARPOS;
		player.vy -= 0.3;
		[player setPosition:CGPointAdd(player.position, ccp(player.vx,player.vy))];
		if (player.position.y < tar.y) {
			[self exit];
			
			if (count_as_death) {
				[GEventDispatcher push_unique_event:[GEvent cons_type:GEventType_PLAYER_DIE]];
			}
		}
		return;
	}
	
	if ([player is_rocket]) {
		
		[self add_particle:[[[RocketParticle cons_x:player.position.x-25 y:player.position.y+5]
							 set_vel:ccp(float_random(-8, -5),float_random(-1.5, 1.5))]
							set_scale:float_random(0.3, 0.8)]];
		
		if (!behind_catchup) {
			player.position = ccp(player.position.x+[Common get_dt_Scale] * 2,player.position.y);
			if (player.position.x > [Common SCREEN].width*1.1) {
				player.position = ccp(-50,player.position.y);
				behind_catchup = YES;
			}
		} else {
			if (player.position.x < START_TARPOS.x) {
				player.position = ccp(player.position.x+[Common get_dt_Scale]*2,player.position.y);
			} else {
				player.position = ccp(START_TARPOS.x,player.position.y);
				behind_catchup = NO;
				[player do_cape_anim];
				[AudioManager playsfx:SFX_POWERDOWN];
			}
			
		}
		
	} else if (player.position.x < START_TARPOS.x) {
		
	}
	
	
	float speed = is_boss_capegame ? 7 : (1-duration/GAME_DURATION)*6 + 4;
	
	bgclouds_scroll_x += speed;
	[bgclouds update_posx:bgclouds_scroll_x posy:0];
	if (is_boss_capegame) [bg update_posx:bgclouds_scroll_x posy:0];
	
	CGRect scroll_rect = top_scroll.textureRect;
	scroll_rect.origin.x += speed;
	scroll_rect.origin.x = ((int)(scroll_rect.origin.x))%top_scroll.texture.pixelsWide + ((scroll_rect.origin.x) - ((int)(scroll_rect.origin.x)));
	[top_scroll setTextureRect:scroll_rect];
	[bottom_scroll setTextureRect:scroll_rect];
	
	if (touch_down) {
		player.vy = MIN(player.vy + 1.6, 7);
	} else if (initial_hold) {
		player.vy = MAX(player.vy - 0.005,-7);
	} else {
		player.vy = MAX(player.vy - 0.35,-7);
	}
	CGPoint neupos = CGPointAdd(player.position, ccp(0,player.vy));
	neupos.y = clampf(neupos.y, [Common SCREEN].height*0.1, [Common SCREEN].height*0.9);
	player.position = neupos;
	[player set_rotation];
	
	for (int i = game_objects.count-1; i >= 0; i--) {
		CapeGameObject *o = game_objects[i];
		[o setPosition:CGPointAdd(ccp(-speed,0), o.position)];
		[o update:self];
	}
	
	if (duration != BOSS_INFINITE_DURATION) duration--;
	if (duration <= 0) {
		[player do_stand];
		current_mode = CapeGameMode_FALLOUT;
	}
}

-(GameEngineLayer*)get_main_game {
	return main_game;
}

-(void)do_get_hit {
	count_as_death = self.is_boss_capegame;
	[player do_hit];
	current_mode = CapeGameMode_FALLOUT;
	[DazedParticle cons_effect:self sprite:player time:40];
}

-(void)do_powerup_rocket {
	[player do_rocket];
}

-(void)collect_bone:(CGPoint)screen_pos {
	[main_game collect_bone:NO];
	[ui do_bone_collect_anim:screen_pos];
	
	if ([main_game get_challenge]==NULL && [main_game get_num_bones]%100==0) {
		OneUpParticle *p = [OneUpParticle cons_pt:player.position];
		[p setScale:0.4];
		[self add_particle:p];
		[AudioManager playsfx:SFX_1UP];
	}
}

-(void)do_tutorial_anim {
	[ui do_tutorial_anim];
}

-(void) ccTouchesBegan:(NSSet*)pTouches withEvent:(UIEvent*)pEvent {
    CGPoint touch;
    for (UITouch *t in pTouches) {
        touch = [t locationInView:[t view]];
    }
	touch_down = YES;
	initial_hold = NO;
}
-(void) ccTouchesMoved:(NSSet *)pTouches withEvent:(UIEvent *)event {    
    CGPoint touch;
    for (UITouch *t in pTouches) {
        touch = [t locationInView:[t view]];
    }
}
-(void) ccTouchesEnded:(NSSet*)pTouches withEvent:(UIEvent*)event {
    CGPoint touch;
    for (UITouch *t in pTouches) {
        touch = [t locationInView:[t view]];
    }
	touch_down = NO;
}

-(void)exit {
	[self removeAllChildrenWithCleanup:YES];
	[particles removeAllObjects];
	[ui exit];
	[[CCDirector sharedDirector] popScene];
	[AudioManager playsfx:SFX_FAIL];
}

@end
