#import "GameObject.h"
@class TutorialAnim;

typedef enum {
    TutorialProf_FLYIN,
    TutorialProf_MESSAGE,
    TutorialProf_FLYOUT
} TutorialProfState;

@interface TutorialProf : GameObject {
    CCSprite *body,*messagebubble;
    TutorialAnim *messageanim;
    CGPoint body_rel_pos,vibration;
    float vibration_ct;
    TutorialProfState curstate;
    
    GameObject *shadow;
    
    int ct;
}

+(TutorialProf*)cons_msg:(NSString *)msg ;

@end
