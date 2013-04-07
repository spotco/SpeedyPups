#import <Foundation/Foundation.h>

typedef enum {
    ChallengeType_COLLECT_BONES,
    ChallengeType_TIMED,
    ChallengeType_FIND_SECRET
} ChallengeType;

@interface ChallengeInfo : NSObject

+(ChallengeInfo*)cons_name:(NSString*)map_name type:(ChallengeType)type ct:(int)ct reward:(int)rw;
@property(readwrite,strong) NSString* map_name;
@property(readwrite,assign) ChallengeType type;
@property(readwrite,assign) int ct,reward;

@end

@interface ChallengeRecord : NSObject

+(int)get_num_challenges;
+(ChallengeInfo*)get_challenge_number:(int)i;

+(BOOL)get_beaten_challenge:(int)i;
+(void)set_beaten_challenge:(int)i to:(BOOL)k;
+(int)get_highest_available_challenge;

@end