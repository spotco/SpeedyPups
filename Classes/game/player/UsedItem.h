#import "GameObject.h"
@class Player;

@interface UsedItem : GameObject {
    CGPoint cur_offset;
}
+(UsedItem*)cons;
@end
