#import <Foundation/Foundation.h>
#import "Common.h"

@interface FileCache : NSObject

+(void)precache_files;
+(CGRect)get_cgrect_from_plist:(NSString*)file idname:(NSString*)idname;
@end
