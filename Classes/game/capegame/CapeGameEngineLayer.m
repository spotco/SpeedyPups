#import "CapeGameEngineLayer.h"
#import "Resource.h"
#import "FileCache.h"
#import "BackgroundObject.h"
#import "CapeGamePlayer.h"
#import "CapeGameUILayer.h"
#import "GameEngineLayer.h"
#import "UICommon.h"
#import "Common.h"

@implementation CapeGameObject
-(void)update:(CapeGameEngineLayer*)g{}
@end

@implementation CapeGameEngineLayer

+(CCScene*)scene_with_level:(NSString *)file g:(GameEngineLayer *)g {
	CCScene *scene = [CCScene node];
	[scene addChild:[[CapeGameEngineLayer node] cons_with_level:file g:g]];
	return scene;
}

#define GAME_DURATION 2000.0
#define START_TARPOS [Common screen_pctwid:0.2 pcthei:0.5]
#define END_TARPOS [Common screen_pctwid:0.2 pcthei:-0.1]

-(id)cons_with_level:(NSString*)file g:(GameEngineLayer*)g {
	
	main_game = g;
	
	[self addChild:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_SKY] scrollspd_x:0 scrollspd_y:0]];
	
	player = [CapeGamePlayer cons];
	[player setPosition:END_TARPOS];
	[self addChild:player z:2];
	
	
	top_scroll = [CCSprite spriteWithTexture:[Resource get_tex:TEX_CLOUDGAME_CLOUDFLOOR]];
	[top_scroll setScaleY:-1];
	[top_scroll setPosition:[Common screen_pctwid:0 pcthei:1]];
	bottom_scroll = [CCSprite spriteWithTexture:[Resource get_tex:TEX_CLOUDGAME_CLOUDFLOOR]];
	[top_scroll setAnchorPoint:ccp(0,0)];
	[bottom_scroll setAnchorPoint:ccp(0,0)];
	[top_scroll setOpacity:220];
	[bottom_scroll setOpacity:220];
	[self addChild:top_scroll z:3];
	[self addChild:bottom_scroll z:3];
	
	game_objects = [NSMutableArray array];
	GameMap *map = [MapLoader load_capegame_map:file];
	for (CapeGameObject *o in map.game_objects) {
		[game_objects addObject:o];
		[self addChild:o];
	}
	[map.game_objects removeAllObjects];
	
	ui = [CapeGameUILayer cons_g:self];
	[self addChild:ui z:4];
	
	
	self.isTouchEnabled = YES;
	[self schedule:@selector(update:)];
	
	touch_down = NO;
	initial_hold = YES;
	
	duration = GAME_DURATION;
	current_mode = CapeGameMode_FALLIN;
	
	return self;
}

-(CapeGamePlayer*)player {
	return player;
}

-(void)update:(ccTime)dt {
	[Common set_dt:dt];
	[main_game incr_time:[Common get_dt_Scale]];
	[ui update];
	[ui update_pct:duration/GAME_DURATION];
	[[ui bones_disp] set_label:strf("%i",[main_game get_num_bones])];
	[[ui lives_disp] set_label:strf("\u00B7 %s",[main_game get_lives] == GAMEENGINE_INF_LIVES ? "\u221E":strf("%i",[main_game get_lives]).UTF8String)];
	[[ui time_disp] set_label:[UICommon parse_gameengine_time:[main_game get_time]]];
	
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
			[[CCDirector sharedDirector] popScene];
		}
		return;
	}
	
	float speed = (1-duration/GAME_DURATION)*6 + 4;
	
	CGRect scroll_rect = top_scroll.textureRect;
	scroll_rect.origin.x += speed;
	scroll_rect.origin.x = ((int)(scroll_rect.origin.x))%top_scroll.texture.pixelsWide + ((scroll_rect.origin.x) - ((int)(scroll_rect.origin.x)));
	[top_scroll setTextureRect:scroll_rect];
	[bottom_scroll setTextureRect:scroll_rect];
	
	if (touch_down) {
		player.vy = MIN(player.vy + 2, 7);
	} else if (initial_hold) {
		player.vy = MAX(player.vy - 0.005,-7);
	} else {
		player.vy = MAX(player.vy - 0.35,-7);
	}
	CGPoint neupos = CGPointAdd(player.position, ccp(0,player.vy));
	neupos.y = clampf(neupos.y, [Common SCREEN].height*0.1, [Common SCREEN].height*0.9);
	player.position = neupos;
	[player set_rotation];
	
	for (CapeGameObject *o in game_objects) {
		[o setPosition:CGPointAdd(ccp(-speed,0), o.position)];
		[o update:self];
	}
	
	duration--;
	if (duration <= 0) {
		[player do_stand];
		current_mode = CapeGameMode_FALLOUT;
	}
}

-(GameEngineLayer*)get_main_game {
	return main_game;
}

-(void)do_get_hit {
	[player do_hit];
	[ui update_pct:0];
	current_mode = CapeGameMode_FALLOUT;
}

-(void)collect_bone:(CGPoint)screen_pos {
	[main_game collect_bone];
	[ui do_bone_collect_anim:screen_pos];
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

@end
