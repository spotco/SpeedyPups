#import <Foundation/Foundation.h>
#import "FreeRunProgressAnimation.h" 
#import "WeightedSorter.h"

@interface AutoLevelState : NSObject {
	NSString *cur_set;
	int ct;
	int tutorial_ct;
	
	BOOL has_done_lab_tutorial;
	int sets_until_next_lab;
	
	int cur_set_completed;
	
	int nth_lab;
	int nth_freerunprogress;
	int nth_filler;
	
	NSMutableArray *recently_picked_sets;
	WeightedSorter *setgen, *fillersetgen, *labsetgen;
}
+(AutoLevelState*)cons;
-(NSString*)get_level;
+(NSArray*)get_all_levels;

-(void)to_boss1_mode;
-(void)to_labexit_mode;
//-(void)to_progress_mode;

-(FreeRunProgress)get_freerun_progress;
-(NSString*)status;

-(NSString*)setgen_get:(NSString*)key;

@end
