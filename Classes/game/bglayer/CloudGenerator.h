#import "BackgroundObject.h"
#import "cocos2d.h"

@interface CloudGenerator : BackgroundObject {
    NSMutableArray *clouds;
    float prevx,prevy;
    
    int nextct,alternator;
	
	NSString* texkey;
	float scaley;
	float speedmult;
    
}
+(CloudGenerator*)cons;
+(CloudGenerator*)cons_texkey:(NSString*)key scaley:(float)sy;
-(void)random_seed_clouds;
-(CloudGenerator*)set_speedmult:(float)spd;
@end
