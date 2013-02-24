#import "BackgroundObject.h"
#import "cocos2d.h"

@interface CloudGenerator : BackgroundObject {
    float base_hei;
    NSMutableArray *clouds;
}

+(CloudGenerator*)cons_from_tex:(CCTexture2D*)tex scrollspd_x:(float)scrollspd_x scrollspd_y:(float)scrollspd_y baseHeight:(float)hei;

@property(readwrite,assign) float base_hei;
@property(readwrite,unsafe_unretained) CCTexture2D* cloud_tex;

@end
