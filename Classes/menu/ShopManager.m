#import "ShopManager.h"
#import "ShopItemPane.h"
#import "UserInventory.h"
#import "GEventDispatcher.h"

@implementation ShopManager

+(ShopManager*)cons {
	return [[ShopManager alloc] init];
}

-(void)set_speechbub:(CCSprite*)tspeechbub
		   infotitle:(CCLabelTTF*)tinfotitle
			infodesc:(CCLabelTTF*)tinfodesc
			   price:(CCLabelTTF*)tprice
		   itempanes:(NSArray*)titempanes
				next:(CCNode *)tnext
				prev:(CCNode *)tprev
				 buy:(CCNode *)tbuy
		curbonesdisp:(CCLabelTTF *)tcurbones{
	
	speechbub = tspeechbub;
	infotitle = tinfotitle;
	infodesc = tinfodesc;
	infoprice = tprice;
	itempanes = titempanes;
	next = tnext;
	prev = tprev;
	buy = tbuy;
	curbones = tcurbones;
}

-(void)update {
	cur_tab_items = [ShopRecord get_items_for_tab:current_tab];
	[curbones setString:[NSString stringWithFormat:@"%d",[UserInventory get_current_bones]]];
	
	for(int i = 0; i < [itempanes count]; i++) {
		ShopItemPane *cur = [itempanes objectAtIndex:i];
		int irel = cur_tab_offset + i;
		if (irel < [cur_tab_items count]) {
			[cur setVisible:YES];
			ItemInfo *imo = [cur_tab_items objectAtIndex:irel];
			[cur set_tex:imo.tex rect:imo.rect price:imo.price];
			
		} else {
			[cur setVisible:NO];
		}
	}
	[prev setVisible:cur_tab_offset!=0];
	[next setVisible:cur_tab_offset+3<[cur_tab_items count]];
	if (selected_item == NULL) {
		[speechbub setVisible:NO];
		[buy setVisible:NO];
	} else {
		[speechbub setVisible:YES];
		
		if (selected_item.price <= [UserInventory get_current_bones]) {
			[buy setVisible:YES];
		} else {
			[buy setVisible:NO];
		}
		
		if (selected_item.action == ShopAction_BUY_ITEM_UPGRADE) {
			GameItem i = [selected_item.action_key integerValue];
			[infotitle setString:[GameItemCommon name_from:i]];
		} else {
			[infotitle setString:selected_item.name];
		}
		[infodesc setString:selected_item.desc];
		[infoprice setString:[NSString stringWithFormat:@"%d",selected_item.price]];
	}
}

-(void)reset {
	current_tab = ShopTab_ITEMS;
	cur_tab_offset = 0;
	cur_tab_items = [ShopRecord get_items_for_tab:current_tab];
	[self update];
}

-(void)select_pane:(int)i {
	ItemInfo *imo = [cur_tab_items objectAtIndex:i+cur_tab_offset];
	selected_item = imo;
	[self update];
}

-(void)pane_next {
	cur_tab_offset+=3;
	[self update];
}

-(void)pane_prev {
	cur_tab_offset-=3;
	[self update];
}

-(void)tab:(ShopTab)t {
	current_tab = t;
	cur_tab_offset = 0;
	selected_item = NULL;
	[self update];
}

-(void)buy_current {
	if (selected_item != NULL) {
		
		if ([UserInventory get_current_bones] < selected_item.price) {
			return;
		} else {
			[UserInventory add_bones:-selected_item.price];
		}
		
		if (selected_item.action == ShopAction_BUY_ITEM) {
			GameItem i = [selected_item.action_key integerValue];
			[UserInventory set_inventory_ct_of:i to:[UserInventory get_inventory_ct_of:i]+1];
			
		} else if (selected_item.action == ShopAction_BUY_ITEM_UPGRADE) {
			GameItem i = [selected_item.action_key integerValue];
			[UserInventory upgrade:i];
			if (![UserInventory can_upgrade:i]) selected_item = NULL;
			
		} else if (selected_item.action == ShopAction_BUY_SLOT_UPGRADE) {
			[UserInventory unlock_slot];
			if (![UserInventory can_unlock_slot]) selected_item = NULL;
			
		} else if (selected_item.action == ShopAction_UNLOCK_CHARACTER) {
			[UserInventory unlock_character:selected_item.action_key];
			selected_item = NULL;
		}
		
		[GEventDispatcher push_event:[GEvent cons_type:GeventType_MENU_UPDATE_INVENTORY]];
		[self update];
	}
}

@end
