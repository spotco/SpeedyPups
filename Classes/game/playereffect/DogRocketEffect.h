#import "PlayerEffectParams.h"

@interface DogRocketEffect : PlayerEffectParams {
    int fulltime;
}

+(DogRocketEffect*)cons_from:(PlayerEffectParams*)base time:(int)time;

@end
