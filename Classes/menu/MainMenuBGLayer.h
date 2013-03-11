#import "cocos2d.h"
#import "GEventDispatcher.h"
#import "Resource.h"
#import "BackgroundObject.h"

@interface MainMenuBGLayer : CCLayer {
    CCSprite *fg;
    BackgroundObject *sky,*clouds,*hills;
}

+(MainMenuBGLayer*)cons;

-(void)update;

-(void)move_fg:(CGPoint)pt;
-(CGPoint)get_fg_pos;

@end