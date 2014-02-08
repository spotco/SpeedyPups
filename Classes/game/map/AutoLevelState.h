#import <Foundation/Foundation.h>
#import "FreeRunProgressAnimation.h" 
#import "WeightedSorter.h"

@interface AutoLevelState : NSObject {
	NSString *cur_set;
	int ct;
	int tutorial_ct;
	
	BOOL has_done_lab_tutorial;
	BOOL has_done_world2_tutorial;
	BOOL has_done_world3_tutorial;
	int sets_until_next_lab;
	
	int cur_set_completed;
	int nth_filler;
	BOOL start_with_easy;
	
	NSMutableArray *recently_picked_sets;
	WeightedSorter *setgen, *fillersetgen, *labsetgen;
}
+(AutoLevelState*)cons;
-(NSString*)get_level;
+(NSArray*)get_all_levels;

-(void)to_boss1_mode;
-(void)to_boss2_mode;
-(void)to_boss3_mode;

-(BOOL)is_boss_mode;

-(void)to_labexit_mode;

@end
