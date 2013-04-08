#import "PauseUI.h"
#import "Common.h"
#import "Resource.h"
#import "MenuCommon.h"
#import "UserInventory.h"
#import "GameEngineLayer.h"
#import "UICommon.h"
#import "UILayer.h"

#import "InventoryItemPane.h"

@implementation PauseUI

+(PauseUI*)cons {
    return [PauseUI node];
}

-(id)init {
    self = [super init];
    
    ccColor4B c = {50,50,50,220};
    CGSize s = [[UIScreen mainScreen] bounds].size;
    CCNode *pause_ui = [CCLayerColor layerWithColor:c width:s.height height:s.width];
    pause_ui.anchorPoint = ccp(0,0);
    [pause_ui setPosition:ccp(0,0)];
    
    [pause_ui addChild:[Common cons_label_pos:[Common screen_pctwid:0.5 pcthei:0.8]
                                        color:ccc3(255, 255, 255)
                                     fontsize:45
                                          str:@"paused"]];
    
    CCSprite *timebg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfoblank"]];
    [timebg setPosition:[Common screen_pctwid:0.75 pcthei:0.6]];
    [pause_ui addChild:timebg];
    
    CCSprite *bonesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfobones"]];
    [bonesbg setPosition:[Common screen_pctwid:0.75 pcthei:0.45]];
    [pause_ui addChild:bonesbg];
    
    CCSprite *livesbg = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"pauseinfolives"]];
    [livesbg setPosition:[Common screen_pctwid:0.75 pcthei:0.3]];
    [pause_ui addChild:livesbg];
    
    pause_time_disp = [Common cons_label_pos:[Common screen_pctwid:0.75 pcthei:0.6]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0:00"];
    [pause_ui addChild:pause_time_disp];
    
    pause_bones_disp= [Common cons_label_pos:[Common screen_pctwid:0.75 pcthei:0.45]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0"];
    [pause_ui addChild:pause_bones_disp];
    
    pause_lives_disp= [Common cons_label_pos:[Common screen_pctwid:0.75 pcthei:0.3]
                                       color:ccc3(255, 255, 255)
                                    fontsize:30
                                         str:@"0"];
    [pause_ui addChild:pause_lives_disp];
    
    CCMenuItem *retrybutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"retrybutton" tar:self sel:@selector(retry)
                                                pos:[Common screen_pctwid:0.5 pcthei:0.6]];
    
    CCMenuItem *playbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"playbutton" tar:self sel:@selector(unpause)
                                               pos:[Common screen_pctwid:0.35 pcthei:0.6]];
    
    CCMenuItem *backbutton = [MenuCommon item_from:TEX_UI_INGAMEUI_SS rect:@"backbutton" tar:self sel:@selector(exit_to_menu)
                                               pos:[Common screen_pctwid:0.20 pcthei:0.6]];
    
    CCMenu *pausebuttons = [CCMenu menuWithItems:retrybutton,playbutton,backbutton, nil];
    [pausebuttons setPosition:ccp(0,0)];
    [pause_ui addChild:pausebuttons];
    
    NSMutableArray* tslots = [NSMutableArray array];
    MainSlotItemPane *mainslot = [MainSlotItemPane cons_pt:ccp(-50,-15) cb:[Common cons_callback:self sel:@selector(slotpane0_click)] slot:0];
    CCMenu *slotitems = [CCMenu menuWithItems:nil];
    [tslots addObject:mainslot];
    [slotitems addChild:mainslot];
    
    float panewid = [SlotItemPane invpane_size].size.width;
    float panehei = [SlotItemPane invpane_size].size.height;
    SEL slotsel[] = {@selector(slotpane0_click),@selector(slotpane1_click),@selector(slotpane2_click),@selector(slotpane3_click),@selector(slotpane4_click),@selector(slotpane5_click),@selector(slotpane6_click)};
    for(int i = 0; i < 6; i++) {
        SlotItemPane *slp = [SlotItemPane cons_pt:ccp((panewid+12)*(i%3),-(panehei+12)*(i/3)) cb:[Common cons_callback:self sel:slotsel[i+1]] slot:i+1];
        [slotitems addChild:slp];
        [tslots addObject:slp];
    }
    [slotitems setPosition:[Common screen_pctwid:0.35 pcthei:0.4]];
    [pause_ui addChild:slotitems];
    pause_menu_item_slots = tslots;
    
    [self addChild:pause_ui z:1];
    
    return self;
}

-(void)update_item_slots {
    for (SlotItemPane *i in pause_menu_item_slots) {
        if ([i get_slot] <= [UserInventory get_num_slots_unlocked]) {
            [i set_item:[UserInventory get_item_at_slot:[i get_slot]] ct:1];
        } else {
            [i set_locked:YES];
        }
    }
}

-(void)update_labels_lives:(NSString *)lives bones:(NSString *)bones time:(NSString *)time {
    [pause_lives_disp setString:lives];
    [pause_bones_disp setString:bones];
    [pause_time_disp setString:time];
}

-(void)retry {
    [(UILayer*)[self parent] retry];
}

-(void)unpause {
    [(UILayer*)[self parent] unpause];
}

-(void)exit_to_menu {
    [(UILayer*)[self parent] exit_to_menu];
}

-(void)slotpane_click:(int)i {
    UILayer *p = (UILayer*)[self parent];
    [p slotpane_use:i];
}

-(void)slotpane0_click {[self slotpane_click:0];}
-(void)slotpane1_click {[self slotpane_click:1];}
-(void)slotpane2_click {[self slotpane_click:2];}
-(void)slotpane3_click {[self slotpane_click:3];}
-(void)slotpane4_click {[self slotpane_click:4];}
-(void)slotpane5_click {[self slotpane_click:5];}
-(void)slotpane6_click {[self slotpane_click:6];}

@end
