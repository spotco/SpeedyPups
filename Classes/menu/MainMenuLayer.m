#import "MainMenuLayer.h"

#import "NMenuPlayPage.h"
#import "NMenuWorldSelectPage.h"
#import "NMenuCharSelectPage.h"
#import "NMenuTabShopPage.h"
#import "AudioManager.h"
//#import "NMenuShopPage.h"

#import "MainMenuInventoryLayer.h"

#import "GameMain.h"

@implementation NMenuPage
-(void)setOpacity:(GLubyte)opacity {
	[super setOpacity:opacity];
	for(CCSprite *sprite in [self children]) {
		sprite.opacity = opacity;
	}
}
-(void)touch_begin:(CGPoint)pt{}
-(void)touch_move:(CGPoint)pt{}
-(void)touch_end:(CGPoint)pt{}
@end

@implementation MainMenuLayer
@synthesize bg;

+(CCScene*)scene {
    CCScene* sc = [CCScene node];
    MainMenuLayer *mm = [MainMenuLayer node];
    MainMenuBGLayer *mb = [MainMenuBGLayer cons];
    [mm setBg:mb];
    [mm.bg move_fg:[mm get_target_bg_pt]];
	mm.inventory_layer = [MainMenuInventoryLayer cons];
    
    [sc addChild:mb];
    [sc addChild:mm];
    [sc addChild:mm.inventory_layer];
    
    return sc;
}

-(id)init {
    self = [super init];
	
    [GEventDispatcher add_listener:self];
    [AudioManager playbgm_imm:BGM_GROUP_MENU];
    
    cur_page = MENU_STARTING_PAGE_ID;
    
    menu_pages = [[NSMutableArray alloc] init];
    [self add_pages];
    for(int i = 0; i < [menu_pages count]; i++) {
        CCSprite* c = [menu_pages objectAtIndex:i];
        [c setVisible:i==cur_page?YES:NO];
        [self addChild:c];
    }
    
    
    
    self.isTouchEnabled = YES;
    [self schedule:@selector(update) interval:1.0/60];
    return self;
}

-(void)add_pages {
    [menu_pages addObject:[NMenuTabShopPage cons]];
    [menu_pages addObject:[NMenuCharSelectPage cons]];
    [menu_pages addObject:[NMenuPlayPage cons]];
    [menu_pages addObject:[NMenuWorldSelectPage cons]];
}

-(void)update {
    float dx = [self get_target_bg_pt].x - [bg get_fg_pos].x;
    dx/=3;
    BOOL snapto = NO;
    if (ABS(dx) < 0.25) {
        [bg move_fg:[self get_target_bg_pt]];
    } else {
        [bg move_fg:ccp([bg get_fg_pos].x+dx,[bg get_fg_pos].y)];
        snapto = YES;
    }
    
    
    [bg update];
    for(int i = 0; i < [menu_pages count]; i++) {
        CCSprite* c = [menu_pages objectAtIndex:i];
        if (snapto) {
            [c setVisible:NO];
            [c setOpacity:0];
        } else {
            [c setVisible:i==cur_page?YES:NO];
            if (c.visible) {
                [c setOpacity:(255-c.opacity)/5.0+c.opacity];
                if(c.opacity > 245) [c setOpacity:255];
            }
        }
    }
    
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_MENU_TICK]];
	[GEventDispatcher dispatch_events]; //breaks if you do immediate_event in menu->freerun, dunno why
}

-(CGPoint)get_target_bg_pt {
    return ccp(-[Common SCREEN].width*cur_page,0);
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_GOTO_PAGE) {
        cur_page = e.i1;
		
    } else if (e.type == GEventType_MENU_PLAY_AUTOLEVEL_MODE) {
        [self exit];
        [GameMain start_game_autolevel];
		
    } else if (e.type == GEventType_MENU_PLAY_CHALLENGELEVEL_MODE) {
		[self exit];
		[GameMain start_game_challengelevel:[ChallengeRecord get_challenge_number:e.i1]];
		
	} else if (e.type == GEventType_QUIT) {
		[self exit];
		[GameMain start_menu];
	}
}

-(CGPoint)grab_gl_coord_touch:(NSSet*)touches {
	CGPoint touch;
    for (UITouch *t in touches) touch = [t locationInView:[t view]];
	return [[CCDirector sharedDirector] convertToGL:touch];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint touch = [self grab_gl_coord_touch:touches];
	if (![self.inventory_layer window_open]) {
		for (NMenuPage *p in menu_pages) p.visible?[p touch_begin:touch]:0;
	} else {
		[self.inventory_layer touch_begin:touch];
	}
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint touch = [self grab_gl_coord_touch:touches];
	if (![self.inventory_layer window_open]) {
		for (NMenuPage *p in menu_pages) p.visible?[p touch_move:touch]:0;
	} else {
		[self.inventory_layer touch_move:touch];
	}
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint touch = [self grab_gl_coord_touch:touches];
	if (![self.inventory_layer window_open]) {
		for (NMenuPage *p in menu_pages) p.visible?[p touch_end:touch]:0;
	} else {
		[self.inventory_layer touch_end:touch];
	}
}


-(void)exit {
    [GEventDispatcher remove_all_listeners];
    [self unscheduleAllSelectors];
    [self removeAllChildrenWithCleanup:YES];
    [menu_pages removeAllObjects];
	[[self parent] removeAllChildrenWithCleanup:YES];
}

@end
