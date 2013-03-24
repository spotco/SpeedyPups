#import "CCSprite.h"

@interface TutorialAnim : CCSprite {
    CCSprite *body,*hand,*effect;
    CGRect *frames,*effectframes;
    CGPoint *handposframes;
    int animlen,curframe,animspeed;
    
    int animdelayct;
}

+(TutorialAnim*)cons_msg:(NSString*)msg;
-(void)update ;

@end
