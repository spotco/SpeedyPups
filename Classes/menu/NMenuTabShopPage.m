#import "NMenuTabShopPage.h"
#import "Shopkeeper.h"
#import "MenuCommon.h"
#import "ShopTabTouchButton.h"
#import "ShopListTouchButton.h"
#import "UserInventory.h"
#import "Particle.h"
#import "ShopBuyBoneFlyoutParticle.h"
#import "ShopBuyFlyoffTextParticle.h"

@implementation NMenuTabShopPage

+(NMenuTabShopPage*)cons {
	return [NMenuTabShopPage node];
}

-(id)init {
	self = [super init];
	
	[GEventDispatcher add_listener:self];
	scroll_items = [NSMutableArray array];
	current_tab = ShopTab_UPGRADE;
	[self addChild:[Shopkeeper cons_pt:[Common screen_pctwid:0.1 pcthei:0.45]]];
	[self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_shopsign" pos:[Common screen_pctwid:0.1 pcthei:0.88]]];
	[self addChild:[MenuCommon cons_common_nav_menu]];
	
	
	tabbedpane = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
												   rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_tabbedshoppane"]]
							pos:[Common screen_pctwid:0.615 pcthei:0.55]];
	
	touches = [NSMutableArray array];
	
	CGPoint tabanchor = [Common pct_of_obj:tabbedpane pctx:0 pcty:0.99];
	CGSize tabsize = [FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_tabpane_tab"].size;
	ShopTabTouchButton *first_tab = [self cons_tab_pos:tabanchor sel:@selector(tab0:) text:@"Upgrade" parent:tabbedpane];
	[first_tab set_selected:YES];
	cur_selected_tab = first_tab;
	[self cons_tab_pos:ccp(tabanchor.x + tabsize.width,tabanchor.y) sel:@selector(tab1:) text:@"Dogs" parent:tabbedpane];
	[self cons_tab_pos:ccp(tabanchor.x + tabsize.width*2,tabanchor.y) sel:@selector(tab2:) text:@"Unlock" parent:tabbedpane];
	[self cons_tab_pos:ccp(tabanchor.x + tabsize.width*3,tabanchor.y) sel:@selector(tab3:) text:@"$$$" parent:tabbedpane];
	
	
	clipper = [ClippingNode node];
	CGPoint clipper_l_anchor = ccp(
		tabbedpane.position.x - tabbedpane.boundingBoxInPixels.size.width/2.0,
		tabbedpane.position.y - tabbedpane.boundingBoxInPixels.size.height/2.0
	);
	
	[clipper setClippingRegion:CGRectMake(
		clipper_l_anchor.x + 10,
	    clipper_l_anchor.y + 13,
		tabbedpane.boundingBoxInPixels.size.width * 0.4 - 20,
		tabbedpane.boundingBoxInPixels.size.height * 0.96 - 20
	)];
	clipperholder = [CCSprite node];
	
	
	clipper_anchor = ccp( 10,clipper.clippingRegion.size.height + 10);
	clippedholder_y_min = 0;
	[clipper addChild:clipperholder];
	[tabbedpane addChild:clipper];
	
	can_scroll_down = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"scroll_arrow.png"]];
	[can_scroll_down setScaleY:-1];
	can_scroll_up = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"scroll_arrow.png"]];
	[can_scroll_down setPosition:[Common pct_of_obj:tabbedpane pctx:0.2 pcty:0.035]];
	[can_scroll_up setPosition:[Common pct_of_obj:tabbedpane pctx:0.2 pcty:0.95]];
	[tabbedpane addChild:can_scroll_down];
	[tabbedpane addChild:can_scroll_up];
	
	
	itemname = [[Common cons_label_pos:[Common pct_of_obj:tabbedpane pctx:0.43 pcty:0.935]
								color:ccc3(200,30,30)
							 fontsize:24
								  str:@"Item Name"] anchor_pt:ccp(0,1)];
	[tabbedpane addChild:itemname];
	
	price_disp = [CCSprite node];
	[price_disp addChild:[[Common cons_label_pos:[Common pct_of_obj:tabbedpane pctx:0.43 pcty:0.51]
										  color:ccc3(200,30,30)
									   fontsize:16
											str:@"Price"] anchor_pt:ccp(0,0.5)]];
	itemprice = [[Common cons_label_pos:[Common pct_of_obj:tabbedpane pctx:0.5 pcty:0.425]
								 color:ccc3(0,0,0)
							  fontsize:19
								   str:@"99999"] anchor_pt:ccp(0,0.5)];
	[price_disp addChild:itemprice];
	[price_disp addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
												rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tinybone"]]
						  pos:[Common pct_of_obj:tabbedpane pctx:0.46 pcty:0.425]]];
	[tabbedpane addChild:price_disp];
	buybutton = [TouchButton cons_pt:[Common pct_of_obj:tabbedpane pctx:0.975 pcty:0.025]
								 tex:[Resource get_tex:TEX_NMENU_ITEMS]
							 texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"buybutton"]
								  cb:[Common cons_callback:self sel:@selector(buybutton)]];
	[buybutton setPosition:ccp(buybutton.position.x - buybutton.boundingBox.size.width/2.0, buybutton.position.y + buybutton.boundingBox.size.height/2.0 )];
	[touches addObject:buybutton];
	[tabbedpane addChild:buybutton];
	
	notenoughdisp = [Common cons_label_pos:[Common pct_of_obj:tabbedpane pctx:0.69 pcty:0.15]
									 color:ccc3(200,30,30)
								  fontsize:23
									   str:@"Not enough bones!"];
	[tabbedpane addChild:notenoughdisp];
	
	NSString* maxstr = @"aaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
                               lineBreakMode:UILineBreakModeWordWrap];
    itemdesc = [CCLabelTTF labelWithString:@"Item description goes here"
                                dimensions:actualSize
                                 alignment:UITextAlignmentLeft
                                  fontName:@"Carton Six"
                                  fontSize:13];
	[itemdesc setAnchorPoint:ccp(0,1)];
	[itemdesc setColor:ccc3(0,0,0)];
	[itemdesc setPosition:[Common pct_of_obj:tabbedpane pctx:0.44 pcty:0.79]];
	[tabbedpane addChild:itemdesc];
	[self addChild:tabbedpane];
	
	CCSprite *total_bones_pane = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
														 rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"continue_total_bg"]]
								  pos:[Common screen_pctwid:0.13 pcthei:0.3]];
	[total_bones_pane addChild:[[CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS]
													   rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"tinybone"]
								 ] pos:[Common pct_of_obj:total_bones_pane pctx:0.15 pcty:0.3]]];
	[total_bones_pane addChild:[Common cons_label_pos:[Common pct_of_obj:total_bones_pane pctx:0.325 pcty:0.75]
												color:ccc3(0,0,0)
											 fontsize:10
												  str:@"Total Bones"]];
	total_disp = [Common cons_label_pos:[Common pct_of_obj:total_bones_pane pctx:0.57 pcty:0.325]
								  color:ccc3(255,0,0)
							   fontsize:20
									str:@"000000"];
	[total_disp setString:strf("%d",[UserInventory get_current_bones])];
	[total_bones_pane addChild:total_disp];
	[self addChild:total_bones_pane];
	
	particles = [NSMutableArray array];
	particleholder = [CCSprite node];
	[self addChild:particleholder];
	
	[self make_scroll_items];
	return self;
}

