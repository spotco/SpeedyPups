#import "cocos2d.h"

@class BackgroundObject;
@class CapeGamePlayer;
@class CapeGameUILayer;
@class GameEngineLayer;
@class Particle;

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
	
	CCSprite *particleholder;
	NSMutableArray *particles;
	NSMutableArray *particles_tba;
	
	BOOL touch_down;
	BOOL initial_hold;
	
	int duration;
	CapeGameMode current_mode;
}

+(NSString*)get_level;

+(CCScene*)scene_with_level:(NSString*)file g:(GameEngineLayer*)g;
-(GameEngineLayer*)get_main_game;
-(CapeGamePlayer*)player;

-(void)add_particle:(Particle*)p;

-(void)collect_bone:(CGPoint)screen_pos;
-(void)do_get_hit;
-(void)do_tutorial_anim;
@end

@interface CapeGameObject : CCSprite
-(void)update:(CapeGameEngineLayer*)g;
@end
