#import "cocos2d.h"
#import "Resource.h"
#import "BackgroundObject.h"
#import "LabBGObject.h"
#import "CloudGenerator.h"
#import "BGTimeManager.h"
#import "GameEngineLayer.h"
#import "GameMain.h"
#import "GEventDispatcher.h"


@interface BGLayer : CCLayer <GEventListener> {
	NSMutableArray *normal_bg_elements;
    NSMutableArray *lab_bg_elements;
    
    NSMutableArray *all_objsets;
    
    int fadectr;
    NSMutableArray *visible_set;
    
    GameEngineLayer* __unsafe_unretained game_engine_layer;
    
    float lastx,lasty, curx,cury;
    
    CCSprite* starsbg;
}

+(BGLayer*)cons_with_gamelayer:(GameEngineLayer*)g;
-(void)set_gameengine:(GameEngineLayer*)ref;

@end
