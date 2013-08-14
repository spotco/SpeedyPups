#import "ShopListTouchButton.h"
#import "ShopRecord.h"

@implementation ShopListTouchButton
@synthesize sto_info;

+(ShopListTouchButton*)cons_pt:(CGPoint)pt info:(ItemInfo*)info cb:(CallBack *)tcb {
	return [[ShopListTouchButton node] cons_pt:pt info:info cb:tcb];
}

-(id)cons_pt:(CGPoint)pt info:(ItemInfo*)info cb:(CallBack *)tcb  {
	[super cons_pt:pt
			   tex:[Resource get_tex:TEX_NMENU_ITEMS]
		   texrect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"tshop_vscrolltab"]
				cb:tcb];
	
	[self setPosition:ccp(pt.x+self.boundingBox.size.width/2.0,pt.y-self.boundingBox.size.height/2.0)];
	
	[self setAnchorPoint:ccp(0.5,0.5)];
	
	CCLabelTTF *name_disp = [[Common cons_label_pos:[Common pct_of_obj:self pctx:0.9 pcty:0.9]
											 color:ccc3(0,0,0)
										  fontsize:18
											   str:info.name] anchor_pt:ccp(1,1)];
	[self addChild:name_disp];
	
	CCLabelTTF *price_disp = [[Common cons_label_pos:[Common pct_of_obj:self pctx:0.9 pcty:0.5]
											   color:ccc3(200,30,30)
											fontsize:13
												 str:[NSString stringWithFormat:@"%d",info.price]] anchor_pt:ccp(1,1)];
	[self addChild:price_disp];
	CCSprite *disp_sprite = [[CCSprite spriteWithTexture:info.tex rect:info.rect]
							 pos:[Common pct_of_obj:self pctx:0.25 pcty:0.5]];
	[self addChild:disp_sprite];
	sto_info = info;
	
	[self setScale:0.95];
	[self set_selected:NO];
	return self;
}

-(id)set_screen_clipping_area:(CGRect)clippingrect {
	has_clipping_area = YES;
	clipping_area = clippingrect;
	return self;
}

-(void)touch_begin:(CGPoint)pt {
	CGPoint scrn_pt = pt;
	pt = [self convertToNodeSpace:pt];
	CGRect hitrect = [self hit_rect_local];
	if (CGRectContainsPoint(hitrect, pt)) {
		if (!CGRectContainsPoint(clipping_area, scrn_pt)) {
			return;
		}
		[self.cb.target performSelector:self.cb.selector withObject:self];
	}
}

-(CGRect)hit_rect_local {
	CGRect hitrect = [self boundingBox];
	hitrect.origin = CGPointZero;
	hitrect.size.width *= 1/self.scale;
	hitrect.size.height *= 1/self.scale;
	return hitrect;
}

-(void)update {
	[self setScale:(tar_scale-self.scale)/3.0+self.scale];
}

-(void)set_selected:(BOOL)t {
	if (t) {
		tar_scale = 1;
	} else {
		tar_scale = 0.85;
	}
}



@end
