#import "MainMenuInventoryLayer.h"
#import "Resource.h"
#import "FileCache.h"
#import "MenuCommon.h"
#import "UserInventory.h"
#import "GameItemCommon.h"
#import "Player.h"
#import "InventoryItemPane.h"

@implementation MainMenuInventoryLayer

+(MainMenuInventoryLayer*)cons {
    return [MainMenuInventoryLayer node];
}

-(id)init {
    self = [super init];
    
    [GEventDispatcher add_listener:self];
    
    CGRect windowsize = [FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_inventorypane"];
    inventory_window = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
                                              rect:windowsize];
    [inventory_window setPosition:[Common screen_pctwid:0.5 pcthei:0.55]];
    [self addChild:inventory_window];
    
    CCMenuItem *closebutton = [MenuCommon item_from:TEX_NMENU_ITEMS
                                             rect:@"nmenu_closebutton"
                                              tar:self sel:@selector(close)
                                              pos:ccp(windowsize.size.width/2.25,windowsize.size.height/4)];
    
    [inventory_window addChild:[CCMenu menuWithItems:closebutton, nil]];
    [inventory_window setVisible:NO];
    
    CCMenu *itempanes = [CCMenu menuWithItems:nil];
    float panewid = [InventoryItemPane invpane_size].size.width;
    SEL invpanesel[] = {@selector(invpane1_click),@selector(invpane2_click),@selector(invpane3_click),@selector(invpane4_click)};
    GameItem defaultpaneitem[] = {Item_Magnet,Item_Rocket,Item_Heart,Item_Shield};
    NSMutableArray *itempanesarr = [NSMutableArray array];
    for(int i = 0; i < 4; i++) {
        InventoryItemPane *ip = [InventoryItemPane cons_pt:ccp(-panewid*1.75+(panewid+5)*i,0)
                                                        cb:[Common cons_callback:self sel:invpanesel[i]]];
        [itempanes addChild:ip];
        [ip set_item:defaultpaneitem[i] ct:0];
        [itempanesarr addObject:ip];
    }
    [inventory_window addChild:itempanes];
    inventory_panes = itempanesarr;
    
    CCSprite *divider = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"inventorydivider"]];
    [divider setPosition:ccp(windowsize.size.width*0.5,windowsize.size.height*0.475)];
    [inventory_window addChild:divider];
    
    CCSprite *player = [CCSprite spriteWithTexture:[Resource get_tex:[Player get_character]] rect:[FileCache get_cgrect_from_plist:[Player get_character] idname:@"run_0"]];
    [player setScale:0.8];
    [player setPosition:ccp(windowsize.size.width*0.475,windowsize.size.height*0.3)];
    [inventory_window addChild:player];
    
    CCSprite *boneicon = [CCSprite spriteWithTexture:[Resource get_aa_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"boneicon"]];
    [boneicon setPosition:ccp(windowsize.size.width*0.46,windowsize.size.height*0.15)];
    [boneicon setScale:0.6];
    [inventory_window addChild:boneicon];
    bonectdsp = [Common cons_label_pos:ccp(windowsize.size.width*0.49,windowsize.size.height*0.15) color:ccc3(0, 0, 0) fontsize:15 str:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
    [bonectdsp setAnchorPoint:ccp(0,0.5)];
    [inventory_window addChild:bonectdsp];
    
    NSMutableArray* tslots = [NSMutableArray array];
    MainSlotItemPane *mainslot = [MainSlotItemPane cons_pt:ccp(-50,-15) cb:[Common cons_callback:self sel:@selector(slotpane0_click)] slot:0];
    CCMenu *slotitems = [CCMenu menuWithItems:nil];
    [tslots addObject:mainslot];
    [slotitems addChild:mainslot];
    
    panewid = [SlotItemPane invpane_size].size.width;
    float panehei = [SlotItemPane invpane_size].size.height;
    SEL slotsel[] = {@selector(slotpane0_click),@selector(slotpane1_click),@selector(slotpane2_click),@selector(slotpane3_click),@selector(slotpane4_click),@selector(slotpane5_click),@selector(slotpane6_click)};
    for(int i = 0; i < 6; i++) {
        SlotItemPane *slp = [SlotItemPane cons_pt:ccp((panewid+12)*(i%3),-(panehei+12)*(i/3)) cb:[Common cons_callback:self sel:slotsel[i+1]] slot:i+1];
        [slotitems addChild:slp];
        [tslots addObject:slp];
    }
    [slotitems setPosition:ccp(windowsize.size.width*0.75,windowsize.size.height*0.35)];
    [inventory_window addChild:slotitems];
    slot_panes = tslots;
    
    infoname = [Common cons_label_pos:ccp(windowsize.size.width*0.075,windowsize.size.height*0.375) color:ccc3(205, 51, 51) fontsize:20 str:@"Inventory"];
    [infoname setAnchorPoint:ccp(0,0.5)];
    [inventory_window addChild:infoname];
    
    NSString* maxstr = @"aaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
                              lineBreakMode:UILineBreakModeWordWrap];
    
    infodesc = [CCLabelTTF labelWithString:@"Equip to use ingame. Get items and more slots at the store!"
                                dimensions:actualSize
                                 alignment:UITextAlignmentLeft
                                  fontName:@"Carton Six"
                                  fontSize:15];
    [infodesc setColor:ccc3(0,0,0)];
    [infodesc setAnchorPoint:ccp(0,0.5)];
    [infodesc setPosition:ccp(windowsize.size.width*0.075,windowsize.size.height*0.215)];
    [inventory_window addChild:infodesc];
    
    [self update_invpane];
    return self;
}

