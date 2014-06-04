#import "CCSprite.h"
#import "GEventDispatcher.h"

@interface CharSelAnim : CCSprite <GEventListener>

+(CharSelAnim*)cons_pos:(CGPoint)pt speed:(float)speed ;

@end
