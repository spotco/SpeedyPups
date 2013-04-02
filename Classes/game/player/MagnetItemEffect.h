#import "GameObject.h"

@interface MagnetItemEffect : GameObject <GEventListener> {
    NSArray* particles;
    BOOL kill;
}

+(MagnetItemEffect*)cons;

@end
