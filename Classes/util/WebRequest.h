#import <Foundation/Foundation.h>

typedef enum {
	WebRequestStatus_OK,
	WebRequestStatus_FAIL
} WebRequestStatus;

@interface WebRequest : NSObject

+(void)request_to:(NSString*)url callback:(void (^)(NSString* response, WebRequestStatus status))callback;
+(NSString*)unique_id;

@end
