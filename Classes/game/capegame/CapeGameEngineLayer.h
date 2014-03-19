#import "cocos2d.h"

@class BackgroundObject;
@class CapeGamePlayer;
@class CapeGameUILayer;
@class GameEngineLayer;
@class Particle;

@class CapeGameObject;

typedef enum {
	CapeGameMode_FALLIN,
	CapeGameMode_GAMEPLAY,
	CapeGameMode_FALLOUT
} CapeGameMode;

@interface CapeGameEngineLayer : CCLayer {
	CCSprite *top_scroll, *bottom_scroll;
	CapeGamePlayer *player;
	CapeGameUILayer *ui;
	
	GameEngineLayer* __unsafe_unretained main_game;
	
	NSMutableArray *game_objects;
	NSMutableArray *gameobjects_tbr;
	
	CCSprite *particleholder;
	NSMutableArray *particles;
	NSMutableArray *particles_tba;
	
	BOOL touch_down;
	BOOL initial_hold;
	
	int duration;
	CapeGameMode current_mode;
	
	BackgroundObject *bg;
	BackgroundObject *bgclouds;
	float bgclouds_scroll_x;
	
	BOOL count_as_death;
	BOOL behind_catchup;
}
@property(readwrite,assign) BOOL is_boss_capegame;

+(NSString*)get_level;

+(CCScene*)scene_with_level:(NSString*)file g:(GameEngineLayer*)g boss:(BOOL)boss;
-(GameEngineLayer*)get_main_game;
-(CapeGamePlayer*)player;

-(void)add_particle:(Particle*)p;

-(void)collect_bone:(CGPoint)screen_pos;
-(void)do_get_hit;
-(void)do_powerup_rocket;
-(void)do_tutorial_anim;

-(void)add_gameobject:(CapeGameObject*)o;
-(void)remove_gameobject:(CapeGameObject*)o;

@end

@interface CapeGameObject : CCSprite
-(void)update:(CapeGameEngineLayer*)g;
@end
