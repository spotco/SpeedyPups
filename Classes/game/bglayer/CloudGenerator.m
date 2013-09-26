#import "CloudGenerator.h"
#import "Resource.h"
#import "Common.h"
#import "FileCache.h"

@interface Cloud : CCSprite {
	float movspd;
}
+(Cloud*)cons_pt:(CGPoint)pt sc:(float)sc texkey:(NSString*)texkey scaley:(float)sy;
-(void)update_dv:(CGPoint)dv;
@property(readwrite,assign) float scaley;
@property(readwrite,assign) float speedmult;
@end

@implementation Cloud
@synthesize scaley;
+(Cloud*)cons_pt:(CGPoint)pt sc:(float)sc texkey:(NSString *)texkey scaley:(float)sy {
	int rnd = int_random(0, 5);
	NSString *tarcld;
	if (rnd == 0) {
		tarcld = @"cloud0";
	} else if (rnd == 1) {
		tarcld = @"cloud1";
	} else if (rnd == 2) {
		tarcld = @"cloud2";
	} else if (rnd == 3) {
		tarcld = @"cloud3";
	} else if (rnd == 4) {
		tarcld = @"cloud4";
	} else {
		tarcld = @"cloud5";
	}
	
	//TEX_CLOUD_SS
	Cloud* b = [Cloud spriteWithTexture:[Resource get_tex:texkey] rect:[FileCache get_cgrect_from_plist:texkey idname:tarcld]];
	
	b.scaley = sy;
	b.speedmult = 1;
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
    [self setPosition:CGPointAdd(self.position, ccp(movspd*self.speedmult,-dv.y*scaley))];
}
@end

@implementation CloudGenerator

+(CloudGenerator*)cons {
    CloudGenerator* c = [CloudGenerator node];
    [c cons];
    [c random_seed_clouds];
    return c;
}

+(CloudGenerator*)cons_texkey:(NSString *)key scaley:(float)sy {
    CloudGenerator* c = [CloudGenerator node];
    [c cons];
	[c set_texkey:key];
	[c set_scaley:sy];
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
	texkey = TEX_CLOUD_SS;
	scaley = 0.025;
	speedmult = 1;
	generatespeed = 50;
}

-(void)set_texkey:(NSString *)key {
	texkey = key;
}

-(void)set_scaley:(float)sy {
	scaley = sy;
}

-(CloudGenerator*)set_generate_speed:(int)spd {
	generatespeed = spd;
	return self;
}

-(CloudGenerator*)set_speedmult:(float)spd {
	speedmult = spd;
	for (Cloud *c in clouds) {
		c.speedmult = speedmult;
	}
	return self;
}

-(void)update_posx:(float)posx posy:(float)posy {
    CGPoint dv = ccp(posx - prevx,posy - prevy);
    prevx = posx;
    prevy = posy;
    
    if (nextct <= 0) {
        [self generate_cloud];
        nextct = generatespeed;
    }
    nextct--;
    
    
    NSMutableArray* toremove = [[NSMutableArray alloc] init];
    for (Cloud* c in clouds) {
        [c update_dv:dv];
        if (c.position.x < -150) {
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
    
    Cloud* n = [Cloud cons_pt:pos sc:scale texkey:texkey scaley:scaley];
    [n setColor:[self color]];
	n.speedmult = speedmult;
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
