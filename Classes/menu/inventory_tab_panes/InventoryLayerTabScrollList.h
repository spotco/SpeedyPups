#import "CCSprite.h"
@class CallBack;

@interface InventoryLayerTabScrollList : NSObject {
	CCSprite *clipperholder;
	ClippingNode *clipper;
	CGPoint clipper_anchor;
	float clippedholder_y_min, clippedholder_y_max;
	CCSprite *can_scroll_down, *can_scroll_up;
	
	BOOL is_scroll;
	CGPoint last_scroll_pt;
	int scroll_move_ct;
	float vy;
	
	NSMutableArray *touches;
	
	int mult;
}

+(InventoryLayerTabScrollList*)cons_parent:(CCSprite*)parent add_to:(CCSprite*)add_to;
-(void)add_tab:(CCTexture2D*)tex rect:(CGRect)rect main_text:(NSString*)main_text sub_text:(NSString*)sub_text callback:(CallBack*)cb;

-(void)update;
-(void)touch_begin:(CGPoint)pt;
-(void)touch_move:(CGPoint)pt;
-(void)touch_end:(CGPoint)pt;

@end
