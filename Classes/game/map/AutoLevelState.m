#import "AutoLevelState.h"
#import "Common.h"
#import "GameMain.h" 
#import "FreeRunStartAtManager.h"

@implementation AutoLevelState

#define L_TUTORIAL @"levelset_tutorial"
#define L_LAB_TUTORIAL @"levelset_lab_tutorial"
#define L_CAPEGAME_LAUNCHER @"levelset_capegame_launcher"

#define L_CLASSIC @"levelset_classic"
#define L_FILLER @"levelset_filler"
#define L_JUMPPAD @"levelset_jumppad"
#define L_SWINGVINE @"levelset_swingvine"
#define L_EASY @"levelset_easy"
#define L_CANNON @"levelset_cannon"
#define L_HARD @"levelset_hard"

#define L_FREERUN_PROGRESS @"levelset_freerun_progress"

#define L_BOSS1START @"levelset_boss1start"
#define L_BOSS1AREA @"levelset_boss1area"
#define L_AUTOSTART @"levelset_autostart"

#define L_BOSS2START @"levelset_boss2start"
#define L_BOSS2AREA @"levelset_boss2area"

#define L_BOSS3START @"levelset_boss3start"
#define L_BOSS3AREA @"levelset_boss3area"

#define L_LABINTRO @"levelset_labintro"
#define L_LABEXIT @"levelset_labexit"

#define L_LAB @"levelset_lab"

static NSDictionary *levelsets;
static NSArray *pickable_sets;

static NSArray *tutorial_levels;
static NSArray *lab_tutorial_levels;
static NSArray *world2_tutorial_levels;
static NSArray *world3_tutorial_levels;

static NSSet *lab_levels_world1;
static NSSet *lab_levels_world2;
static NSSet *lab_levels_world3;

