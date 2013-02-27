#import "BackgroundObject.h"

typedef enum {
    MODE_DAY,
    MODE_NIGHT,
    MODE_DAY_TO_NIGHT,
    MODE_NIGHT_TO_DAY
} BGTimeManagerMode;


@interface BGTimeManager : BackgroundObject {
    CCSprite *sun,*moon;
    int delayct;
    BGTimeManagerMode curmode;
}

+(BGTimeManager*)cons;

@end
