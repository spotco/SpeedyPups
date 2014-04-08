#import <Foundation/Foundation.h>
#import "FreeRunProgressAnimation.h" 
#import "WeightedSorter.h"

typedef enum AutoLevelStateMode {
	AutoLevelStateMode_FREERUN_START,
	AutoLevelStateMode_FREERUN_PROGRESS_TO_SET,
	AutoLevelStateMode_FREERUN_PROGRESS_TO_LAB,
	AutoLevelStateMode_WORLD1_TUTORIAL,
	AutoLevelStateMode_WORLD2_TUTORIAL,
	AutoLevelStateMode_WORLD3_TUTORIAL,
	AutoLevelStateMode_WORLD1_LAB_TUTORIAL,
	AutoLevelStateMode_SET,
	AutoLevelStateMode_FILLER,
	AutoLevelStateMode_LABINTRO,
	AutoLevelStateMode_LABEXIT,
	AutoLevelStateMode_LAB,
	AutoLevelStateMode_BOSS1_ENTER,
	AutoLevelStateMode_BOSS2_ENTER,
	AutoLevelStateMode_BOSS3_ENTER,
	AutoLevelStateMode_BOSS1,
	AutoLevelStateMode_BOSS2,
	AutoLevelStateMode_BOSS3
} AutoLevelStateMode;

@interface AutoLevelState : NSObject {
	AutoLevelStateMode mode;
	NSString *cur_set;
	int ct;
	int tutorial_ct;
	int sets_until_next_lab;
	int cur_set_completed;
	
	NSMutableArray *recently_picked_sets;
	WeightedSorter *setgen, *fillersetgen, *labsetgen;
}
+(AutoLevelState*)cons;
-(NSString*)get_level:(GameEngineLayer*)g;
+(NSArray*)get_all_levels;

-(void)to_boss1_mode;
-(void)to_boss2_mode;
-(void)to_boss3_mode;

-(BOOL)is_boss_mode;

-(void)to_labexit_mode;

@end
