#import "CCMenuItem.h"
#import "Common.h"

@interface ShopItemPane : CCMenuItemSprite {
	CCSprite *w1,*w2;
}
+(ShopItemPane*)cons_pt:(CGPoint)pt cb:(CallBack *)cb;
-(void)set_tex:(CCTexture2D*)tex rect:(CGRect)rect price:(int)price;
@end
