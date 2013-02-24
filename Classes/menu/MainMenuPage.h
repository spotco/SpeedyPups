#import "CCNode.h"
#import "Resource.h"
#import "Common.h"
#import "GEventDispatcher.h"

@interface MainMenuPageInteractiveItem : CCNode
    -(void)touch_down_at:(CGPoint)pt;
    -(void)touch_move_at:(CGPoint)pt;
    -(void)touch_up_at:(CGPoint)pt;
@end

@interface MainMenuPage : MainMenuPageInteractiveItem
    -(void)cons_starting_at:(CGPoint)tstart;
    -(void)add_interactive_item:(MainMenuPageInteractiveItem*)i;
    @property(readwrite,strong) NSMutableArray* interactive_items;
@end

@interface MainMenuPageZoomButton : MainMenuPageInteractiveItem {
    CallBack* cb;
    CCNode *img;
    CGRect n_bbox;
    float zoom;
}

@property(readwrite,assign) BOOL pressed;

+(MainMenuPageZoomButton*)cons_texture:(CCTexture2D*)tex at:(CGPoint)pos fn:(CallBack*)fn;
+(MainMenuPageZoomButton*)cons_spr:(CCNode*)spr at:(CGPoint)pos fn:(CallBack*)fn;
-(MainMenuPageZoomButton*)set_zoom:(float)tzoom;

@end
