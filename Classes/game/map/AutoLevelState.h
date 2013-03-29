#import <Foundation/Foundation.h>

typedef enum {
    AutoLevelStateMode_Normal,
    AutoLevelStateMode_BOSS1
} AutoLevelStateMode;

@interface AutoLevelState : NSObject {
    AutoLevelStateMode cur_mode;
    int ct,cur_set_ct;
    NSString *cur_set;
    NSMutableArray* __strong cur_used;
}

+(AutoLevelState*)cons;
-(NSString*)get_level;
-(NSArray*)get_all_levels;
-(void)change_mode:(AutoLevelStateMode)t;

@end
