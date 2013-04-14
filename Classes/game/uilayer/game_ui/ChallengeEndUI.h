#import "CCSprite.h"
@class CCLabelTTF;
@class ChallengeInfo;

@interface ChallengeEndUI : CCSprite {
    CCSprite *wlicon;
    CCLabelTTF *bone_disp, *time_disp, *secrets_disp, *infodesc, *reward_disp;
}

+(ChallengeEndUI*)cons;
-(void)update_passed:(BOOL)p info:(ChallengeInfo*)ci bones:(NSString*)bones time:(NSString*)time secrets:(NSString*)secrets;

@end
