#import <Foundation/Foundation.h>
#import "IAPHelper.h" 


#define SPEEDYPUPS_AD_FREE @"SpeedyPups_AdFree"
#define SPEEDYPUPS_10_COINS @"SpeedyPups_10_Coins"

@interface SpeedyPupsIAP : NSObject
+(void)preload;
+(NSSet*)get_all_requested_iaps;
+(NSArray*)get_all_loaded_iaps;
+(SKProduct*)product_for_key:(NSString*)key;
+(void)content_for_key:(NSString*)key;

@end

@interface IAPObject : NSObject
@property(readwrite,strong) NSString *identifier, *name, *desc;
@property(readwrite,strong) NSDecimalNumber *price;
@property(readwrite,strong) SKProduct *product;
@end
