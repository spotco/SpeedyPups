#import "cocos2d.h"
#import "Resource.h"
#import "BackgroundObject.h"
#import "LabBGObject.h"
#import "CloudGenerator.h"
#import "BGTimeManager.h"
#import "GameEngineLayer.h"
#import "GameMain.h"
#import "GEventDispatcher.h"

@class World1BGLayerSet;
@class Lab1BGLayerSet;
@class World2BGLayerSet;

@interface BGLayerSet: CCNode
-(void)set_scrollup_pct:(float)pct;
-(void)set_day_night_color:(float)pct;
-(void)fadeout_in:(int)ticks;
-(void)fadein_in:(int)ticks;
-(void)set_active:(BOOL)t;
-(void)update:(GameEngineLayer*)g curx:(float)curx cury:(float)cury;
@end


@interface BGLayer : CCLayer <GEventListener> {	
	World1BGLayerSet *bglayerset_world1;
	Lab1BGLayerSet *bglayerset_lab1;
	World2BGLayerSet *bglayerset_world2;
	
	BGLayerSet *current_set;
    
    GameEngineLayer* __unsafe_unretained game_engine_layer;
    
    float lastx,lasty, curx,cury;
    
    
}

+(BGLayer*)cons_with_gamelayer:(GameEngineLayer*)g;

@end
