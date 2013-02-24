#import "GameObject.h"
#import "MapLoader.h"
#import "MapSection.h"

typedef enum {
    AutoLevelMode_Normal,
    AutoLevelMode_BOSS1
} AutoLevelMode;

@interface AutoLevel : GameObject <GEventListener> {
    GameEngineLayer* __unsafe_unretained tglayer;
    float cur_x,cur_y;
    NSMutableArray* __strong map_sections; //current ingame mapsections
    NSMutableArray* __strong queued_sections; //next mapsections
    NSMutableArray* __strong stored; //past, not removed yet
    
    AutoLevelMode cur_mode;
    //int ct;
    
    BOOL has_pos_initial;
}

+(AutoLevel*)cons_with_glayer:(GameEngineLayer*)glayer;
+(void)cons_levels;

+(void)SET_DEBUG_MODE:(int)t;
-(NSString*)get_debug_msg;

@end
