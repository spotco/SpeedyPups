#import "MenuCommon.h"
@class ItemInfo;

@interface ShopListTouchButton : TouchButton {
	BOOL has_clipping_area;
	CGRect clipping_area;
	
	float tar_scale;
}

@property(readwrite,strong) ItemInfo* sto_info;

+(ShopListTouchButton*)cons_pt:(CGPoint)pt info:(ItemInfo*)info cb:(CallBack *)tcb;

-(void)repool;

-(id)set_screen_clipping_area:(CGRect)clippingrect;
-(void)set_selected:(BOOL)t;
-(void)update;
@end


/*
@interface GenericListTouchButton : ShopListTouchButton {
	CCLabelTTF *main_text, *sub_text;
	CCSprite *disp_sprite;
}
@property(readwrite,strong) CallBack *val;
+(GenericListTouchButton*)cons_pt:(CGPoint)pt texrect:(TexRect*)texrect val:(CallBack*)val cb:(CallBack*)tcb;
-(void)set_main_text:(NSString*)s;
-(void)set_sub_text:(NSString*)s;
-(void)repool;
@end*/