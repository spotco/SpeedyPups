#import "cocos2d.h"

@class CallBack;

@interface LoadingScene : CCScene {
	BOOL finished_loading;
	CallBack *on_finish;
	NSMutableArray *loading_letters;
	
	CCTexture2D *letters_tex, *paw_tex, *bg_tex;
	
	int arr_anim_i;
	int anim_ct;
}

+(LoadingScene*)cons;
-(void)load_with_callback:(CallBack*)cb;

@end
