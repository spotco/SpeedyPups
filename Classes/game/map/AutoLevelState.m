#import "AutoLevelState.h"
#import "Common.h"

@implementation AutoLevelState

#define L_TUTORIAL @"levelset_tutorial"
#define L_CLASSIC @"levelset_classic"
#define L_FILLER @"levelset_filler"
#define L_JUMPPAD @"levelset_jumppad"
#define L_SWINGVINE @"levelset_swingvine"
#define L_EASY @"levelset_easy"
#define L_BOSS1AREA @"levelset_boss1area"
#define L_AUTOSTART @"levelset_autostart"

#define L_LABINTRO @"levelset_labintro"
#define L_LAB @"levelset_lab"

static NSMutableDictionary* levelsets;

+(void)initialize {
    levelsets = [NSMutableDictionary dictionary];
    
    [levelsets setObject:@[
        @"tutorial_jump",
        @"tutorial_breakrocks",
        @"tutorial_water",
        @"tutorial_spikes",
        @"tutorial_doublejump",
        @"tutorial_swipedir",
        @"tutorial_swingvine",
        @"tutorial_swipeget",
        @"tutorial_spikevine",
    ] forKey:L_TUTORIAL];
    
    [levelsets setObject:@[
        @"classic_bridgenbwall",
        @"classic_cavewbwall",
        @"classic_huegcave",
        @"classic_trickytreas",
        @"classic_tomslvl1",
        @"classic_smgislands",
        @"classic_nubcave",
        @"classic_manyoptredux",
        @"classic_totalmix"
    ] forKey:L_CLASSIC];
    
    [levelsets setObject:@[
        @"filler_curvedesc",
        @"filler_islandjump",
        @"filler_rollinghills",
        @"filler_sanicloop",
        @"filler_directdrop",
        @"filler_steepdec",
        @"filler_genome",
        @"filler_manyopt",
        @"filler_cuhrazyloop"
    ] forKey:L_FILLER];
    
    [levelsets setObject:@[
        @"easy_puddles",
        @"easy_world1",
        @"easy_gottagofast",
        @"easy_curvywater",
        @"easy_simplespikes",
        @"easy_curvybreak",
        @"easy_breakdetail",
        @"easy_hillvine"
     ] forKey:L_EASY];
    
    [levelsets setObject:@[
        @"jumppad_bigjump",
        @"jumppad_crazyloop",
        @"jumppad_hiddenislands",
        @"jumppad_jumpgap",
        @"jumppad_jumpislands",
        @"jumppad_launch",
        @"jumppad_lotsobwalls",
        @"jumppad_spikeceil",
    ] forKey:L_JUMPPAD];
    
    [levelsets setObject:@[
        @"swingvine_swingintro",
        @"swingvine_dodgespike",
        @"swingvine_swingbreak",
        @"swingvine_bounswindodg",
        @"swingvine_someswings",
        @"swingvine_awesome",
        @"swingvine_morecave",
        @"swingvine_datbounce"
    ] forKey:L_SWINGVINE];
    
    [levelsets setObject:@[
        @"autolevel_start",
    ] forKey:L_AUTOSTART];
    
    [levelsets setObject:@[
        @"boss1_area",
    ] forKey:L_BOSS1AREA];
	
	[levelsets setObject:@[
		@"labintro_tutorialbop",
		@"labintro_tutoriallauncher",
		@"labintro_entrance"
	] forKey:L_LABINTRO];
	
	[levelsets setObject:@[
		@"lab_basicmix",
		@"lab_minionwalls",
		@"lab_ezshiz",
		@"lab_ezrocketshz",
		@"lab_swingers",
		@"lab_alladat",
		@"lab_tube",
		@"lab_muhfiller"
	] forKey:L_LAB];
}

+(AutoLevelState*)cons {
    return [[AutoLevelState alloc] init];
}

-(id)init {
    self = [super init];
    cur_used = [NSMutableArray array];
    [self set_cur_set_to:L_AUTOSTART];
    return self;
}

-(void)change_mode:(AutoLevelStateMode)t {
    cur_mode = t;
}

-(NSArray*)get_all_levels {
    NSMutableArray *all = [NSMutableArray array];
    for (NSString* key in levelsets) {
        NSArray* set = [levelsets objectForKey:key];
        [all addObjectsFromArray:set];
    }
    return all;
}

-(void)set_cur_set_to:(NSString*)t {
    if (levelsets[t]==NULL) [NSException raise:@"ERROR:" format:@"invalid cur levelset %@",t];
    cur_set = t;
    cur_set_ct = 0;
    [cur_used removeAllObjects];
}

-(NSArray*)cur_levelset_get_unused {
    return [(NSArray*)levelsets[cur_set] copy_removing:cur_used];
}

-(void)set_next_levelset {
    NSArray* a = [@[L_CLASSIC,L_JUMPPAD,L_SWINGVINE,L_EASY] copy_removing:@[cur_set]];
    NSString *s = [a random];
    [self set_cur_set_to:s];
}

-(NSString*)get_level {
    ct++;
    if (cur_mode == AutoLevelStateMode_BOSS1) {
        return [levelsets[L_BOSS1AREA] random];
		
    } else if (ct == 1) {
        [self set_cur_set_to:L_TUTORIAL];
        return [levelsets[L_AUTOSTART] random];
    
    } else if ([cur_set isEqualToString:L_TUTORIAL]) {
        cur_set_ct++;
        NSString* picked;
        if (cur_set_ct == 1) {
            picked = [levelsets[L_TUTORIAL] objectAtIndex:0];
            
        } else if (cur_set_ct == 2) {
            picked = [levelsets[L_TUTORIAL] objectAtIndex:1];
            
        } else if (cur_set_ct%3 == 0) {
            return [levelsets[L_FILLER] random];
        
        } else {
            NSArray *tuts_left = [levelsets[cur_set] copy_removing:cur_used];
            if ([tuts_left count] == 0) {
                [self set_cur_set_to:L_EASY];
                goto PICK_REGULAR;
            }
            picked = [tuts_left random];
            
        }
        [cur_used addObject:picked];
        return picked;

    } else {
        PICK_REGULAR:
        cur_set_ct++;
        while(true) {
            NSArray* possible_set = [self cur_levelset_get_unused];
            if (cur_set_ct%3==0) {
                return [levelsets[L_FILLER] random];
                
            } else if ([possible_set count] == 0 || cur_set_ct >= 4) {
                [self set_next_levelset];
                cur_set_ct++;
                
            } else {
                NSString* picked = [possible_set random];
                [cur_used addObject:picked];
                return picked;
            }
        }
        
    }
}

@end