-(void)make_scroll_items {
	for (int i = 0; i < scroll_items.count; i++) {
		[((CCSprite*)scroll_items[i]).parent removeChild:scroll_items[i] cleanup:YES];
		[touches removeObject:scroll_items[i]];
	}
	[scroll_items removeAllObjects];
	clippedholder_y_min = 0;
	clippedholder_y_max = 0;
	
	NSArray *items = [ShopRecord get_items_for_tab:current_tab];
	for (int i = 0; i < items.count; i++) {
		ItemInfo *info = items[i];
		ShopListTouchButton *neu = 
			[self cons_scrollitem_anchor:clipper_anchor
									mult:i
									info:info
								  parent:clipperholder
									clip:clipper.clippingRegion];
		[scroll_items addObject:neu];
	}
	
	if (items.count > 0) {
		[itemdesc setVisible:YES];
		[price_disp setVisible:YES];
		[buybutton setVisible:YES];
		current_scroll_index = current_scroll_index < scroll_items.count ? current_scroll_index : scroll_items.count - 1;
		[self sellist:scroll_items[current_scroll_index]];
		
	} else {
		itemname.string = @"More Coming Soon!";
		[itemdesc setVisible:NO];
		[price_disp setVisible:NO];
		[buybutton setVisible:NO];
		[notenoughdisp setVisible:NO];
	}
}

