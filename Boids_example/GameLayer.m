//
//  HelloWorldLayer.m
//  Boids_example
//
//  Created by Xc Xu on 2/13/12.
//  Copyright Break-medai 2012. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"
#import "Monster.h"
#import "MonsterLeader.h"
#import "Tower.h"
#import "Wall.h"

// HelloWorldLayer implementation
@implementation GameLayer

static GameLayer* g_sharedGameLayer;

@synthesize monsters;
@synthesize monsterLeaders;
@synthesize towers;
@synthesize walls;
@synthesize actors;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (GameLayer*) sharedGameLayer {
    return g_sharedGameLayer;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
//		// create and initialize a Label
//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
//
//		// ask director the the window size
//		CGSize size = [[CCDirector sharedDirector] winSize];
//	
//		// position the label on the center of the screen
//		label.position =  ccp( size.width /2 , size.height/2 );
//		
//		// add the label as a child to this Layer
//		[self addChild: label];
        
        g_sharedGameLayer = self;
        
        monsters = [[NSMutableArray alloc] init];
        monsterLeaders = [[NSMutableArray alloc] init];
        towers = [[NSMutableArray alloc] init];
        walls = [[NSMutableArray alloc] init];
        actors = [[NSMutableArray alloc] init];
        
        monsterBatch = [[CCSpriteBatchNode alloc] initWithFile:@"arrow2.png" capacity:300];
        [self addChild:monsterBatch];
        monsterLeaderBatch = [[CCSpriteBatchNode alloc] initWithFile:@"arrow2.png" capacity:300];
        [self addChild:monsterLeaderBatch];
        towerBatch = [[CCSpriteBatchNode alloc] initWithFile:@"Tower.png" capacity:300];
        [self addChild:towerBatch];
        wallBatch = [[CCSpriteBatchNode alloc] initWithFile:@"wall1.png" capacity:300];
        [self addChild:wallBatch];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        srand(time(0));
        srandom(time(0));
        
        NSInteger ACTOR_COUNT = 40;
        for (int i = 0; i < ACTOR_COUNT; i++) {
            MonsterLeader* leader;
//            if (i % (10) == 0) {
            if (i == 0) {
                leader = [MonsterLeader monsterLeader];
                leader.position = ccp(winSize.width / 2, winSize.height / 2);
                leader.velocity = ccp(cosf(M_PI * 2 / ACTOR_COUNT * i), sinf(M_PI * 2 / ACTOR_COUNT * i));
                leader.velocity = ccpMult(leader.velocity, leader.maxSpeed);
                leader.moveTarget = ccpMult(leader.velocity, 1000);
                [leader setBatchNode:monsterLeaderBatch];
                [self addChild:leader];
                [monsterLeaders addObject:leader];
                [actors addObject:leader];
            }
            
            Monster* monster = [Monster monsterWithLeader:leader];
            monster.position = ccp(winSize.width / 2, winSize.height / 2);
            monster.velocity = ccp(cosf(M_PI * 2 / ACTOR_COUNT * i), sinf(M_PI * 2 / ACTOR_COUNT * i));
            monster.forceColor = kForceWhite;
            [monster setBatchNode:monsterBatch];
            [self addChild:monster];
            [monsters addObject:monster];
            [actors addObject:monster];
        }
        
        NSInteger ACTOR_BLUE_COUNT = 40;
        for (int i = 0; i < ACTOR_BLUE_COUNT; i++) {
            CGPoint center;
            if (i % 20 == 0) {
                center = ccp(CCRANDOM_0_1() * winSize.width, CCRANDOM_0_1() * winSize.height);
            }
            Monster* monster = [Monster monsterWithLeader:nil];
            monster.position = center;
            monster.velocity = ccp(cosf(M_PI * 2 / ACTOR_BLUE_COUNT * i), sinf(M_PI * 2 / ACTOR_BLUE_COUNT * i));
            monster.forceColor = kForceBlue;
            [monster setBatchNode:monsterBatch];
            [self addChild:monster];
            [monsters addObject:monster];
            [actors addObject:monster];
        }
        
        NSInteger TOWER_BLUE_COUNT = 20;
        for (int i = 0; i < TOWER_BLUE_COUNT; i++) {
            Tower* tower = [Tower tower];
            tower.position = ccp(CCRANDOM_0_1() * winSize.width, CCRANDOM_0_1() * winSize.height);;
            tower.forceColor = kForceBlue;
            [tower setBatchNode:towerBatch];
            [self addChild:tower];
            [towers addObject:tower];
            [actors addObject:tower];
        }
        
        NSInteger WALL_COUNT_SINGLE = 25;
        for (int i = 0; i < WALL_COUNT_SINGLE; i++) {
            Wall* wall = [Wall wall];
            wall.position = ccp(CCRANDOM_0_1() * winSize.width, CCRANDOM_0_1() * winSize.height);
            [wall setBatchNode:wallBatch];
            [self addChild:wall];
            [walls addObject:wall];
            [actors addObject:wall];
        }
        
        NSInteger WALL_COUNT = 20;
        for (int i = 0; i < WALL_COUNT; i++) {
            if (CCRANDOM_0_1() > 0.5) {
                Wall* wall;
                CGPoint center = ccp(CCRANDOM_0_1() * winSize.width, CCRANDOM_0_1() * winSize.height);
                
                wall = [Wall wall];
                wall.position = ccp(center.x, center.y);
                [wall setBatchNode:wallBatch];
                [self addChild:wall];
                [walls addObject:wall];
                [actors addObject:wall];
                
                wall = [Wall wall];
                wall.position = ccp(center.x - 12.5, center.y);
                [wall setBatchNode:wallBatch];
                [self addChild:wall];
                [walls addObject:wall];
                [actors addObject:wall];
                
                wall = [Wall wall];
                wall.position = ccp(center.x - 25, center.y);
                [wall setBatchNode:wallBatch];
                [self addChild:wall];
                [walls addObject:wall];
                [actors addObject:wall];
                
                wall = [Wall wall];
                wall.position = ccp(center.x + 12.5, center.y);
                [wall setBatchNode:wallBatch];
                [self addChild:wall];
                [walls addObject:wall];
                [actors addObject:wall];
                
                wall = [Wall wall];
                wall.position = ccp(center.x + 25, center.y);
                [wall setBatchNode:wallBatch];
                [self addChild:wall];
                [walls addObject:wall];
                [actors addObject:wall];
            }
            else {
                Wall* wall;
                CGPoint center = ccp(CCRANDOM_0_1() * winSize.width, CCRANDOM_0_1() * winSize.height);
                
                wall = [Wall wall];
                wall.position = ccp(center.x, center.y);
                [wall setBatchNode:wallBatch];
                [self addChild:wall];
                [walls addObject:wall];
                [actors addObject:wall];
                
                wall = [Wall wall];
                wall.position = ccp(center.x, center.y - 12.5);
                [wall setBatchNode:wallBatch];
                [self addChild:wall];
                [walls addObject:wall];
                [actors addObject:wall];
                
                wall = [Wall wall];
                wall.position = ccp(center.x, center.y - 25);
                [wall setBatchNode:wallBatch];
                [self addChild:wall];
                [walls addObject:wall];
                [actors addObject:wall];
                
                wall = [Wall wall];
                wall.position = ccp(center.x, center.y + 12.5);
                [wall setBatchNode:wallBatch];
                [self addChild:wall];
                [walls addObject:wall];
                [actors addObject:wall];
                
                wall = [Wall wall];
                wall.position = ccp(center.x, center.y + 25);
                [wall setBatchNode:wallBatch];
                [self addChild:wall];
                [walls addObject:wall];
                [actors addObject:wall];
            }
        }
        
        [self scheduleUpdate];
        self.isTouchEnabled = YES;
	}
	return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    MonsterLeader* leader = [monsterLeaders objectAtIndex:0];
    leader.moveTarget = location;
    leader.velocity = ccpNormalize(ccpSub(location, leader.position));
    
}

