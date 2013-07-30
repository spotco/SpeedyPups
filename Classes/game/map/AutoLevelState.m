#import "AutoLevelState.h"
#import "Common.h"
#import "GameMain.h" 

@implementation AutoLevelState

#define L_TUTORIAL @"levelset_tutorial"
#define L_LAB_TUTORIAL @"levelset_lab_tutorial"

#define L_CLASSIC @"levelset_classic"
#define L_FILLER @"levelset_filler"
#define L_JUMPPAD @"levelset_jumppad"
#define L_SWINGVINE @"levelset_swingvine"
#define L_EASY @"levelset_easy"

#define L_FREERUN_PROGRESS @"levelset_freerun_progress"

#define L_BOSS1START @"levelset_boss1start"
#define L_BOSS1AREA @"levelset_boss1area"
#define L_AUTOSTART @"levelset_autostart"

#define L_LABINTRO @"levelset_labintro"
#define L_LAB @"levelset_lab"
#define L_LABEXIT @"levelset_labexit"

static NSDictionary *levelsets;
static NSArray *pickable_sets;

static NSArray *tutorial_levels;
static NSArray *lab_tutorial_levels;

+(void)initialize {
	tutorial_levels = @[
		@"tutorial_jump",
		@"tutorial_water",
		@"tutorial_swipeget",
		@"filler_sanicloop",
		@"tutorial_spikes",
		@"tutorial_breakrocks",
		@"tutorial_doublejump",
		@"tutorial_upsidebounce",
        @"tutorial_spikevine",
		@"tutorial_swingvine"
	];
	
	lab_tutorial_levels = @[
		@"labintro_tutorialbop",
		@"labintro_tutoriallauncher"
	];
	
	pickable_sets = @[L_EASY,L_CLASSIC,L_JUMPPAD,L_SWINGVINE];
	
	levelsets = @{
		L_TUTORIAL: @{
			@"tutorial_jump" : @1,
			@"tutorial_water" : @1,
			@"tutorial_swipeget" : @1,
			@"filler_sanicloop" : @1 ,
			@"tutorial_spikes" : @2,
			@"tutorial_breakrocks" : @2,
			@"tutorial_doublejump" : @2,
			@"tutorial_upsidebounce" : @3,
			@"tutorial_spikevine" : @3,
			@"tutorial_swingvine" : @3
		},
		L_LAB_TUTORIAL: @{
			@"labintro_tutorialbop" : @1,
			@"labintro_tutoriallauncher" : @1
		},
		L_CLASSIC: @{
			@"classic_trickytreas" : @3,
			@"classic_bridgenbwall" : @2,
			@"classic_cavewbwall" : @2,
			@"classic_huegcave" : @2,
			@"classic_tomslvl1" : @2,
			@"classic_smgislands" : @3,
			@"classic_nubcave" : @2,
			@"classic_manyoptredux" : @3,
			@"classic_totalmix" : @3
		},
		L_FILLER: @{
			@"filler_sanicloop" : @1,
			@"filler_curvedesc" : @1,
			@"filler_islandjump" : @1,
			@"filler_rollinghills" : @1,
			@"filler_directdrop" : @1,
			@"filler_steepdec" : @1,
			@"filler_genome" : @1,
			@"filler_manyopt" : @1,
			@"filler_cuhrazyloop" : @1
		},
		L_EASY: @{
			@"easy_puddles" : @1,
			@"easy_world1" : @1,
			@"easy_gottagofast" : @1,
			@"easy_curvywater" : @1,
			@"easy_simplespikes" : @1,
			@"easy_curvybreak" : @2,
			@"easy_breakdetail" : @2,
			@"easy_hillvine" : @1
		},
		L_JUMPPAD: @{
			@"jumppad_bigjump" : @2,
			@"jumppad_crazyloop" : @2,
			@"jumppad_hiddenislands" : @1,
			@"jumppad_jumpgap" : @3,
			@"jumppad_jumpislands" : @3,
			@"jumppad_launch" : @2,
			@"jumppad_lotsobwalls" : @3,
			@"jumppad_spikeceil" : @3
		},
		L_SWINGVINE: @{
			@"swingvine_swingintro" : @2,
			@"swingvine_dodgespike" : @3,
			@"swingvine_swingbreak" : @3,
			@"swingvine_bounswindodg" : @4,
			@"swingvine_someswings" : @2,
			@"swingvine_awesome" : @4,
			@"swingvine_morecave" : @3,
			@"swingvine_datbounce" : @2
		},
		L_AUTOSTART: @{
			@"autolevel_start": @1
		},
		L_FREERUN_PROGRESS: @{
			@"freerun_progress": @1
		},
		L_BOSS1START: @{
			@"boss1_start": @1
		},
		L_BOSS1AREA: @{
			@"boss1_area": @1
		},
		L_LABINTRO: @{
			@"labintro_entrance" : @1
		},
		L_LABEXIT: @{
			@"labintro_labexit" : @1
		},
		L_LAB: @{
			@"lab_basicmix" : @2,
			@"lab_minionwalls" : @2,
			@"lab_ezshiz" : @3,
			@"lab_ezrocketshz" : @3,
			@"lab_swingers" : @4,
			@"lab_alladat" : @4,
			@"lab_tube" : @4,
			@"lab_muhfiller" : @2
		}
		
	};
}

