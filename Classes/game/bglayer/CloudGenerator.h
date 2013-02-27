#import "BackgroundObject.h"
#import "cocos2d.h"

@interface CloudGenerator : BackgroundObject {
    NSMutableArray *clouds;
    float prevx,prevy;
    
    int nextct,alternator;
    
}
+(CloudGenerator*)cons;
-(void)random_seed_clouds;
@end
