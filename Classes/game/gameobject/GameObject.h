#import "CCNode.h"
#import "Player.h"
#import "GameRenderImplementation.h"
#import "GEventDispatcher.h"
@class GameEngineLayer;
@class ChallengeInfo;

@interface GameObject : CCSprite {
    BOOL active,do_render;
    CCSprite *__strong img;
}

@property(readwrite,assign) BOOL active,do_render;
@property(readwrite,strong) CCSprite *img;

-(void)update:(Player*)player g:(GameEngineLayer *)g;
-(HitRect) get_hit_rect;
-(void)set_active:(BOOL)t_active;
-(int)get_render_ord;
-(void)reset;
-(void)check_should_render:(GameEngineLayer *)g;
-(void)notify_challenge_mode:(ChallengeInfo*)c;

-(Island*)get_connecting_island:(NSMutableArray*)islands;

+(void)pct;

@end
