#import "InventoryTabPane_Extras.h"
#import "Common.h"
#import "Resource.h"
#import "FileCache.h"
#import "InventoryLayerTabScrollList.h"

typedef enum ExtrasPaneMode {
	ExtrasPaneMode_NONE,
	ExtrasPaneMode_ART,
	ExtrasPaneMode_MUSIC,
	ExtrasPaneMode_SFX
} ExtrasPaneMode;

@implementation InventoryTabPane_Extras {
	InventoryLayerTabScrollList *list;
	ExtrasPaneMode cur_mode;
	CCLabelTTF *name_disp;
	CCLabelTTF *desc_disp;
}

+(InventoryTabPane_Extras*)cons:(CCSprite *)parent {
	return [[InventoryTabPane_Extras node] cons:parent];
}
-(id)cons:(CCSprite*)parent {
	cur_mode = ExtrasPaneMode_NONE;
	
	name_disp = [Common cons_label_pos:[Common pct_of_obj:parent pctx:0.4 pcty:0.88]
								 color:ccc3(205, 51, 51)
							  fontsize:20
								   str:@"Extras"];
	[name_disp setAnchorPoint:ccp(0,1)];
	[self addChild:name_disp];
	
	NSString* maxstr = @"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    CGSize actualSize = [maxstr sizeWithFont:[UIFont fontWithName:@"Carton Six" size:15]
                           constrainedToSize:CGSizeMake(1000, 1000)
							   lineBreakMode:(NSLineBreakMode)UILineBreakModeWordWrap];
	desc_disp = [CCLabelTTF labelWithString:@"Unlock concept art, music and sfx from the game and view them here!"
								 dimensions:actualSize
								  alignment:UITextAlignmentLeft
								   fontName:@"Carton Six"
								   fontSize:15];
	[desc_disp setPosition:[Common pct_of_obj:parent pctx:0.4 pcty:0.7]];
	[desc_disp setAnchorPoint:ccp(0,1)];
	[desc_disp setColor:ccc3(0, 0, 0)];
	[self addChild:desc_disp];
	
	list = [InventoryLayerTabScrollList cons_parent:parent add_to:self];
	[self update_list];
	
	return self;
}

-(void)update_list {
	[list clear_tabs];
	if (cur_mode == ExtrasPaneMode_NONE) {
		[list add_tab:[Resource get_tex:TEX_NMENU_ITEMS]
				 rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"extrasicon_art"]
			main_text:@"Art"
			 sub_text:@""
			 callback:[Common cons_callback:self sel:@selector(category_select_art)]];
		[list add_tab:[Resource get_tex:TEX_NMENU_ITEMS]
				 rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"extrasicon_music"]
			main_text:@"Music"
			 sub_text:@""
			 callback:[Common cons_callback:self sel:@selector(category_select_music)]];
		[list add_tab:[Resource get_tex:TEX_NMENU_ITEMS]
				 rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"extrasicon_sfx"]
			main_text:@"Sfx"
			 sub_text:@""
			 callback:[Common cons_callback:self sel:@selector(category_select_sfx)]];
	}
}

-(void)category_select_art {
	//cur_mode = ExtrasPaneMode_ART;
	//[self update_list];
}

-(void)category_select_music {
	//cur_mode = ExtrasPaneMode_MUSIC;
	//[self update_list];
}

-(void)category_select_sfx {
	//cur_mode = ExtrasPaneMode_SFX;
	//[self update_list];
}

-(void)update {
	if (!self.visible) return;
	[list update];
}

-(void)touch_begin:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_begin:pt];
}

-(void)touch_move:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_move:pt];
}

-(void)touch_end:(CGPoint)pt {
	if (!self.visible) return;
	[list touch_end:pt];
}

-(void)set_pane_open:(BOOL)t {
	[self setVisible:t];
}

@end
