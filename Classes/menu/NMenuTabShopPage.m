#import "NMenuTabShopPage.h"
#import "Shopkeeper.h"
#import "MenuCommon.h"


@implementation NMenuTabShopPage

+(NMenuTabShopPage*)cons {
	return [NMenuTabShopPage node];
}

-(id)init {
	self = [super init];
	[GEventDispatcher add_listener:self];
	[self addChild:[Shopkeeper cons_pt:[Common screen_pctwid:0.1 pcthei:0.45]]];
	[self addChild:[MenuCommon menu_item:TEX_NMENU_ITEMS id:@"nmenu_shopsign" pos:[Common screen_pctwid:0.1 pcthei:0.88]]];
	[self addChild:[MenuCommon cons_common_nav_menu]];
	
	
	tabbedpane = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
												   rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_tabbedshoppane"]]
							pos:[Common screen_pctwid:0.615 pcthei:0.55]];
	
	touches = [NSMutableArray array];
	
	CGPoint tabanchor = [Common pct_of_obj:tabbedpane pctx:0 pcty:0.97];
	CGSize tabsize = [FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_tabpane_tab"].size;
	[self cons_tab_pos:tabanchor sel:@selector(tab0) text:@"top lel" parent:tabbedpane];
	[self cons_tab_pos:ccp(tabanchor.x + tabsize.width,tabanchor.y) sel:@selector(tab1) text:@"top lel2" parent:tabbedpane];
	[self cons_tab_pos:ccp(tabanchor.x + tabsize.width*2,tabanchor.y) sel:@selector(tab2) text:@"top lel3" parent:tabbedpane];
	[self cons_tab_pos:ccp(tabanchor.x + tabsize.width*3,tabanchor.y) sel:@selector(tab3) text:@"top lel4" parent:tabbedpane];
	
	
	ClippingNode *clipper = [ClippingNode node];
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
	
	
	CGPoint clipper_anchor = ccp( 10,clipper.clippingRegion.size.height + 10);
	[self cons_scrollitem_anchor:clipper_anchor mult:0 str:@"lel" parent:clipperholder clip:clipper.clippingRegion];
	[self cons_scrollitem_anchor:clipper_anchor mult:1 str:@"ya" parent:clipperholder clip:clipper.clippingRegion];
	[self cons_scrollitem_anchor:clipper_anchor mult:2 str:@"fuken" parent:clipperholder clip:clipper.clippingRegion];
	[self cons_scrollitem_anchor:clipper_anchor mult:3 str:@"wut" parent:clipperholder clip:clipper.clippingRegion];
	[self cons_scrollitem_anchor:clipper_anchor mult:4 str:@"mate" parent:clipperholder clip:clipper.clippingRegion];
	[self cons_scrollitem_anchor:clipper_anchor mult:5 str:@"kek" parent:clipperholder clip:clipper.clippingRegion];
	clippedholder_y_min = 0;
	[clipper addChild:clipperholder];
	[tabbedpane addChild:clipper];
	
	can_scroll_down = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"scroll_arrow.png"]];
	[can_scroll_down setScaleY:-1];
	can_scroll_up = [CCSprite spriteWithTexture:[Resource get_tex:TEX_UI_INGAMEUI_SS] rect:[FileCache get_cgrect_from_plist:TEX_UI_INGAMEUI_SS idname:@"scroll_arrow.png"]];
	[can_scroll_down setPosition:[Common pct_of_obj:tabbedpane pctx:0.2 pcty:0.04]];
	[can_scroll_up setPosition:[Common pct_of_obj:tabbedpane pctx:0.2 pcty:0.95]];
	[tabbedpane addChild:can_scroll_down];
	[tabbedpane addChild:can_scroll_up];
	
	
	itemname = [[Common cons_label_pos:[Common pct_of_obj:tabbedpane pctx:0.43 pcty:0.935]
								color:ccc3(200,30,30)
							 fontsize:24
								  str:@"Item Name"] anchor_pt:ccp(0,1)];
	[tabbedpane addChild:itemname];
	itemdisp = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
									  rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_itemdisppane"]]
				pos:[Common pct_of_obj:tabbedpane pctx:0.875 pcty:0.8]];
	[tabbedpane addChild:itemdisp];
	[tabbedpane addChild:[[Common cons_label_pos:[Common pct_of_obj:tabbedpane pctx:0.425 pcty:0.3]
										  color:ccc3(0,0,0)
									   fontsize:16
											str:@"Price"] anchor_pt:ccp(0,0.5)]];
	itemprice = [[Common cons_label_pos:[Common pct_of_obj:tabbedpane pctx:0.475 pcty:0.215]
								 color:ccc3(200,30,30)
							  fontsize:19
								   str:@"99999"] anchor_pt:ccp(0,0.5)];
	[tabbedpane addChild:itemprice];
	[tabbedpane addChild:[[[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
												rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"boneicon"]]
						  pos:[Common pct_of_obj:tabbedpane pctx:0.44 pcty:0.215]] scale:0.5]];
	buybutton = [[CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS]
									   rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"buybutton"]]
				 pos:[Common pct_of_obj:tabbedpane pctx:0.975 pcty:0.025]];
	[buybutton setAnchorPoint:ccp(1,0)];
	[tabbedpane addChild:buybutton];
	
	NSString* maxstr = @"aaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
                               lineBreakMode:UILineBreakModeWordWrap];
    itemdesc = [CCLabelTTF labelWithString:@"Item description goes here"
                                dimensions:actualSize
                                 alignment:UITextAlignmentLeft
                                  fontName:@"Carton Six"
                                  fontSize:13];
	[itemdesc setColor:ccc3(0,0,0)];
	[itemdesc setPosition:[Common pct_of_obj:tabbedpane pctx:0.625 pcty:0.575]];
	[tabbedpane addChild:itemdesc];
	
	
	[self addChild:tabbedpane];
	return self;
}

