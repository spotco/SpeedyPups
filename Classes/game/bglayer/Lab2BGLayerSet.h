#import "BGLayer.h"

@interface Lab2BGLayerSet : BGLayerSet {
	NSMutableArray *bg_objects;
	BackgroundObject *tankers;
	BackgroundObject *tankersfront;
	float tankers_theta;
	
	BackgroundObject *sky;
	BackgroundObject *clouds;
}

+(Lab2BGLayerSet*)cons;
@end
