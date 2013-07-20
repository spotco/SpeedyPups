#import "CCLayer.h"
#import "Resource.h"
#import "GameEngineLayer.h"
#import "GameStartAnim.h"
#import "UIIngameAnimation.h"
#import "BoneCollectUIAnimation.h"
#import "GEventDispatcher.h"
@class IngameUI;
@class PauseUI;
@class AskContinueUI;
@class GameOverUI;
@class ChallengeEndUI;
@class GameModeCallback;

@interface UILayer : CCLayer <GEventListener> {
    GameEngineLayer* game_engine_layer;
    IngameUI *ingameui;
    PauseUI *pauseui;
    AskContinueUI *askcontinueui;
    GameOverUI *gameoverui;
    ChallengeEndUI *challengeendui;
    CCSprite *ingameuianimholder;
    
    GameModeCallback *retry_cb;
    UIAnim *curanim;
    NSMutableArray *ingame_ui_anims;
}

+(UILayer*)cons_with_gamelayer:(GameEngineLayer*)g;

-(void)set_retry_callback:(GameModeCallback*)c;

-(void)start_initial_anim;
-(void)pause;
-(void)unpause;
-(void)itemslot_use;
-(void)slotpane_use:(int)i;

-(void)exit_to_menu;
-(void)play_again;
-(void)retry;
-(void)run_cb:(GameModeCallback*)cb;
-(void)continue_game;

-(void)to_gameover_menu;

@end