-(void)cons_scrollitem_anchor:(CGPoint)anchor mult:(int)mult str:(NSString*)str parent:(CCNode*)parent clip:(CGRect)clip {
	CGRect bbox = [FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_vscrolltab"];
	TouchButton *tmp = [TouchButton cons_pt:ccp(anchor.x,anchor.y - bbox.size.height * mult)
										tex:[Resource get_tex:TEX_NMENU_ITEMS]
									texrect:bbox
										 cb:[Common cons_callback:self sel:@selector(seltab)]];
	[tmp setAnchorPoint:ccp(0,1)];
	[tmp addChild:[Common cons_label_pos:[Common pct_of_obj:tmp pctx:0.5 pcty:0.5] color:ccc3(0,0,0) fontsize:15 str:str]];
	
	clippedholder_y_max = MAX(clippedholder_y_max, tmp.position.y + bbox.size.height - clip.size.height);
	
	[touches addObject:tmp];
	[parent addChild:tmp];
}

-(void)cons_tab_pos:(CGPoint)pt sel:(SEL)sel text:(NSString*)str parent:(CCSprite*)parent {
	TouchButton *tab1 = [TouchButton cons_pt:pt
										 tex:[Resource get_tex:TEX_NMENU_ITEMS]
									 texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_tabpane_tab"]
										  cb:[Common cons_callback:self sel:sel]];
	[tab1 setAnchorPoint:ccp(0,0)];
	[tab1 addChild:[Common cons_label_pos:[Common pct_of_obj:tab1 pctx:0.5 pcty:0.5]
									color:ccc3(0,0,0)
								 fontsize:17
									  str:str]];
	[touches addObject:tab1];
	[parent addChild:tab1];
}

-(void)seltab {
	NSLog(@"seltab");
}

-(void)tab0{
	NSLog(@"tab0");
}
-(void)tab1{
	NSLog(@"tab1");
}
-(void)tab2{
	NSLog(@"tab2");
}
-(void)tab3{
	NSLog(@"tab3");
}

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
	CGPoint neupos = CGPointAdd(ccp(0,vy), clipperholder.position);
	neupos.y = clampf(neupos.y, clippedholder_y_min, clippedholder_y_max);
	[clipperholder setPosition:neupos];
	vy *= 0.8;
	[can_scroll_up setVisible:neupos.y != clippedholder_y_min];
	[can_scroll_down setVisible:neupos.y != clippedholder_y_max];
}

-(void)touch_begin:(CGPoint)pt {
	for (TouchButton *b in touches) {
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
	float av = 11.0*MIN(ABS(ydelta.y),30)/30.0;
	av /= MAX(1,8.0-scroll_move_ct);
	vy += sign * av;
	scroll_move_ct++;
}

-(void)touch_end:(CGPoint)pt {
	if (!visible_) return;
	is_scroll = NO;
}

@end
