#import "ShopItemPane.h"
#import "Resource.h"
#import "FileCache.h"

@implementation ShopItemPane

#define id_ITEM 5
#define id_LABEL 6

+(ShopItemPane*)cons_pt:(CGPoint)pt cb:(CallBack *)cb {
	CCSprite *w1 = [self cons_window], *w2 = [self cons_window];
	[Common set_zoom_pos_align:w1 zoomed:w2 scale:1.1];
	ShopItemPane *p = [ShopItemPane itemFromNormalSprite:w1 selectedSprite:w2 target:cb.target selector:cb.selector];
	[p setPosition:pt];
	return p;
}

+(CCSprite*)cons_window {
	CCSprite *w = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"nmenu_itempane"]];
	CCSprite *boneicon = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"boneicon"]];
	[boneicon setScale:0.5];
	[boneicon setPosition:ccp(22,20)];
	
	CCSprite *item = [CCSprite spriteWithTexture:[Resource get_tex:TEX_NMENU_ITEMS] rect:[FileCache get_cgrect_from_plist:TEX_NMENU_ITEMS idname:@"boneicon"]];
	[item setPosition:ccp(47.5,63)];
	[w addChild:item z:0 tag:id_ITEM];
	
	CCLabelTTF *prixlabel = [Common cons_label_pos:ccp(36,20) color:ccc3(0,0,0) fontsize:18 str:@"99999"];
	[prixlabel setAnchorPoint:ccp(0,0.5)];
	[w addChild:prixlabel z:0 tag:id_LABEL];
	
	[w addChild:boneicon];
	return w;
}

-(void)set_tex:(CCTexture2D*)tex rect:(CGRect)rect price:(int)price {
	for (CCSprite *i in @[self.normalImage,self.selectedImage]) {
		CCSprite *item = (CCSprite*)[i getChildByTag:id_ITEM];
		[item setTexture:tex];
		[item setTextureRect:rect];
		
		CCLabelTTF *prixlabel = (CCLabelTTF*)[i getChildByTag:id_LABEL];
		[prixlabel setString:[NSString stringWithFormat:@"%d",price]];
	}
}

@end
