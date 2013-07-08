#import "UILayer.h"
#import "Player.h"
#import "MenuCommon.h"
#import "InventoryItemPane.h"
#import "UserInventory.h"
#import "IngameUI.h"
#import "PauseUI.h"
#import "AskContinueUI.h"
#import "UICommon.h"
#import "GameOverUI.h"
#import "ChallengeEndUI.h" 
#import "GameModeCallback.h" 
#import "CoinCollectUIAnimation.h"

@implementation UILayer

+(UILayer*)cons_with_gamelayer:(GameEngineLayer *)g {
    UILayer* u = [UILayer node];
    [GEventDispatcher add_listener:u];
    [u set_gameengine:g];
    [u cons];
    return u;
}

-(void)set_this_visible:(id)t {
    for (CCNode *i in @[ingameui,pauseui,askcontinueui,gameoverui,challengeendui]) {
        [i setVisible:i==t];
    }
    [ingameuianimholder setVisible:t == ingameui];
}

-(void)cons {
    ingameui = [IngameUI cons];
    [self addChild:ingameui];
    [ingameui setVisible:NO];
    
    pauseui = [PauseUI cons];
    [self addChild:pauseui];
    [pauseui setVisible:NO];
    
    askcontinueui = [AskContinueUI cons];
    [self addChild:askcontinueui];
    [askcontinueui setVisible:NO];
    
    gameoverui = [GameOverUI cons];
    [self addChild:gameoverui];
    [gameoverui setVisible:NO];
    
    challengeendui = [ChallengeEndUI cons];
    [self addChild:challengeendui];
    [challengeendui setVisible:NO];
    
    ingameuianimholder = [CCSprite node];
    [self addChild:ingameuianimholder];
    
    
    [self update_items];
    ingame_ui_anims = [NSMutableArray array];
    self.isTouchEnabled = YES;
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_GAME_TICK) {
        [self set_this_visible:ingameui];
        [self update];
        
    } else if (e.type == GEventType_UIANIM_TICK) {
        [self set_this_visible:NULL];
        
    } else if (e.type == GEventType_CHALLENGE) {
        [pauseui set_challenge_msg:
         [NSString stringWithFormat:@"Challenge: %@",
         [((ChallengeInfo*)[e get_value:@"challenge"]) to_string]]];
    
    } else if (e.type == GEventType_CHALLENGE_COMPLETE) {
        [challengeendui update_passed:e.i1
                                 info:[e get_value:@"challenge"]
                                bones:ingameui.bones_disp.string
                                 time:ingameui.time_disp.string
                              secrets:[NSString stringWithFormat:@"%d",[game_engine_layer get_num_secrets]]];
    
    } else if (e.type == GEventType_LOAD_CHALLENGE_COMPLETE_MENU) {
        [self set_this_visible:challengeendui];
        
    } else if (e.type == GEventType_COLLECT_BONE) {
        [self start_bone_collect_anim];
        
    } else if (e.type == GEventType_GET_COIN) {
        [self start_coin_collect_anim];
        
    } else if (e.type == GEventType_ASK_CONTINUE) {
        [self ask_continue];
        
    } else if (e.type == GEventType_SHOW_ENEMYAPPROACH_WARNING) {
        [ingameui set_enemy_alert_ui_ct:75];
    
    } else if (e.type == GEventType_START_INTIAL_ANIM) {
        [self start_initial_anim];
        
    } else if (e.type == GEventType_ITEM_DURATION_PCT) {
        [ingameui set_item_duration_pct:e.f1];
        
    }
}

-(void)update {
    [ingameui update:game_engine_layer];
    
    NSMutableArray *toremove = [[NSMutableArray alloc] init];
    for (UIIngameAnimation *i in ingame_ui_anims) {
        [i update];
        if (i.ct <= 0) {
            [ingameuianimholder removeChild:i cleanup:YES];
            [toremove addObject:i];
        }
    }
    [ingame_ui_anims removeObjectsInArray:toremove];
    [toremove removeAllObjects];
}