-(void)update_invpane {
    [bonectdsp setString:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
    for (InventoryItemPane *i in inventory_panes) {
        [i set_item:[i cur_item] ct:[UserInventory get_inventory_ct_of:[i cur_item]]];
    }
    for (SlotItemPane *i in slot_panes) {
        [i set_locked:([i get_slot] > [UserInventory get_num_slots_unlocked])];
        [i set_item:[UserInventory get_item_at_slot:[i get_slot]] ct:1];
    }
}

-(void)invpane1_click {[self invpane_click:0];}
-(void)invpane2_click {[self invpane_click:1];}
-(void)invpane3_click {[self invpane_click:2];}
-(void)invpane4_click {[self invpane_click:3];}

-(void)slotpane0_click {[self slotpane_click:0];}
-(void)slotpane1_click {[self slotpane_click:1];}
-(void)slotpane2_click {[self slotpane_click:2];}
-(void)slotpane3_click {[self slotpane_click:3];}
-(void)slotpane4_click {[self slotpane_click:4];}
-(void)slotpane5_click {[self slotpane_click:5];}
-(void)slotpane6_click {[self slotpane_click:6];}

-(void)slotpane_click:(int)i {
    SlotItemPane *s = [slot_panes objectAtIndex:i];
    if (s.cur_item != Item_NOITEM && i <= [UserInventory get_num_slots_unlocked]) {
        GameItem gi = s.cur_item;
        [UserInventory set_item:Item_NOITEM to_slot:i];
        [UserInventory set_inventory_ct_of:gi to:[UserInventory get_inventory_ct_of:gi]+1];
    }
    [self update_invpane];
}

-(void)invpane_click:(int)i {
    GameItem t = [(InventoryItemPane*)[inventory_panes objectAtIndex:i] cur_item];
    [infoname setString:[GameItemCommon name_from:t]];
    [infodesc setString:[GameItemCommon description_from:t]];
    if ([UserInventory get_inventory_ct_of:t] > 0 && [UserInventory get_lowest_empty_slot] != -1) {
        [UserInventory set_inventory_ct_of:t to:[UserInventory get_inventory_ct_of:t]-1];
        [UserInventory set_item:t to_slot:[UserInventory get_lowest_empty_slot]];
    }
    [self update_invpane];
}



-(void)open {
    [inventory_window setVisible:YES];
}

-(void)close {
    [inventory_window setVisible:NO];
    [GEventDispatcher push_event:[GEvent cons_type:GEVentType_MENU_CLOSE_INVENTORY]];
}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_INVENTORY) {
        [self open];
    }
}

@end
