#import "CloudGenerator.h"
#import "Resource.h"
#import "Common.h"

@interface Cloud : CCSprite {
    float movspd;
}
+(Cloud*)cons_pt:(CGPoint)pt sc:(float)sc;
-(void)update_dv:(CGPoint)dv;
@end

@implementation Cloud
+(Cloud*)cons_pt:(CGPoint)pt sc:(float)sc {
    Cloud* b = [Cloud spriteWithTexture:[Resource get_tex:TEX_CLOUD]];
    [b setPosition:pt];
    [b setAnchorPoint:CGPointZero];
    [b setScale:sc];
    [b calc_movspd:sc];
    return b;
}
-(void)calc_movspd:(float)sc {
    movspd = -((sc-0.2)*1.1 + 0.3);
}
-(void)update_dv:(CGPoint)dv {
    [self setPosition:CGPointAdd(self.position, ccp(movspd,-dv.y*0.025))];
}
@end

@implementation CloudGenerator

+(CloudGenerator*)cons {
    CloudGenerator* c = [CloudGenerator node];
    [c cons];
    [c random_seed_clouds];
    return c;
}

-(void)setColor:(ccColor3B)color {
    [super setColor:color];
	for(CCSprite *sprite in [self children]) {
        [sprite setColor:color];
	}
}

-(void)cons {
    clouds = [[NSMutableArray alloc] init];
    nextct = 0;
}

-(void)update_posx:(float)posx posy:(float)posy {
    CGPoint dv = ccp(posx - prevx,posy - prevy);
    prevx = posx;
    prevy = posy;
    
    if (nextct <= 0) {
        [self generate_cloud];
        nextct = 50;
    }
    nextct--;
    
    
    NSMutableArray* toremove = [[NSMutableArray alloc] init];
    for (Cloud* c in clouds) {
        [c update_dv:dv];
        if (c.position.x < -100) {
            [toremove addObject:c];
        }
    }
    [clouds removeObjectsInArray:toremove];
    for (CCSprite* tar in toremove) {
        [self removeChild:tar cleanup:YES];
    }
}

-(void)random_seed_clouds {
    for (int i = 0; i < 1000; i++) {
        [self update_posx:0 posy:0];
    }
}

-(void)generate_cloud {
    CGPoint pos = [Common screen_pctwid:1.2 pcthei:0.75];
    float scale = 0;
    if (alternator==0) {
        pos.y += float_random(40, 140);
        scale = float_random(0.2, 0.8);
        alternator = 1;
    } else {
        pos.y += float_random(-40, 20);
        scale = float_random(0.9, 1.2);
        alternator = 0;
    }
    
    Cloud* n = [Cloud cons_pt:pos sc:scale];
    [n setColor:[self color]];
    [clouds addObject:n];
    [self addChild:n];
}

-(void)dealloc {
    for (CCNode* n in clouds) {
        [self removeChild:n cleanup:YES];
    }
    [clouds removeAllObjects];
}

@end
