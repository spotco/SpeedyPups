#import "BGLayer.h"
#import "GameEngineLayer.h"

#import "World1BGLayerSet.h"
#import "Lab1BGLayerSet.h"
#import "World2BGLayerSet.h"
#import "Lab2BGLayerSet.h"
#import "World3BGLayerSet.h"
#import "Lab3BGLayerSet.h"

@implementation BGLayerSet
-(void)set_scrollup_pct:(float)pct{}
-(void)set_day_night_color:(float)pct{}
-(void)update:(GameEngineLayer*)g curx:(float)curx cury:(float)cury{}

-(void)fadeout_in:(int)ticks{
	fadein_ct = 0;
	fadeout_ct = ticks;
	ct = ticks;
	[self setVisible:YES];
	[self set_opacity:1];
}
-(void)fadein_in:(int)ticks{
	fadein_ct = ticks;
	fadeout_ct = 0;
	ct = ticks;
	[self setVisible:YES];
	[self set_opacity:0];
}
-(void)update_fadeout{
	if (fadein_ct > 0) {
		ct--;
		[self set_opacity:1-ct/((float)fadein_ct)];
		if (ct == 0) {
			fadein_ct = 0;
		}
		
	} else if (fadeout_ct > 0) {
		ct--;
		[self set_opacity:ct/((float)fadeout_ct)];
		if (ct == 0) {
			[self setVisible:NO];
			fadeout_ct = 0;
		}
	}
}
-(void)set_opacity:(float)pct {
	for (CCSprite *c in self.children) {
		[c setOpacity:pct*255];
	}
}
@end


@implementation BGLayer

+(BGLayer*)cons_with_gamelayer:(GameEngineLayer*)g {
    BGLayer *l = [[BGLayer node] cons_with:g];
    [GEventDispatcher add_listener:l];
    [l update];
    return l;
}

-(void)bglayer_addChild:(CCNode*)node {
	if ([GameMain GET_USE_BG]) {
		[self addChild:node];
	}
}

-(id) cons_with:(GameEngineLayer*)ref {
	game_engine_layer = ref;
	
	bglayerset_world1 = [World1BGLayerSet cons]; 
	[bglayerset_world1 setVisible:NO];
	[self bglayer_addChild:bglayerset_world1];
	
	bglayerset_lab1 = [Lab1BGLayerSet cons];
	[bglayerset_lab1 setVisible:NO];
	[self bglayer_addChild:bglayerset_lab1];
	
	bglayerset_world2 = [World2BGLayerSet cons];
	[bglayerset_world2 setVisible:NO];
	[self bglayer_addChild:bglayerset_world2];
	
	bglayerset_lab2 = [Lab2BGLayerSet cons];
	[bglayerset_lab2 setVisible:NO];
	[self bglayer_addChild:bglayerset_lab2];
	
	bglayerset_world3 = [World3BGLayerSet cons];
	[bglayerset_world3 setVisible:NO];
	[self bglayer_addChild:bglayerset_world3];
	
	bglayerset_lab3 = [Lab3BGLayerSet cons];
	[bglayerset_lab3 setVisible:NO];
	[self bglayer_addChild:bglayerset_lab3];
	
	current_set = [self set_for_world:[GameWorldMode get_worldnum]];
	[current_set setVisible:YES];
	
	return self;
}

-(BGLayerSet*)set_for_world:(WorldNum)worldnum {
	if (worldnum == WorldNum_1) {
		return bglayerset_world1;
		
	} else if (worldnum == WorldNum_2) {
		return bglayerset_world2;
		
	} else if (worldnum == WorldNum_3) {
		return bglayerset_world3;
		
	} else {
		NSLog(@"bglayerset::set_for_world:error");
		return NULL;
	}
}

-(BGLayerSet*)set_for_lab:(LabNum)labnum {
	if (labnum == LabNum_1) {
		return bglayerset_lab1;
		
	} else if (labnum == LabNum_2) {
		return bglayerset_lab2;
		
	} else if (labnum == LabNum_3) {
		return bglayerset_lab3;
	} else {
		NSLog(@"bglayerset::set_for_lab::error");
		return NULL;
	}
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_GAME_TICK) {
        [self update];
        
    } else if (e.type == GEventType_ENTER_LABAREA) {
		[current_set fadeout_in:10];
		current_set = [self set_for_lab:[GameWorldMode get_labnum]];
		[current_set fadein_in:10];
        
    } else if (e.type == GEventType_EXIT_TO_DEFAULTAREA) {
		[current_set fadeout_in:10];
		current_set = [self set_for_world:[GameWorldMode get_worldnum]];
		[current_set fadein_in:10];
        
    } else if (e.type == GEventType_DAY_NIGHT_UPDATE) {
		[current_set set_day_night_color:e.i1];
		if ([BGTimeManager get_global_time] == MODE_NIGHT) {
			[AudioManager transition_mode2];
		}
        
    } else if (e.type == GEventType_MENU_SCROLLBGUP_PCT) {
		[current_set set_scrollup_pct:e.f1];
        
    } else if (e.type == GEventType_BOSS2_ACTIVATE) {
		[((Lab2BGLayerSet*)bglayerset_lab2) do_sink_anim];
		
	} else if (e.type == GEventType_PLAYER_DIE) {
		[((Lab2BGLayerSet*)bglayerset_lab2) reset];
		
	}
}

-(SubBossBGObject*)get_subboss_bgobject {
	return [((Lab2BGLayerSet*)bglayerset_lab2) get_subboss_bgobject];
}

-(void)update {    
    float posx = game_engine_layer.player.position.x;
    float posy = game_engine_layer.player.position.y;
	//float posy = clampf(game_engine_layer.player.position.y, game_engine_layer.get_follow_clamp_y_range.min, game_engine_layer.get_follow_clamp_y_range.max);
    
    float dx = posx - lastx;
    float dy = posy - lasty;
    
    curx += dx;
    cury = MAX(0,MIN(3000,cury+dy)); //SCROLL_LIMIT
    
    lastx = posx;
    lasty = posy;
    
	[current_set update:game_engine_layer curx:curx cury:cury];
	for (BGLayerSet *b in ALL_SETS) {
		[b update_fadeout];
	}
}

-(void)dealloc {
    [self removeAllChildrenWithCleanup:YES];
}

@end