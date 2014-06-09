#import "iAds_integration.h"
#import "cocos2d.h"
#import "Common.h"
#import <iAd/iAd.h>

@implementation iAds_integration {
	ADBannerView *ad_view;
	BOOL visible;
}

-(id)init_landscape_bottom {
	self = [super init];
	
	ad_view = [[ADBannerView alloc] initWithFrame:CGRectZero];
	ad_view.delegate = self;
	ad_view.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
	ad_view.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
	[[[CCDirector sharedDirector] openGLView] addSubview:ad_view];
	ad_view.center = ccp(ad_view.frame.size.width/2, [Common SCREEN].height-ad_view.frame.size.height/2);
	ad_view.hidden = YES;
	visible = YES;
	
	return self;
}

-(void)onEnter {}

-(void)setVisible:(BOOL)v {
	visible = v;
	ad_view.hidden = !v;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
	ad_view.hidden = !visible;
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	ad_view.hidden = YES;
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner {
	ad_view.hidden = NO && !visible;
}

-(void)onExit {
	ad_view.delegate = NULL;
	[ad_view removeFromSuperview];
	ad_view = NULL;
}

@end
