#import "CapeGameEngineLayer.h"

@interface CapeGameBossBomb : CapeGameObject
+(CapeGameBossBomb*)cons_pos:(CGPoint)pos;
@end

@interface CapeGameBossPowerupRocket : CapeGameObject {
	float rotation_theta;
}
+(CapeGameBossPowerupRocket*)cons_pos:(CGPoint)pos;
@end