+(int)get_level_difficulty:(NSString*)tarlvl {
	for (NSDictionary *set in levelsets) {
		for (NSString *lvl in set.keyEnumerator) {
			if ([tarlvl isEqualToString:lvl]) {
				NSNumber *val = set[lvl];
				return val.integerValue;
			}
		}
	}
	return 1;
}

+(NSArray*)get_all_levels {
	NSMutableArray *lvls = [[NSMutableArray alloc] init];
	for (NSString *setname in [levelsets allKeys]) {
		for (NSString *lvl in [levelsets[setname] allKeys]) {
			[lvls addObject:lvl];
		}
	}
	return lvls;
}

+(AutoLevelState*)cons {
    return [[AutoLevelState alloc] init];
}

-(id)init {
    self = [super init];
	ct = 0;
	has_done_lab_tutorial = ![GameMain GET_DO_TUTORIAL];
	sets_until_next_lab = 0;
	cur_set_completed = 0;
	nth_freerunprogress = 0;
	
	setgen = [WeightedSorter cons_vals:levelsets use:pickable_sets];
	fillersetgen = [WeightedSorter cons_vals:levelsets use:@[L_FILLER]];
	labsetgen = [WeightedSorter cons_vals:levelsets use:@[L_LAB]];
	
	recently_picked_sets = [NSMutableArray array];
	if (tutorial_levels == NULL || lab_tutorial_levels == NULL) [AutoLevelState initialize];
	
    return self;
}

-(NSString*)setgen_get:(NSString*)key {
	return [setgen get_from_bucket:key];
}

-(void)to_boss1_mode {
	cur_set = L_BOSS1AREA;
}

-(void)to_labexit_mode {
	cur_set = L_LABEXIT;
}

-(void)to_progress_mode {
	cur_set = L_FREERUN_PROGRESS;
}

-(NSString*)pick_set {
	NSArray *available;
	if (ct < 13) {
		available = @[L_EASY];
	} else if (ct < 20) {
		available = @[L_EASY,L_CLASSIC];
	} else {
		available = @[L_EASY,L_CLASSIC,L_JUMPPAD,L_SWINGVINE];
	}
	NSArray *usem = [available copy_removing:recently_picked_sets];
	if (usem.count == 0) {
		[recently_picked_sets removeAllObjects];
		usem = available;
	}
	NSString *tar = usem.random;
	[recently_picked_sets addObject:tar];
	return tar;
}

