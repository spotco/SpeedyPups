#import "CCSprite.h"
#import "Common.h"

@interface BasePopup : CCSprite
+(BasePopup*)cons;
-(id)cons;
-(void)add_close_button:(CallBack*)on_close;
-(void)update;
@end
