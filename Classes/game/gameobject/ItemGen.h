#import "GameObject.h"
#import "GameItemCommon.h"
#import "DogBone.h"

@interface ItemGen : DogBone {
	GameItem item;
}
+(ItemGen*)cons_pt:(CGPoint)pt;
@end
