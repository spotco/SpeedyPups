#import "WebRequest.h"

@implementation WebRequest

static NSOperationQueue *request_queue;

+(void)initialize {
	request_queue = [[NSOperationQueue alloc] init];
	[request_queue setMaxConcurrentOperationCount:5];
}

/*
 [WebRequest request_to:@"http://www.spotcos.com" callback:^(NSString* response, WebRequestStatus status) {
	 if (status == WebRequestStatus_OK) {
		NSLog(@"%@",response);
	 } else {
		NSLog(@"request failed");
	 }
 }];
 */
+(void)request_to:(NSString*)url callback:(void (^)(NSString* response, WebRequestStatus status))callback {
	NSURL *url_obj = [NSURL URLWithString:url];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url_obj
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];
	
	[NSURLConnection sendAsynchronousRequest:urlRequest
									  queue:request_queue
						  completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
							   if (!error) {
								   NSString *body = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
								   callback(body,WebRequestStatus_OK);
								   
							   } else {
								   callback(@"",WebRequestStatus_FAIL);
							   }
						   }];
	
}

+(NSString*)unique_id {
	//return [[UIDevice currentDevice] uniqueIdentifier];
	return NULL;
}

@end
