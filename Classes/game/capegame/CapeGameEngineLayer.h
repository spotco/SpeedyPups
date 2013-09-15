#import "cocos2d.h"

@class BackgroundObject;
@class CapeGamePlayer;
@class CapeGameUILayer;
@class GameEngineLayer;

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
	
	BOOL touch_down;
	BOOL initial_hold;
	
	int duration;
	CapeGameMode current_mode;
}

+(CCScene*)scene_with_level:(NSString*)file g:(GameEngineLayer*)g;
-(GameEngineLayer*)get_main_game;
-(CapeGamePlayer*)player;

-(void)collect_bone;
@end

@interface CapeGameObject : CCSprite
-(void)update:(CapeGameEngineLayer*)g;
@end
