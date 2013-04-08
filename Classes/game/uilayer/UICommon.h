#import "cocos2d.h"
@class GameEngineLayer;

@interface UICommon : NSObject

+(NSString*)parse_gameengine_time:(int)t;
+(void)set_zoom_pos_align:(CCSprite*)normal zoomed:(CCSprite*)zoomed scale:(float)scale;
+(CCLabelTTF*)cons_label_pos:(CGPoint)pos color:(ccColor3B)color fontsize:(int)fontsize;
+(CCMenuItemLabel*)label_cons_menuitem:(CCLabelTTF*)l leftalign:(BOOL)leftalign;
+(CCMenuItem*)cons_menuitem_tex:(CCTexture2D*)tex pos:(CGPoint)pos;
+(CGPoint)player_approx_position:(GameEngineLayer*)game_engine_layer;
@end
