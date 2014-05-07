#import "UIIngameAnimation.h"
#import "Resource.h"

@interface BoneCollectUIAnimation : UIIngameAnimation {
    CGPoint start,end;
	int CTMAX;
}

+(BoneCollectUIAnimation*)cons_start:(CGPoint)start end:(CGPoint)end;
-(id)set_ctmax:(int)ctm;
@end

@interface TreatCollectUIAnimation : BoneCollectUIAnimation
+(TreatCollectUIAnimation*)cons_start:(CGPoint)start end:(CGPoint)end;
@end