-(ShopListTouchButton*)cons_scrollitem_anchor:(CGPoint)anchor mult:(int)mult info:(ItemInfo*)info parent:(CCNode*)parent clip:(CGRect)clip {
	CGRect bbox = [FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_vscrolltab"];
	ShopListTouchButton *tmp = [[ShopListTouchButton cons_pt:ccp(anchor.x,anchor.y - bbox.size.height * mult)
														info:info
														  cb:[Common cons_callback:self sel:@selector(sellist:)]]
						set_screen_clipping_area:clip];
	if (bbox.size.height * (mult + 1) + 15 > clip.size.height) {
		clippedholder_y_max = MAX(clippedholder_y_max, bbox.size.height * (mult + 1) + 15 - clip.size.height);
	}
	
	[touches addObject:tmp];
	[parent addChild:tmp];
	return tmp;
}

-(ShopTabTouchButton*)cons_tab_pos:(CGPoint)pt sel:(SEL)sel text:(NSString*)str parent:(CCSprite*)parent {
	ShopTabTouchButton *tab1 = [ShopTabTouchButton cons_pt:pt text:str cb:[Common cons_callback:self sel:sel]];
	[touches addObject:tab1];
	[parent addChild:tab1];
	return tab1;
}

-(void)sellist:(ShopListTouchButton*)tar {
	if (cur_selected_list_button != NULL) {
		[cur_selected_list_button set_selected:NO];
	}
	for (int i = 0; i < scroll_items.count; i++) {
		if (scroll_items[i] == tar) {
			current_scroll_index = i;
			break;
		}
	}
	cur_selected_list_button = tar;
	[tar set_selected:YES];
	
	itemname.string = tar.sto_info.name;
	itemdesc.string = tar.sto_info.desc;
	itemprice.string = [NSString stringWithFormat:@"%d",tar.sto_info.price];
	
	sto_val = tar.sto_info.val;
	sto_price = tar.sto_info.price;
	
	if (sto_price > [UserInventory get_current_bones]) {
		[buybutton setVisible:NO];
		[notenoughdisp setVisible:YES];
	} else {
		[buybutton setVisible:YES];
		[notenoughdisp setVisible:NO];
	}
}

-(void)seltab:(int)t tab:(ShopTabTouchButton*)tab{
	if (cur_selected_tab != NULL) {
		[cur_selected_tab set_selected:NO];
	}
	cur_selected_tab = tab;
	[tab set_selected:YES];
	
	current_tab = t==0?ShopTab_UPGRADE:
					(t==1?ShopTab_CHARACTERS:
					 (t==2?ShopTab_UNLOCK:ShopTab_REALMONEY));
	current_tab_index = t;
	[self make_scroll_items];
}

-(void)tab0:(ShopTabTouchButton*)tab{current_scroll_index = 0;[self seltab:0 tab:tab];}
-(void)tab1:(ShopTabTouchButton*)tab{current_scroll_index = 0;[self seltab:1 tab:tab];}
-(void)tab2:(ShopTabTouchButton*)tab{current_scroll_index = 0;[self seltab:2 tab:tab];}
-(void)tab3:(ShopTabTouchButton*)tab{current_scroll_index = 0;[self seltab:3 tab:tab];}

-(void)dispatch_event:(GEvent *)e {
    if (e.type == GEventType_MENU_INVENTORY) {
        [tabbedpane setVisible:NO];
        
    } else if (e.type == GEVentType_MENU_CLOSE_INVENTORY) {
        [tabbedpane setVisible:YES];
        
    } else if (e.type == GEventType_MENU_TICK && self.visible) {
		[self update];
		
	}
}

-(void)update {
	if (!visible_) return;
	CGPoint neupos = CGPointAdd(ccp(0,vy), clipperholder.position);
	neupos.y = clampf(neupos.y, clippedholder_y_min, clippedholder_y_max);
	[clipperholder setPosition:neupos];
	vy *= 0.8;
	[can_scroll_up setVisible:neupos.y != clippedholder_y_min];
	[can_scroll_down setVisible:neupos.y != clippedholder_y_max];
	
	for (TouchButton *i in touches) {
		if ([i class] == [ShopListTouchButton class]) {
			[((ShopListTouchButton*)i) update];
		}
		if ([i class] == [ShopTabTouchButton class]) {
			[((ShopTabTouchButton*)i) update];
		}
	}
	
	[buybutton setScale:(1-buybutton.scale)/5.0+buybutton.scale];
	
	NSMutableArray *toremove = [NSMutableArray array];
    for (Particle *i in particles) {
        [i update:(id)self];
        if ([i should_remove]) {
            [particleholder removeChild:i cleanup:YES];
            [toremove addObject:i];
        }
    }
	[particles removeObjectsInArray:toremove];
	
	int curdispval = total_disp.string.integerValue;
	int tardispval = [UserInventory get_current_bones];
	if (curdispval != tardispval) {
		if (ABS(curdispval-tardispval) > 200) {
			curdispval = curdispval + (tardispval-curdispval)/10.0f;
		} else {
			curdispval = tardispval;
		}
		[total_disp setString:strf("%d",curdispval)];
	}
}

-(void)add_particle:(Particle*)p {
	[particleholder addChild:p];
	[particles addObject:p];
}

-(void)buybutton {
	[buybutton setScale:1.4];
	if ([ShopRecord buy_shop_item:sto_val price:sto_price]) {
		CGPoint centre = [buybutton convertToWorldSpace:CGPointZero];
		centre.x += buybutton.boundingBox.size.width/2.0f;
		centre.y += buybutton.boundingBox.size.height/2.0f;
		for (float i = 0; i < 2*M_PI-0.1; i+=M_PI/4) {
			CGPoint vel = ccp(sinf(i),cosf(i));
			float scale = float_random(5, 7);
			[self add_particle:[ShopBuyBoneFlyoutParticle cons_pt:centre vel:ccp(vel.x*scale,vel.y*scale)]];
		}
		centre = [total_disp convertToWorldSpace:CGPointZero];
		[self add_particle:[ShopBuyFlyoffTextParticle cons_pt:ccp(centre.x+total_disp.boundingBox.size.width/2.0,centre.y+15) text:strf("-%d",sto_price)]];
		
		[self seltab:current_tab_index tab:cur_selected_tab];
		//todo -- buying sound here
		
	} else {
		NSLog(@"buying failed");
	}
}

-(void)touch_begin:(CGPoint)pt {
	for (int i = touches.count-1; i>=0; i--) {
		TouchButton *b = touches[i];
		[b touch_begin:pt];
	}
	
	is_scroll = YES;
	last_scroll_pt = pt;
	scroll_move_ct = 0;
}

-(void)touch_move:(CGPoint)pt {
	if (!visible_) return;
	if (!is_scroll) return;
	CGPoint ydelta = ccp(0,-last_scroll_pt.y+pt.y);
	last_scroll_pt = pt;
	
	float sign = [Common sig:ydelta.y];
	float av = 15.0*MIN(ABS(ydelta.y),30)/30.0;
	av /= MAX(1,8.0-scroll_move_ct);
	vy += sign * av;
	scroll_move_ct++;
}

-(void)touch_end:(CGPoint)pt {
	if (!visible_) return;
	is_scroll = NO;
}

-(void)dealloc {
	//NSLog(@"shop dealloc");
}

@end
