#import <Foundation/Foundation.h>

typedef enum {
    GEventType_CHECKPOINT,
    GEventType_PAUSE,
    GEventType_UNPAUSE,
    GEventType_QUIT,
    GEventType_UIANIM_TICK,
    GEventType_GAME_TICK,
    GEventType_COLLECT_BONE,
    GEventType_PLAYER_DIE,
    GEventType_ASK_CONTINUE,
    GEventType_PLAYAGAIN_AUTOLEVEL,
    GEventType_GAME_RESET,
    GEventType_DASH,
    GEventType_JUMP,
    GEventType_END_TUTORIAL,
    GEventType_DAY_NIGHT_UPDATE,
    GEventType_SHOW_ENEMYAPPROACH_WARNING,
    GEventType_ENTER_LABAREA,
    GEventType_EXIT_TO_DEFAULTAREA,
    GEventType_START_INTIAL_ANIM,
    GEventType_USE_ITEM,
    GEventType_ITEM_DURATION_PCT,
    GEventType_CONTINUE_GAME,
    
    GEventType_CHALLENGE,
    GEventType_CHALLENGE_COMPLETE,
    GEventType_LOAD_CHALLENGE_COMPLETE_MENU,
    
    GEventType_BOSS1_ACTIVATE,
    GEventType_BOSS1_TICK,
    GEventType_BOSS1_DEFEATED,
    
    GEventType_MENU_TICK,
    GEventType_MENU_MAKERUNPARTICLE,
    GEventType_MENU_SCROLLBGUP_PCT,
    GEventType_MENU_PLAY_AUTOLEVEL_MODE,
    GEventType_MENU_PLAY_TESTLEVEL_MODE,
    GEventType_MENU_GOTO_PAGE,
    GEventType_MENU_INVENTORY,
    GEVentType_MENU_CLOSE_INVENTORY,
    GEventType_CHANGE_CURRENT_DOG
} GEventType;

@interface GEvent : NSObject
@property(readwrite,assign) GEventType type;
@property(readwrite,strong) NSMutableDictionary* data;
@property(readwrite,assign) CGPoint pt;
@property(readwrite,assign) int i1,i2;
@property(readwrite,assign) float f1,f2;
+(GEvent*)cons_type:(GEventType)t;
-(GEvent*)add_key:(NSString*)k value:(id)v;
-(GEvent*)add_pt:(CGPoint)tpt;
-(GEvent*)add_i1:(int)ti1 i2:(int)ti2;
-(GEvent*)add_f1:(float)tf1 f2:(float)tf2;
-(id)get_value:(NSString*)key;
@end

@protocol GEventListener <NSObject>
    @required
    -(void)dispatch_event:(GEvent*)e;
@end

@interface GEventDispatcher : NSObject
+(void)lazy_alloc;

+(void)add_listener:(id<GEventListener>)tar;
+(void)remove_all_listeners;
+(void)remove_listener:(id<GEventListener>)tar;
+(void)push_event:(GEvent*)e;
+(void)push_unique_event:(GEvent*)e;
+(void)immediate_event:(GEvent*)e;
+(void)dispatch_events;
@end
