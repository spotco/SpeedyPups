#import "cocos2d.h"
#import "GEventDispatcher.h"
#import "GameEngineLayer.h"

@interface FGLayer : CCLayer <GEventListener> {
	CCSprite *item;
	CGPoint pt_start,pt_end;
	
	float lastx,lasty;
	float offy;
	CGPoint actualpos;
}

+(FGLayer*)cons:(GameEngineLayer*)g;

@property(readwrite,strong) GameEngineLayer* game_engine_layer;

@end
