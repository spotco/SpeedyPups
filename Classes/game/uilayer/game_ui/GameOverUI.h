#import "cocos2d.h"

@interface GameOverUI : CCSprite {
    CCLabelTTF *bone_disp,*time_disp;
}

+(GameOverUI*)cons;
-(void)set_bones:(NSString*)bones time:(NSString*)time;

@end