-(NSString*)get_level {
	ct++;
	
	if (ct == 1) {
		if ([GameMain GET_DO_TUTORIAL]) {
			cur_set = L_TUTORIAL;
		} else {
			tutorial_ct = 0;
			ct = 10;
			cur_set = L_FREERUN_PROGRESS;
		}
		
		return [[levelsets[L_AUTOSTART] allKeys] random];
		
	} else if ([cur_set isEqualToString:L_BOSS1AREA]) {
		return [[levelsets[L_BOSS1AREA] allKeys] random];
		
	} else if ([cur_set isEqualToString:L_TUTORIAL]) {
		NSString *tar = [tutorial_levels get:tutorial_ct];
		tutorial_ct++;
		if (tutorial_ct >= tutorial_levels.count) {
			cur_set = L_FREERUN_PROGRESS;
		}
		
		return tar;
		
	} else if ([cur_set isEqualToString:L_FREERUN_PROGRESS]) {
		if (!has_done_lab_tutorial) {
			sets_until_next_lab = 2;
		} else {
			sets_until_next_lab = 4;
		}
		cur_set_completed = 0;
		cur_set = [self pick_set];
		nth_freerunprogress++;
		nth_freerunprogress = nth_freerunprogress>7?1:nth_freerunprogress;
		
		return [[levelsets[L_FREERUN_PROGRESS] allKeys] random];
		
	} else if ([cur_set isEqualToString:L_LAB_TUTORIAL]) {
		NSString *tar = [lab_tutorial_levels get:tutorial_ct];
		tutorial_ct++;
		if (tutorial_ct >= lab_tutorial_levels.count) {
			cur_set = L_LABINTRO;
			sets_until_next_lab = 3;
			tutorial_ct = 0;
		}
		return tar;
		
	} else if ([cur_set isEqualToString:L_LABINTRO]) {
		if (tutorial_ct == 0) {
			tutorial_ct++;
			nth_freerunprogress++;
			return [[levelsets[L_FREERUN_PROGRESS] allKeys] random];
		} else {
			cur_set = L_LAB;
			tutorial_ct = 0;
			nth_lab++;
			sets_until_next_lab = 3;
			return [[levelsets[L_LABINTRO] allKeys] random];
		}
	
	} else if ([cur_set isEqualToString:L_LABEXIT]) {
		cur_set = L_FREERUN_PROGRESS;
		return [[levelsets[L_LABEXIT] allKeys] random];
	
	} else if ([cur_set isEqualToString:L_LAB]) {
		sets_until_next_lab--;
		if (sets_until_next_lab < 0) {
			//cur_set = L_LABEXIT; //if doing this, set back to <= 0
			return [[levelsets[L_BOSS1START] allKeys] random];
		}
		return [labsetgen get_from_bucket:L_LAB];
		
	} else if ([cur_set isEqualToString:L_FILLER]) {
		cur_set_completed = 0;
		sets_until_next_lab--;
		if (sets_until_next_lab == 0) {
			if (!has_done_lab_tutorial) {
				cur_set = L_LAB_TUTORIAL;
				tutorial_ct = 0;
				has_done_lab_tutorial = true;
				
			} else {
				cur_set = L_LABINTRO;
				tutorial_ct = 0;
				
			}
			
		} else {
			cur_set = [self pick_set];
		}
		return [fillersetgen get_from_bucket:L_FILLER];
		
	} else if ([pickable_sets contains_str:cur_set]) {
		cur_set_completed++;
		NSString *tar_set = cur_set;
		if (cur_set_completed >= 3) cur_set = L_FILLER;
		return [setgen get_from_bucket:tar_set];
		
	} else {
		NSLog(@"ERROR: autolevel state fallthrough, curset:%@",cur_set);
		return @"ERROR";
	
	}
}

-(NSString*)status {
	return [NSString stringWithFormat:
		@"(ct:%d cur_set:%@ cursetcompl:%d setsnextlab:%d hasdonelabtut:%d)",
		ct,
		cur_set,
		cur_set_completed,
		sets_until_next_lab,
		has_done_lab_tutorial
	];
}

-(FreeRunProgress)get_freerun_progress {
	if (nth_freerunprogress <= 1) {
		return FreeRunProgress_PRE_1;
		
	} else if (nth_freerunprogress == 2) {
		return FreeRunProgress_1;
		
	} else if (nth_freerunprogress == 3) {
		return FreeRunProgress_PRE_2;
		
	} else if (nth_freerunprogress == 4) {
		return FreeRunProgress_2;
		
	} else if (nth_freerunprogress == 5) {
		return FreeRunProgress_PRE_3;
		
	} else if (nth_freerunprogress == 6) {
		return FreeRunProgress_3;
		
	} else if (nth_freerunprogress == 7) {
		return FreeRunProgress_POST_3;
		
	} else {
		return FreeRunProgress_PRE_1;
		
	}
}

-(NSString*)debug_boss_only {
	ct++;
	if (ct == 1) {
		cur_set = @"no";
		return [[levelsets[L_AUTOSTART] allKeys] random];
		
	} else if ([cur_set isEqualToString:L_BOSS1AREA]) {
		return [[levelsets[L_BOSS1AREA] allKeys] random];
	
	} else if ([cur_set isEqualToString:L_LABEXIT]) {
		cur_set = @"no";
		return [[levelsets[L_LABEXIT] allKeys] random];
		
	} else if ([cur_set isEqualToString:@"no"]) {
		cur_set = @"yes";
		return [[levelsets[L_LABINTRO] allKeys] random];
		
	} else if ([cur_set isEqualToString:@"yes"]) {
		return [[levelsets[L_BOSS1START] allKeys] random];
		
	} else {
		NSLog(@"error fb");
		return @"";
	}
}

@end
