#import "GameEngineStats.h"
#import "GameEngineLayer.h" 

@implementation GameEngineStats

NSValue* NSV(GEStat t) { return [NSValue value:&t withObjCType:@encode(GEStat)]; }

+(GameEngineStats*)cons {
	return [[GameEngineStats alloc] init];
}

-(id)init {
	self = [super init];
	stats = [NSMutableDictionary dictionary];
	return self;
}

-(void)increment:(GEStat)type {
	NSValue *kv = NSV(type);
	if ([stats objectForKey:kv] == nil) {
		stats[kv] = @1;
	} else {
		NSNumber *v = stats[kv];
		stats[kv] = [NSNumber numberWithInt:v.intValue+1];
	}
}

-(NSString*)get_disp_str_for_stat:(GEStat)type g:(GameEngineLayer *)g {
	NSValue *kv = NSV(type);
	if ([stats objectForKey:kv]) {
		NSNumber *v = stats[kv];
		return [NSString stringWithFormat:@"%d",v.intValue];
	} else {
		return @"0";
	}
}

-(NSArray*)get_all_stats {
	return @[
		NSV(GEStat_TIME),
		NSV(GEStat_BONES_COLLECTED),
		NSV(GEStat_DEATHS),
		NSV(GEStat_DISTANCE),
		NSV(GEStat_SECTIONS),
		NSV(GEStat_JUMPED),
		NSV(GEStat_DASHED),
		NSV(GEStat_DROWNED),
		NSV(GEStat_SPIKES),
		NSV(GEStat_FALLING),
		NSV(GEStat_ROBOT)
	];
}

@end
