#import "CCSprite.h"
@class CCLabelTTF;
@class ChallengeInfo;
@class CCMenuItem;

@interface ChallengeEndUI : CCSprite {
    CCSprite *wlicon;
    CCLabelTTF *bone_disp, *time_disp, *secrets_disp, *infodesc, *reward_disp;
	CCMenuItem *nextbutton;
	int curchallenge;
	
	BOOL sto_passed;
	
	CCSprite *particleholder;
	BOOL has_scheduler;
	NSMutableArray *particles;
	NSMutableArray *particles_tba;
	
	CCSprite *left_curtain, *right_curtain, *bg_curtain;
	CGPoint left_curtain_tpos, right_curtain_tpos, bg_curtain_tpos;
}

+(ChallengeEndUI*)cons;
-(BOOL)get_sto_passed;
-(void)update_passed:(BOOL)p info:(ChallengeInfo*)ci bones:(NSString*)bones time:(NSString*)time secrets:(NSString*)secrets;
-(void)start_fireworks_effect;

@end
