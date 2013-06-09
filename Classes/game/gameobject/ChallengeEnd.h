#import "GameObject.h"
@class ChallengeInfo;

@interface ChallengeEnd : GameObject {
    ChallengeInfo *info;
    BOOL procced;
}

+(ChallengeEnd*)cons_pt:(CGPoint)pt;

@end