- (void) update:(ccTime)dt {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    for (Monster* one in monsters) {
        if (one.position.x < 0) {
            one.position = ccp(winSize.width, one.position.y);
        }
        if (one.position.x > winSize.width) {
            one.position = ccp(0, one.position.y);
        }
        if (one.position.y < 0) {
            one.position = ccp(one.position.x, winSize.height);
        }
        if (one.position.y > winSize.height) {
            one.position = ccp(one.position.x, 0);
        }
    }
    
    for (MonsterLeader* one in monsterLeaders) {
        if (one.position.x < 0) {
            one.position = ccp(winSize.width, one.position.y);
        }
        if (one.position.x > winSize.width) {
            one.position = ccp(0, one.position.y);
        }
        if (one.position.y < 0) {
            one.position = ccp(one.position.x, winSize.height);
        }
        if (one.position.y > winSize.height) {
            one.position = ccp(one.position.x, 0);
        }
    }
    
    //debug
//    int vcount = 0;
//    for (Monster* monster in monsters) {
//        if (monster.visible == YES)
//            vcount++;
//        
//        CCLOG(@"monster %f, %f", monster.position.x, monster.position.y);
//    }
//    CCLOG(@"vcount %d", vcount);
//    CCLOG(@"tower count %d", towers.count);
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [monsters release];
    [monsterLeaders release];
    [towers release];
    [walls release];
    [actors release];
    
    [monsterBatch release];
    [monsterLeaderBatch release];
    [towerBatch release];
    [wallBatch release];
    
    g_sharedGameLayer = nil;
	
	[super dealloc];
}
@end
