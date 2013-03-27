
#import "BGLayer.h"
#import "GameEngineLayer.h"


@implementation BGLayer


+(BGLayer*)cons_with_gamelayer:(GameEngineLayer*)g {
    BGLayer *l = [BGLayer node];
    [GEventDispatcher add_listener:l];
    [l set_gameengine:g];
    [l update];
    return l;
}

-(id) init{
	if( (self = [super init])) {
        
        all_objsets = [[NSMutableArray alloc] init];
        
		normal_bg_elements = [self load_normal_bg];
        for (BackgroundObject* i in normal_bg_elements) {
			[self addChild:i];
		}
        
        lab_bg_elements = [self load_lab_bg];
        for (BackgroundObject* i in lab_bg_elements) {
			[self addChild:i];
            [i setVisible:NO];
		}
        
        [all_objsets addObject:normal_bg_elements];
        [all_objsets addObject:lab_bg_elements];
	}
	return self;
}

-(void)set_gameengine:(GameEngineLayer*)ref {
    game_engine_layer = ref;
}

-(NSMutableArray*) load_lab_bg {
    NSMutableArray *a = [[NSMutableArray alloc] init];
    if ([GameMain GET_USE_BG]) {
        [a addObject:[LabBGObject cons]];
    }
    
    return a;
}


-(NSMutableArray*) load_normal_bg {
	NSMutableArray *a = [[NSMutableArray alloc] init];
    starsbg = [BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_STARS] scrollspd_x:0 scrollspd_y:0];
    [starsbg setOpacity:0];
    if ([GameMain GET_USE_BG]) {
        [a addObject:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_SKY] scrollspd_x:0 scrollspd_y:0]];
        [a addObject:starsbg];
        [a addObject:[BGTimeManager cons]];
        [a addObject:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_LAYER_3] scrollspd_x:0.025 scrollspd_y:0.005]];
        [a addObject:[CloudGenerator cons]];
        [a addObject:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_LAYER_2] scrollspd_x:0.075 scrollspd_y:0.015]];
        [a addObject:[BackgroundObject backgroundFromTex:[Resource get_tex:TEX_BG_LAYER_1] scrollspd_x:0.1 scrollspd_y:0.03]];
        
    }
    return a;
}

static const float FADECTR_MAX = 10;

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_GAME_TICK) {
        [self update];
        
    } else if (e.type == GEventType_ENTER_LABAREA) {
        visible_set = lab_bg_elements;
        [self set_visible_objset:visible_set tar:YES];
        [self set_opacity_objset:visible_set tar:255];
        fadectr = FADECTR_MAX;
        
    } else if (e.type == GEventType_EXIT_TO_DEFAULTAREA) {
        visible_set = normal_bg_elements;
        [self set_visible_objset:visible_set tar:YES];
        [self set_opacity_objset:visible_set tar:255];
        fadectr = FADECTR_MAX;
        
    } else if (e.type == GEventType_GAME_RESET) {
        /*[self set_visible_objset:lab_bg_elements tar:NO];
        visible_set = normal_bg_elements;
        [self set_visible_objset:visible_set tar:YES];
        [self set_opacity_objset:visible_set tar:255];
        fadectr = 0;*/
        //TODO--lab bg fade out when reset?
        
    } else if (e.type == GEventType_DAY_NIGHT_UPDATE) {
        [self set_day_night_color:e.i1];
        
    } else if (e.type == GEventType_MENU_SCROLLBGUP_PCT) {
        [self scrollup_bg_pct:e.f1];
        
    }
}

#define SCROLL_LIMIT 3000.0

-(void)update {
    if (fadectr > 0) {
        fadectr--;
        if (fadectr == 0) {
            for (NSMutableArray* a in all_objsets) {
                if (a != visible_set) {
                    [self set_visible_objset:a tar:NO];
                }
            }
            
        } else {
            for (NSMutableArray* a in all_objsets) {
                if (a != visible_set) {
                    [self set_opacity_objset:a tar:(fadectr/FADECTR_MAX)*255];
                } else {
                    [self set_opacity_objset:a tar:255 - (fadectr/FADECTR_MAX)*100];
                }
            }
        }
    }
    
    float posx = game_engine_layer.player.position.x;
    float posy = game_engine_layer.player.position.y;
    
    float dx = posx - lastx;
    float dy = posy - lasty;
    
    curx += dx;
    cury = MAX(0,MIN(SCROLL_LIMIT,cury+dy));
    
    lastx = posx;
    lasty = posy;
    
	[self update_objset:normal_bg_elements];
    [self update_objset:lab_bg_elements];
}

-(void)update_objset:(NSMutableArray*)a {
	for (BackgroundObject* s in a) {
        [s update_posx:curx posy:cury];
	}
}

-(void)set_visible_objset:(NSMutableArray*)a tar:(BOOL)t {
	for (BackgroundObject* s in a) {
        [s setVisible:t];
	}
}

-(void)set_opacity_objset:(NSMutableArray*)a tar:(int)t {
    for (BackgroundObject* s in a) {
        [s setOpacity:t];
    }
}



-(void)dealloc {
    [all_objsets removeAllObjects];
    [self removeAllChildrenWithCleanup:YES];
    [normal_bg_elements removeAllObjects];
    [lab_bg_elements removeAllObjects];
}


#define iSKY 0
#define iBACKHILL 3
#define iCLOUD 4
#define iTREEHILL 5
#define iFRNTHILL 6

-(void)scrollup_bg_pct:(float)pct {
    if (![GameMain GET_USE_BG])return;
    [[self bgo_at:iCLOUD] setPosition:ccp([self bgo_at:iCLOUD].position.x,-400*pct)];
    [[self bgo_at:iBACKHILL] setPosition:ccp([self bgo_at:iBACKHILL].position.x,[self bgo_at:iBACKHILL].position.y-500*pct)];
    [[self bgo_at:iTREEHILL] setPosition:ccp([self bgo_at:iTREEHILL].position.x,[self bgo_at:iTREEHILL].position.y-600*pct)];
    [[self bgo_at:iFRNTHILL] setPosition:ccp([self bgo_at:iFRNTHILL].position.x,[self bgo_at:iFRNTHILL].position.y-800*pct)];
}

-(BackgroundObject*)bgo_at:(int)i {return [normal_bg_elements objectAtIndex:i];}

//day is 100, night is 0
-(void)set_day_night_color:(int)val {
    if (![GameMain GET_USE_BG])return;
    float pctm = ((float)val) / 100;
    [[self bgo_at:iSKY] setColor:ccc3(pb(20,pctm),pb(20,pctm),pb(60,pctm))];
    [[self bgo_at:iCLOUD] setColor:ccc3(pb(150,pctm),pb(150,pctm),pb(190,pctm))];
    [[self bgo_at:iBACKHILL] setColor:ccc3(pb(50,pctm),pb(50,pctm),pb(90,pctm))];
    [[self bgo_at:iTREEHILL] setColor:ccc3(pb(140,pctm),pb(140,pctm),pb(180,pctm))];
    [[self bgo_at:iFRNTHILL] setColor:ccc3(pb(140,pctm),pb(140,pctm),pb(180,pctm))];
    [starsbg setOpacity:255-pctm*255];
}

@end