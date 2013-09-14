#import "cocos2d.h"

@class BackgroundObject;
@class CapeGamePlayer;

@interface CapeGameEngineLayer : CCLayer {
	CCSprite *top_scroll, *bottom_scroll;
	CapeGamePlayer *player;
	
	BOOL touch_down;
}

+(CCScene*)scene_with_level:(NSString*)file;

@end
