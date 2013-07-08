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
                                              pos:CGPointZero];
    [closebutton setPosition:[Common pct_of_obj:inventory_window pctx:0.975 pcty:0.95]];
	CCMenu *invmh = [CCMenu menuWithItems:closebutton, nil];
	[invmh setPosition:CGPointZero];
    [inventory_window addChild:invmh];
    [inventory_window setVisible:NO];
    
    CCMenu *itempanes = [CCMenu menuWithItems:nil];
	[itempanes setPosition:[Common pct_of_obj:inventory_window pctx:0.55 pcty:0.7]];
    
	float panewid = [InventoryItemPane invpane_size].size.width;
    SEL invpanesel[] = {@selector(invpane1_click),@selector(invpane2_click),@selector(invpane3_click),@selector(invpane4_click)};
    GameItem defaultpaneitem[] = {Item_Magnet,Item_Rocket,Item_Heart,Item_Shield};
    NSMutableArray *itempanesarr = [NSMutableArray array];
    for(int i = 0; i < 4; i++) {
        InventoryItemPane *ip = [InventoryItemPane cons_pt:ccp(-panewid*1.75+(panewid+5)*i,0)
                                                        cb:[Common cons_callback:self sel:invpanesel[i]]];
        [itempanes addChild:ip];
        [ip set_item:defaultpaneitem[i]];
        [itempanesarr addObject:ip];
    }
    [inventory_window addChild:itempanes];
    inventory_panes = itempanesarr;
    
	 
    CCSprite *divider = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"inventorydivider"]];
    [divider setPosition:ccp(windowsize.size.width*0.5,windowsize.size.height*0.475)];
    [inventory_window addChild:divider];
    
    CCSprite *player = [CCSprite spriteWithTexture:[Resource get_tex:[Player get_character]] rect:[FileCache get_cgrect_from_plist:[Player get_character] idname:@"run_0"]];
    [player setScale:0.8];
    [player setPosition:[Common pct_of_obj:inventory_window pctx:0.7 pcty:0.3]];
    [inventory_window addChild:player];
    
    CCSprite *boneicon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"boneicon"]];
    [boneicon setPosition:[Common pct_of_obj:inventory_window pctx:0.665 pcty:0.15]];
    [boneicon setScale:0.6];
    [inventory_window addChild:boneicon];
    bonectdsp = [Common cons_label_pos:[Common pct_of_obj:inventory_window pctx:0.695 pcty:0.15] color:ccc3(0, 0, 0) fontsize:15 str:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
    [bonectdsp setAnchorPoint:ccp(0,0.5)];
    [inventory_window addChild:bonectdsp];
    
	mainslot = [MainSlotItemPane cons_pt:[Common pct_of_obj:inventory_window pctx:0.87 pcty:0.26]
														cb:[Common cons_callback:self sel:@selector(slotpane0_click)]
													  slot:0];
    CCMenu *slotitems = [CCMenu menuWithItems:mainslot,NULL];
	[slotitems setPosition:CGPointZero];
	[inventory_window addChild:slotitems];
	
	
    infoname = [Common cons_label_pos:[Common pct_of_obj:inventory_window pctx:0.075 pcty:0.375]
								color:ccc3(205, 51, 51)
							 fontsize:20
								  str:@"Inventory"];
    [infoname setAnchorPoint:ccp(0,0.5)];
    [inventory_window addChild:infoname];
    
    NSString* maxstr = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
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
    [infodesc setPosition:[Common pct_of_obj:inventory_window pctx:0.075 pcty:0.215]];
    [inventory_window addChild:infodesc];
    
    [self update_invpane];
    return self;
}

-(void)update_invpane {
    [bonectdsp setString:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
    [mainslot set_item:[UserInventory get_current_gameitem]];
	for (InventoryItemPane *i in inventory_panes) {
		[i set_item:[i cur_item]];
	}
}

-(void)invpane1_click {[self invpane_click:0];}
-(void)invpane2_click {[self invpane_click:1];}
-(void)invpane3_click {[self invpane_click:2];}
-(void)invpane4_click {[self invpane_click:3];}

-(void)slotpane0_click {
	[UserInventory set_current_gameitem:Item_NOITEM];
	[self update_invpane];
}

-(void)invpane_click:(int)i {
    GameItem t = [(InventoryItemPane*)[inventory_panes objectAtIndex:i] cur_item];
    [infoname setString:[GameItemCommon name_from:t]];
    [infodesc setString:[GameItemCommon description_from:t]];
	
    if ([UserInventory get_upgrade_level:t] > 0) {
		[UserInventory set_current_gameitem:t];
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
    } else if (e.type == GeventType_MENU_UPDATE_INVENTORY) {
		[self update_invpane];
	}
}

@end