-(void)start_bone_collect_anim {
    BoneCollectUIAnimation* b = [BoneCollectUIAnimation cons_start:[UICommon player_approx_position:game_engine_layer] end:ccp(0,[[UIScreen mainScreen] bounds].size.width)];
    [ingameuianimholder addChild:b];
    [ingame_ui_anims addObject:b];
}

-(void)start_coin_collect_anim {
    CoinCollectUIAnimation* c = [CoinCollectUIAnimation cons_start:[UICommon player_approx_position:game_engine_layer] end:ccp(0,[[UIScreen mainScreen] bounds].size.width)];
    [ingameuianimholder addChild:c];
    [ingame_ui_anims addObject:c];
}

-(void)ask_continue {
    [self set_this_visible:askcontinueui];
    [askcontinueui start_countdown:[game_engine_layer get_current_continue_cost]];
}

-(void)update_items {
    [ingameui update_item_slot];
    [pauseui update_item_slot];

}

-(void)itemslot_use {
	if ([UserInventory get_current_gameitem] != Item_NOITEM) {
		GameItem i = [UserInventory get_current_gameitem];
		[GEventDispatcher push_event:[[GEvent cons_type:GEventType_USE_ITEM] add_i1:i i2:0]];
	}
}

-(void)slotpane_use:(int)i {
    NSLog(@"slotpane use, removeme");
}

-(void)pause {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_PAUSE]];
    [pauseui update_labels_lives:ingameui.lives_disp.string bones:ingameui.bones_disp.string time:ingameui.time_disp.string];
    [self set_this_visible:pauseui];
    [[CCDirector sharedDirector] pause];
}

-(void)unpause {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_UNPAUSE]];
    [self set_this_visible:ingameui];
    [[CCDirector sharedDirector] resume];
}

-(void)exit_to_menu {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_QUIT]];
    [GEventDispatcher dispatch_events];
}

-(void)play_again {
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_PLAYAGAIN_AUTOLEVEL]];
}

-(void)set_retry_callback:(GameModeCallback *)c {
    retry_cb = c;
}

-(void)retry {
    if (retry_cb != NULL) {
        [GEventDispatcher push_event:[[GEvent cons_type:GEventType_RETRY_WITH_CALLBACK] add_key:@"callback" value:retry_cb]];
        [GEventDispatcher dispatch_events];
    } else {
        NSLog(@"retry cb is null");
    }
}

-(void)continue_game {
    [game_engine_layer incr_current_continue_cost];
    [self set_this_visible:ingameui];
    [GEventDispatcher push_event:[GEvent cons_type:GEventType_CONTINUE_GAME]];
}

-(void)to_gameover_menu {
    [gameoverui set_bones:ingameui.bones_disp.string time:ingameui.time_disp.string];
    [self set_this_visible:gameoverui];
}

-(void)start_initial_anim {
    game_engine_layer.current_mode = GameEngineLayerMode_UIANIM;
    [ingameui setVisible:NO];
    curanim = [GameStartAnim cons_with_callback:[Common cons_callback:self sel:@selector(end_initial_anim)]];
    [self addChild:curanim];
}
-(void)end_initial_anim {
    curanim = NULL;
    game_engine_layer.current_mode = GameEngineLayerMode_GAMEPLAY;
    [ingameui setVisible:YES];
    [self removeChild:curanim cleanup:YES];
}

-(void)set_gameengine:(GameEngineLayer*)ref {
    game_engine_layer = ref;
}

-(void)dealloc {
    [ingame_ui_anims removeAllObjects];
    [pauseui removeAllChildrenWithCleanup:YES];
    [ingameui removeAllChildrenWithCleanup:YES];
    [askcontinueui removeAllChildrenWithCleanup:YES];
    [self removeAllChildrenWithCleanup:YES];
}


@end