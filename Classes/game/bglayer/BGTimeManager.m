#import "BGTimeManager.h"
#import "Resource.h" 
#import "Common.h"
#import "GEventDispatcher.h" 
#import "AudioManager.h"

@implementation BGTimeManager

+(BGTimeManager*)cons {
    BGTimeManager* b = [BGTimeManager node];
    [b cons];
	[GEventDispatcher add_listener:b];
    return b;
}

#define SUN_X_PCT 0.77
#define SUN_Y_PCT 0.81

//0 night, 100 day
#define DAYNIGHT_LENGTH 6000
#define TRANSITION_LENGTH 600

static int bgtime_delayct;
static BGTimeManagerMode bgtime_curmode;

+(void)initialize {
	bgtime_delayct = DAYNIGHT_LENGTH;
	bgtime_curmode = MODE_DAY;
}

-(void)cons {
    [self setPosition:CGPointZero];
    [self setAnchorPoint:CGPointZero];
    
    sun = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SUN]];
    [sun setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT]];
    
    moon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_MOON]];
    [moon setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT+1]];
	
    [self update_posx:0 posy:0];
	
	if (bgtime_curmode == MODE_DAY) {
		[GEventDispatcher push_event:[[GEvent cons_type:GEventType_DAY_NIGHT_UPDATE] add_i1:100 i2:0]];
		
	} else if (bgtime_curmode == MODE_NIGHT) {
		[GEventDispatcher push_event:[[GEvent cons_type:GEventType_DAY_NIGHT_UPDATE] add_i1:0 i2:0]];
        [AudioManager transition_mode2];
		
	} else if (bgtime_curmode == MODE_DAY_TO_NIGHT) {
        int pctval = (((float)bgtime_delayct)/TRANSITION_LENGTH)*100;
        [GEventDispatcher push_event:[[GEvent cons_type:GEventType_DAY_NIGHT_UPDATE] add_i1:pctval i2:0]];
		
	} else if (bgtime_curmode == MODE_NIGHT_TO_DAY) {
		int pctval = (1-((float)bgtime_delayct)/TRANSITION_LENGTH)*100;
		[GEventDispatcher push_event:[[GEvent cons_type:GEventType_DAY_NIGHT_UPDATE] add_i1:pctval i2:0]];
		
	}

    [self addChild:sun];
    [self addChild:moon];
	
	
}

-(void)dispatch_event:(GEvent *)e {
	if (e.type == GEventType_ENTER_LABAREA) {
		stop = YES;
	} else if (e.type == GEventType_EXIT_TO_DEFAULTAREA) {
		stop = NO;
	}
}

//0 night, 100 day
-(void)update_posx:(float)posx posy:(float)posy {
	if (stop) return;
	
    bgtime_delayct--;
    if (bgtime_curmode == MODE_DAY) {
		[sun setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT]];
        [moon setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT+1]];
        if (bgtime_delayct <= 0) {
            bgtime_curmode = MODE_DAY_TO_NIGHT;
            bgtime_delayct = TRANSITION_LENGTH;
        }
        
    } else if (bgtime_curmode == MODE_DAY_TO_NIGHT) {
        int pctval = (((float)bgtime_delayct)/TRANSITION_LENGTH)*100;
        float fpctval = (((float)bgtime_delayct)/TRANSITION_LENGTH)*100;
        [GEventDispatcher push_event:[[GEvent cons_type:GEventType_DAY_NIGHT_UPDATE] add_i1:pctval i2:0]];
        [sun setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT-((100-fpctval)/100.0)]];
        [moon setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT+(fpctval/100.0)]];
        
		if (bgtime_delayct == TRANSITION_LENGTH/2) {
			[AudioManager transition_mode2];
		}
		
        if (bgtime_delayct <= 0) {
            bgtime_curmode = MODE_NIGHT;
            bgtime_delayct = DAYNIGHT_LENGTH;
        }
        
    } else if (bgtime_curmode == MODE_NIGHT) {
		[sun setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT-1]];
        [moon setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT]];
        if (bgtime_delayct <= 0) {
            bgtime_curmode = MODE_NIGHT_TO_DAY;
            bgtime_delayct = TRANSITION_LENGTH;
        }
        
    } else if (bgtime_curmode == MODE_NIGHT_TO_DAY) {
        int pctval = (1-((float)bgtime_delayct)/TRANSITION_LENGTH)*100;
        float fpctval = (1-((float)bgtime_delayct)/TRANSITION_LENGTH)*100;
        [GEventDispatcher push_event:[[GEvent cons_type:GEventType_DAY_NIGHT_UPDATE] add_i1:pctval i2:0]];
        [sun setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:((fpctval)/100.0)*SUN_Y_PCT]];
        [moon setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT+(fpctval/100.0)]];
        
		if (bgtime_delayct == TRANSITION_LENGTH/2) {
            [AudioManager transition_mode1];
		}
		
        if (bgtime_delayct <= 0) {
            bgtime_curmode = MODE_DAY;
            bgtime_delayct = DAYNIGHT_LENGTH;
        }
        
    }
    
}

@end
