#import "BGLayer.h"
#import "GameEngineLayer.h"

#import "World1BGLayerSet.h"
#import "Lab1BGLayerSet.h"
#import "World2BGLayerSet.h"

@implementation BGLayerSet
-(void)set_scrollup_pct:(float)pct{}
-(void)set_day_night_color:(float)pct{}
-(void)fadeout_in:(int)ticks{}
-(void)fadein_in:(int)ticks{}
-(void)set_active:(BOOL)t{ [self setVisible:t]; }
-(void)update:(GameEngineLayer*)g curx:(float)curx cury:(float)cury{}
@end


@implementation BGLayer

+(BGLayer*)cons_with_gamelayer:(GameEngineLayer*)g {
    BGLayer *l = [BGLayer node];
    [GEventDispatcher add_listener:l];
    [l set_gameengine:g];
    [l update];
    return l;
}
-(void)set_gameengine:(GameEngineLayer*)ref { game_engine_layer = ref; }

-(id) init{
	self = [super init];
	
	bglayerset_world1 = [World1BGLayerSet cons];
	[bglayerset_world1 set_active:NO];
	[self addChild:bglayerset_world1];
	
	bglayerset_lab1 = [Lab1BGLayerSet cons];
	[bglayerset_lab1 set_active:NO];
	[self addChild:bglayerset_lab1];
	
	bglayerset_world2 = [World2BGLayerSet cons];
	[bglayerset_world2 set_active:NO];
	[self addChild:bglayerset_world2];
	
	current_set = bglayerset_world2;
	[current_set set_active:YES];
	
	return self;
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_GAME_TICK) {
        [self update];
        
    } else if (e.type == GEventType_ENTER_LABAREA) {
		[current_set set_active:NO];
		current_set = bglayerset_lab1;
		[current_set set_active:YES];
        
    } else if (e.type == GEventType_EXIT_TO_DEFAULTAREA) {
        
    } else if (e.type == GEventType_DAY_NIGHT_UPDATE) {
		[current_set set_day_night_color:e.i1];
		if ([BGTimeManager get_global_time] == MODE_NIGHT) {
			[AudioManager transition_mode2];
		}
        
    } else if (e.type == GEventType_MENU_SCROLLBGUP_PCT) {
		[current_set set_scrollup_pct:e.f1];
        
    }
}

-(void)update {    
    float posx = game_engine_layer.player.position.x;
    float posy = game_engine_layer.player.position.y;
    
    float dx = posx - lastx;
    float dy = posy - lasty;
    
    curx += dx;
    cury = MAX(0,MIN(3000,cury+dy)); //SCROLL_LIMIT
    
    lastx = posx;
    lasty = posy;
    
	[current_set update:game_engine_layer curx:curx cury:cury];
}

-(void)dealloc {
    [self removeAllChildrenWithCleanup:YES];
}

@end