#import "ShopManager.h"
#import "ShopItemPane.h"

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
				 buy:(CCNode *)tbuy{
	
	speechbub = tspeechbub;
	infotitle = tinfotitle;
	infodesc = tinfodesc;
	infoprice = tprice;
	itempanes = titempanes;
	next = tnext;
	prev = tprev;
	buy = tbuy;
}

-(void)update {
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
		[buy setVisible:YES];
		[infotitle setString:selected_item.name];
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

-(void)tab_items {
	current_tab = ShopTab_ITEMS;
	cur_tab_offset = 0;
	cur_tab_items = [ShopRecord get_items_for_tab:current_tab];
	[self update];
}

-(void)tab_characters {
	current_tab = ShopTab_CHARACTERS;
	cur_tab_offset = 0;
	cur_tab_items = [ShopRecord get_items_for_tab:current_tab];
	[self update];
}

-(void)tab_misc {
	current_tab = ShopTab_MISC;
	cur_tab_offset = 0;
	cur_tab_items = [ShopRecord get_items_for_tab:current_tab];
	[self update];
}

-(void)buy_current {
	
}

@end
