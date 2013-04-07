#import "Challenge.h"
#import "DataStore.h"

@implementation ChallengeInfo

@synthesize map_name;
@synthesize ct;
@synthesize type,reward;

+(ChallengeInfo*)cons_name:(NSString *)map_name type:(ChallengeType)type ct:(int)ct reward:(int)rw {
    ChallengeInfo *i = [[ChallengeInfo alloc] init];
    [i setMap_name:map_name];
    [i setType:type];
    [i setCt:ct];
    [i setReward:rw];
    return i;
}

@end

@implementation ChallengeRecord

static NSArray* _CHALLENGES;

+(void)initialize {
    _CHALLENGES = @[
        [ChallengeInfo cons_name:@"classic_trickytreas" type:ChallengeType_COLLECT_BONES ct:28 reward:1],
        [ChallengeInfo cons_name:@"classic_trickytreas" type:ChallengeType_COLLECT_BONES ct:28 reward:1],
        [ChallengeInfo cons_name:@"classic_trickytreas" type:ChallengeType_COLLECT_BONES ct:28 reward:1],
        [ChallengeInfo cons_name:@"classic_trickytreas" type:ChallengeType_COLLECT_BONES ct:28 reward:1],
        [ChallengeInfo cons_name:@"classic_trickytreas" type:ChallengeType_COLLECT_BONES ct:28 reward:1],
        [ChallengeInfo cons_name:@"classic_trickytreas" type:ChallengeType_COLLECT_BONES ct:28 reward:1],
        [ChallengeInfo cons_name:@"classic_trickytreas" type:ChallengeType_COLLECT_BONES ct:28 reward:1],
        [ChallengeInfo cons_name:@"classic_trickytreas" type:ChallengeType_COLLECT_BONES ct:28 reward:1],
        [ChallengeInfo cons_name:@"classic_trickytreas" type:ChallengeType_COLLECT_BONES ct:28 reward:1],
        [ChallengeInfo cons_name:@"classic_trickytreas" type:ChallengeType_COLLECT_BONES ct:28 reward:1],
        [ChallengeInfo cons_name:@"classic_trickytreas" type:ChallengeType_COLLECT_BONES ct:28 reward:1]
    ];
}

+(int)get_num_challenges {
    return [_CHALLENGES count];
}

+(ChallengeInfo*)get_challenge_number:(int)i {
    if (i >= [self get_num_challenges]) [NSException raise:@"Challenge Not Found:" format:@"%d",i];
    return _CHALLENGES[i];
}

+(BOOL)get_beaten_challenge:(int)i {
    return [DataStore get_int_for_key:[self challenge_to_key:i]];
}

+(void)set_beaten_challenge:(int)i to:(BOOL)k {
    [DataStore set_key:[self challenge_to_key:i] int_value:k];
}

+(NSString*)challenge_to_key:(int)i {
    return [NSString stringWithFormat:@"challenge_%d",i];
}

+(int)get_highest_available_challenge {
    int max = 0;
    for (int i = 0; i<[self get_num_challenges]; i++) {
        if ([self get_beaten_challenge:i]) {
            max = i+1;
        }
    }
    if (max > [self get_num_challenges]) {
        max = [self get_num_challenges];
    }
    return max;
}

@end
