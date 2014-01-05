#import "InventoryLayerTab.h"

@implementation InventoryLayerTab

+(InventoryLayerTab*)cons_pt:(CGPoint)pt text:(NSString *)str cb:(CallBack *)cb {
	return [[InventoryLayerTab node] cons_pt:pt text:str cb:cb];
}
-(id)cons_pt:(CGPoint)pt text:(NSString*)text cb:(CallBack*)tcb {
	[super cons_pt:pt
			   tex:[Resource get_tex:TEX_NMENU_ITEMS]
		   texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_tabpane_tab"]
				cb:tcb];
	[self setAnchorPoint:ccp(0,0)];
	[self addChild:[Common cons_label_pos:[Common pct_of_obj:self pctx:0.5 pcty:0.5]
									color:ccc3(0,0,0)
								 fontsize:14
									  str:text]];
	
	tar_scale_y = 0.97;
	return self;
}

-(void)set_selected:(BOOL)t {
	if (t) {
		tar_scale_y = 1.1;
	} else {
		tar_scale_y = 0.95;
	}
}

-(void)update {
	[self setScaleY:(tar_scale_y-self.scaleY)/3.0+self.scaleY];
}

@end


@implementation PollingButton

+(PollingButton*)cons_pt:(CGPoint)pt
				  texkey:(NSString *)texkey
				  yeskey:(NSString *)yeskey
				   nokey:(NSString *)nokey
					poll:(CallBack *)poll
				   click:(CallBack *)click {
	return [[PollingButton node] cons_pt:pt texkey:texkey yeskey:yeskey nokey:nokey poll:poll click:click];
}

-(id)cons_pt:(CGPoint)_pt
	  texkey:(NSString *)_texkey
	  yeskey:(NSString *)_yeskey
	   nokey:(NSString *)_nokey
		poll:(CallBack *)_poll
	   click:(CallBack *)_click {
	
	yes = [FileCache get_cgrect_from_plist:_texkey idname:_yeskey];
	no = [FileCache get_cgrect_from_plist:_texkey idname:_nokey];
	poll = _poll;
	
	[super cons_pt:_pt
			   tex:[Resource get_tex:_texkey]
		   texrect:CGRectZero
				cb:_click];
	
	[self update];
	
	return self;
}

-(void)update {
	if ([poll.target performSelector:poll.selector]) {
		[self setTextureRect:yes];
	} else {
		[self setTextureRect:no];
	}
}

@end