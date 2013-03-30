#import "PlayerEffectParams.h"

@interface FlashEffect : PlayerEffectParams {
    BOOL toggle;
    int ct;
    Player* __unsafe_unretained pl;
}

+(FlashEffect*)cons_from:(PlayerEffectParams*)base time:(int)time;

@end