+(void)initialize {
	tutorial_levels = @[
		@"tutorial_jump",
		@"tutorial_water",
		@"tutorial_doublejump",
		@"tutorial_swipeget",
		@"filler_sanicloop",
		@"tutorial_spikes",
		@"tutorial_spikevine",
		@"tutorial_breakrocks",
		@"tutorial_upsidebounce",
		@"capegame_launcher"
	];
	
	lab_tutorial_levels = @[
		@"labintro_tutorialbop",
		@"labintro_tutoriallauncher"
	];
	
	world2_tutorial_levels = @[@"tutorial_swingvine"];
	world3_tutorial_levels = @[@"tutorial_cannons"];
	
	pickable_sets = @[L_EASY,L_CLASSIC,L_JUMPPAD,L_SWINGVINE,L_CANNON,L_HARD];
	
	levelsets = @{
		L_CLASSIC: @{
			@"classic_trickytreas" : @3,
			@"classic_bridgenbwall" : @2,
			@"classic_cavewbwall" : @2,
			@"classic_huegcave" : @2,
			@"classic_tomslvl1" : @2,
			@"classic_smgislands" : @3,
			@"classic_nubcave" : @2,
			@"classic_manyoptredux" : @3,
			@"classic_twopath" : @5,
			@"classic_doublehelix" : @2
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
			@"filler_cuhrazyloop" : @1,
			@"filler_chickennuggets" : @2,
			@"filler_skippingstones" : @2,
			@"filler_godog" : @2,
			@"filler_kingofswing" : @4,
			@"filler_goslow" : @2
		},
		L_EASY: @{
			@"easy_puddles" : @1,
			@"easy_world1" : @1,
			@"easy_gottagofast" : @1,
			@"easy_curvywater" : @1,
			@"easy_simplespikes" : @1,
			@"easy_curvybreak" : @2,
			@"easy_breakdetail" : @2
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
			@"swingvine_datbounce" : @2,
			@"swingvine_totalmix" : @3,
			@"swingvine_hillvine" : @2
		},
		L_CANNON: @{								//TODO -- 7 cannon levels
			@"cannon_cannonsandrobots" : @2,
			@"cannon_cannoncave" : @2,
			@"cannon_jetpackthorns" : @3,
		},
		L_HARD: @{									//TODO -- 6 hard levels
			@"classic_twopath" : @2,
			@"swingvine_awesome" : @4,
			@"swingvine_bounswindodg" : @4,
			@"classic_totalmix" : @3
		},
		L_AUTOSTART: @{
			@"shittytest":@1
				//@"autolevel_start": @1
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
		L_BOSS2START: @{
			@"boss2_start":@1
		},
		L_BOSS2AREA: @{
			@"boss2_area":@1
		},
		L_BOSS3START: @{
			@"boss3_start":@1
		},
		L_BOSS3AREA: @{
			@"boss3_area":@1
		},
		L_LABINTRO: @{
			@"labintro_entrance" : @1
		},
		L_LABEXIT: @{
			@"labintro_labexit" : @1
		},
		L_CAPEGAME_LAUNCHER: @{
			@"capegame_launcher": @1
		},
		L_LAB: @{
			@"lab_basicmix" : @2,
			@"lab_minionwalls" : @2,
			@"lab_ezshiz" : @3,
			@"lab_ezrocketshz" : @3,
			@"lab_swingers" : @4,
			@"lab_alladat" : @4,
			@"lab_tube" : @4,
			@"lab_muhfiller" : @2,
			@"lab_rocketfever" : @4,
			@"lab_towerfall" : @2,
			@"lab_clusterphobia": @3,
			@"lab_bounceycannon" : @4,
			@"lab_minionwallshard" : @4,
			@"lab_cage_cannons" : @4
		}
	};
	
	lab_levels_world1 = _NSSET( //TODO -- 3 easy lab levels
		@"lab_basicmix",
		@"lab_minionwalls",
		@"lab_clusterphobia",
		@"lab_towerfall"
		
	);
	
	lab_levels_world2 = _NSSET(
		@"lab_ezshiz",
		@"lab_ezrocketshz",
		@"lab_swingers",
		@"lab_alladat",
		@"lab_tube",
		@"lab_muhfiller",
		@"lab_rocketfever",
		@"lab_minionwallshard"
	);
	lab_levels_world3 = _NSSET(
		@"lab_basicmix",
		@"lab_minionwalls",
		@"lab_ezshiz",
		@"lab_ezrocketshz",
		@"lab_swingers",
		@"lab_alladat",
		@"lab_tube",
		@"lab_muhfiller",
		@"lab_rocketfever",
		@"lab_minionwallshard",
		@"lab_bounceycannon",
		@"lab_cage_cannons"
	);
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
	has_done_lab_tutorial = NO;
	has_done_world2_tutorial = NO;
	has_done_world3_tutorial = NO;
	sets_until_next_lab = 0;
	cur_set_completed = 0;
	nth_filler = 0;
	
	setgen = [WeightedSorter cons_vals:levelsets use:pickable_sets];
	fillersetgen = [WeightedSorter cons_vals:levelsets use:@[L_FILLER]];
	labsetgen = [WeightedSorter cons_vals:levelsets use:@[L_LAB]];
	
	
	recently_picked_sets = [NSMutableArray array];
	if (tutorial_levels == NULL || lab_tutorial_levels == NULL) [AutoLevelState initialize];
	
    return self;
}

-(void)to_boss2_mode {
	cur_set = L_BOSS2AREA;
}

-(void)to_boss1_mode {
	cur_set = L_BOSS1AREA;
}

-(void)to_boss3_mode {
	cur_set = L_BOSS3AREA;
}

-(void)to_labexit_mode {
	cur_set = L_LABEXIT;
}

-(void)to_progress_mode {
	cur_set = L_FREERUN_PROGRESS;
}

-(BOOL)is_boss_mode {
	return streq(cur_set, L_BOSS1AREA) || streq(cur_set, L_BOSS2AREA) || streq(cur_set, L_BOSS3AREA);
}

-(NSString*)pick_set {
	NSArray *available;
	
	if (start_with_easy) {
		start_with_easy = NO;
		available = @[L_EASY];
		
	} else if ([GameWorldMode get_worldnum] == WorldNum_1) {
		available = @[L_EASY,L_CLASSIC,L_JUMPPAD];
		
	} else if ([GameWorldMode get_worldnum] == WorldNum_2) {
		available = @[L_CLASSIC,L_JUMPPAD, L_SWINGVINE, L_HARD];
		
	} else if ([GameWorldMode get_worldnum] == WorldNum_3) {
		available = @[L_JUMPPAD, L_SWINGVINE, L_HARD, L_CANNON];
		
	} else {
		available = @[L_FILLER];
		
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

-(void)cycle_through:(int)fois {
	cur_set = [self pick_set];
	for (int i = 0; i < fois; i++) {
		ct++;
		if (ct%3==0) cur_set = [self pick_set];
		[setgen get_from_bucket:cur_set];
	}
}

-(void)cycle_through_lab:(int)fois {
	for (int i = 0; i < fois; i++) {
		[labsetgen get_from_bucket:L_LAB];
	}
}

-(void)set_initial_params {
	if ([FreeRunStartAtManager get_starting_loc] == FreeRunStartAt_TUTORIAL) {
		cur_set = L_TUTORIAL;
		has_done_lab_tutorial = NO;
		start_with_easy = YES;
		
	} else if ([FreeRunStartAtManager get_starting_loc] == FreeRunStartAt_WORLD1) {
		tutorial_ct = 0;
		cur_set = L_FREERUN_PROGRESS;
		has_done_lab_tutorial = NO;
		start_with_easy = YES;
		
	} else if ([FreeRunStartAtManager get_starting_loc] == FreeRunStartAt_LAB1) {
		[self cycle_through:17];
		tutorial_ct = 0;
		has_done_lab_tutorial = true;
		cur_set = L_LABINTRO;
		
	} else if ([FreeRunStartAtManager get_starting_loc] == FreeRunStartAt_WORLD2) {
		[self cycle_through:20];
		[self cycle_through_lab:3];
		tutorial_ct = 0;
		has_done_lab_tutorial = true;
		cur_set = L_FREERUN_PROGRESS;
		
	} else if ([FreeRunStartAtManager get_starting_loc] == FreeRunStartAt_LAB2) {
		[self cycle_through:35];
		[self cycle_through_lab:3];
		tutorial_ct = 0;
		has_done_lab_tutorial = true;
		cur_set = L_LABINTRO;
		has_done_world2_tutorial = YES;
		
	} else if ([FreeRunStartAtManager get_starting_loc] == FreeRunStartAt_WORLD3) {
		[self cycle_through:36];
		[self cycle_through_lab:6];
		tutorial_ct = 0;
		has_done_lab_tutorial = true;
		cur_set = L_FREERUN_PROGRESS;
		has_done_world2_tutorial = YES;
		
	} else if ([FreeRunStartAtManager get_starting_loc] == FreeRunStartAt_LAB3) {
		[self cycle_through:36];
		[self cycle_through_lab:6];
		tutorial_ct = 0;
		has_done_lab_tutorial = true;
		cur_set = L_LABINTRO;
		has_done_world3_tutorial = YES;
		
	} else {
		NSLog(@"AutoLevelState start at error");
	}
}

#define SETS_BETWEEN_LABS 3
#define LEVELS_IN_LAB_SET 3
#define LEVELS_IN_SET 3
#define CAPEGAME_EVERY 3

-(NSString*)get_level {
	ct++;
	
	if (ct == 1) {
		[self set_initial_params];
		return [[levelsets[L_AUTOSTART] allKeys] random];
		
	} else if ([cur_set isEqualToString:L_BOSS1AREA]) {
		return [[levelsets[L_BOSS1AREA] allKeys] random];
		
	} else if ([cur_set isEqualToString:L_BOSS2AREA]) {
		return [[levelsets[L_BOSS2AREA] allKeys] random];
		
	} else if ([cur_set isEqualToString:L_BOSS3AREA]) {
		return [[levelsets[L_BOSS3AREA] allKeys] random];
		
	} else if ([cur_set isEqualToString:L_TUTORIAL]) {
		NSString *tar = [tutorial_levels get:tutorial_ct];
		tutorial_ct++;
		if (tutorial_ct >= tutorial_levels.count) {
			cur_set = L_FREERUN_PROGRESS;
		}
		//return @"boss1_start";
		//return [[levelsets[L_CAPEGAME_LAUNCHER] allKeys] random];
		return @"boss3_start";
		//return tar;
		
	} else if ([cur_set isEqualToString:L_FREERUN_PROGRESS]) {
		sets_until_next_lab = SETS_BETWEEN_LABS;
		cur_set_completed = 0;
		cur_set = [self pick_set];
		
		return [[levelsets[L_FREERUN_PROGRESS] allKeys] random];
		
	} else if ([cur_set isEqualToString:L_LAB_TUTORIAL]) {
		NSString *tar = [lab_tutorial_levels get:tutorial_ct];
		tutorial_ct++;
		if (tutorial_ct >= lab_tutorial_levels.count) {
			cur_set = L_LABINTRO;
			sets_until_next_lab = LEVELS_IN_LAB_SET;
			tutorial_ct = 0;
		}
		return tar;
		
	} else if ([cur_set isEqualToString:L_LABINTRO]) {
		if (tutorial_ct == 0) {
			tutorial_ct++;
			[GameWorldMode freerun_progress_about_to_enter_lab];
			return [[levelsets[L_FREERUN_PROGRESS] allKeys] random];
		} else {
			cur_set = L_LAB;
			tutorial_ct = 0;
			sets_until_next_lab = LEVELS_IN_LAB_SET;
			return [[levelsets[L_LABINTRO] allKeys] random];
		}
	
	} else if ([cur_set isEqualToString:L_LABEXIT]) {
		cur_set = L_FREERUN_PROGRESS;
		return [[levelsets[L_LABEXIT] allKeys] random];
	
	} else if ([cur_set isEqualToString:L_LAB]) {
		sets_until_next_lab--; //TODO -- fix me
		if (sets_until_next_lab < 0) {
			if ([GameWorldMode get_labnum] == LabNum_2) {
				return [[levelsets[L_BOSS2START] allKeys] random];
			} else {
				return [[levelsets[L_BOSS1START] allKeys] random];
			}
		}
		
		NSString *rtv = [[levelsets[L_LAB] allKeys] random];
		int nloopct = 15;
		while (true) {
			if ([GameWorldMode get_actual_worldnum] == WorldNum_1 && [lab_levels_world1 containsObject:rtv]) {
				break;
			} else if ([GameWorldMode get_actual_worldnum] == WorldNum_2 && [lab_levels_world2 containsObject:rtv]) {
				break;
			} else if ([GameWorldMode get_actual_worldnum] == WorldNum_3 && [lab_levels_world3 containsObject:rtv]) {
				break;
			}
			nloopct--;
			if (nloopct <= 0) {
				NSLog(@"AutoLevel::lab world selector failed");
				break;
			}
			rtv = [[levelsets[L_LAB] allKeys] random];
		}
		return rtv;
		
	} else if ([cur_set isEqualToString:L_FILLER]) {
		cur_set_completed = 0;
		sets_until_next_lab--;
		nth_filler++;

		if (nth_filler%CAPEGAME_EVERY==0) {
			cur_set = L_CAPEGAME_LAUNCHER;
		} else {
			[self filler_next];
		}
		
		return [fillersetgen get_from_bucket:L_FILLER];
		
	} else if ([cur_set isEqualToString:L_CAPEGAME_LAUNCHER]) {
		[self filler_next];
		return [[levelsets[L_CAPEGAME_LAUNCHER] allKeys] random];
		
	} else if (has_done_world2_tutorial == NO && [GameWorldMode get_bgmode] == BGMode_NORMAL && [GameWorldMode get_worldnum] == WorldNum_2) {
		has_done_world2_tutorial = YES;
		cur_set = L_SWINGVINE;
		[recently_picked_sets addObject:L_SWINGVINE];
		return [world2_tutorial_levels random];
		
	} else if (has_done_world3_tutorial == NO && [GameWorldMode get_bgmode] == BGMode_NORMAL && [GameWorldMode get_worldnum] == WorldNum_3) {
		has_done_world3_tutorial = YES;
		cur_set = L_CANNON;
		[recently_picked_sets addObject:L_CANNON];
		return [world3_tutorial_levels random];
		
	} else if ([pickable_sets contains_str:cur_set]) {
		cur_set_completed++;
		NSString *tar_set = cur_set;
		if (cur_set_completed >= LEVELS_IN_SET) cur_set = L_FILLER;
		return [setgen get_from_bucket:tar_set];
		
	} else {
		NSLog(@"ERROR: autolevel state fallthrough, curset:%@",cur_set);
		return @"ERROR";
	
	}
}

-(void)filler_next {
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
}

@end
