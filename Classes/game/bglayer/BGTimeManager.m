#import "BGTimeManager.h"
#import "Resource.h" 
#import "Common.h"
#import "GEventDispatcher.h" 

@implementation BGTimeManager

+(BGTimeManager*)cons {
    BGTimeManager* b = [BGTimeManager node];
    [b cons];
    return b;
}

#define SUN_X_PCT 0.77
#define SUN_Y_PCT 0.81

//0 night, 100 day
#define DAYNIGHT_LENGTH 3000
#define TRANSITION_LENGTH 600

-(void)cons {
    [self setPosition:CGPointZero];
    [self setAnchorPoint:CGPointZero];
    
    sun = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_SUN]];
    [sun setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT]];
    
    moon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_BG_MOON]];
    [moon setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT+1]];
    
    curmode = MODE_DAY;
    delayct = DAYNIGHT_LENGTH;
    
    [self addChild:sun];
    [self addChild:moon];
}

//0 night, 100 day
-(void)update_posx:(float)posx posy:(float)posy {
    delayct--;
    if (curmode == MODE_DAY) {
        if (delayct <= 0) {
            curmode = MODE_DAY_TO_NIGHT;
            delayct = TRANSITION_LENGTH;
        }
        
    } else if (curmode == MODE_DAY_TO_NIGHT) {
        int pctval = (((float)delayct)/TRANSITION_LENGTH)*100;
        float fpctval = (((float)delayct)/TRANSITION_LENGTH)*100;
        [GEventDispatcher push_event:[[GEvent cons_type:GEventType_DAY_NIGHT_UPDATE] add_i1:pctval i2:0]];
        [sun setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT-((100-fpctval)/100.0)]];
        [moon setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT+(fpctval/100.0)]];
        
        if (delayct <= 0) {
            curmode = MODE_NIGHT;
            delayct = DAYNIGHT_LENGTH;
        }
        
    } else if (curmode == MODE_NIGHT) {
        if (delayct <= 0) {
            curmode = MODE_NIGHT_TO_DAY;
            delayct = TRANSITION_LENGTH;
        }
        
    } else if (curmode == MODE_NIGHT_TO_DAY) {
        int pctval = (1-((float)delayct)/TRANSITION_LENGTH)*100;
        float fpctval = (1-((float)delayct)/TRANSITION_LENGTH)*100;
        [GEventDispatcher push_event:[[GEvent cons_type:GEventType_DAY_NIGHT_UPDATE] add_i1:pctval i2:0]];
        [sun setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:((fpctval)/100.0)*SUN_Y_PCT]];
        [moon setPosition:[Common screen_pctwid:SUN_X_PCT pcthei:SUN_Y_PCT+(fpctval/100.0)]];
        
        if (delayct <= 0) {
            curmode = MODE_DAY;
            delayct = DAYNIGHT_LENGTH;
            
        }
        
    }
    
}

@end
