//
//  HelloWorldLayer.h
//  Boids_example
//
//  Created by Xc Xu on 2/13/12.
//  Copyright Break-medai 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class Boid;
// HelloWorldLayer
@interface GameLayer : CCLayer
{
    NSMutableArray* monsters;
    NSMutableArray* monsterLeaders;
    NSMutableArray* towers;
    NSMutableArray* walls;
    NSMutableArray* actors;
    
    CCSpriteBatchNode* monsterBatch;
    CCSpriteBatchNode* monsterLeaderBatch;
    CCSpriteBatchNode* towerBatch;
    CCSpriteBatchNode* wallBatch;
}

@property (nonatomic, readonly, retain) NSMutableArray* monsters;
@property (nonatomic, readonly, retain) NSMutableArray* monsterLeaders;
@property (nonatomic, readonly, retain) NSMutableArray* towers;
@property (nonatomic, readonly, retain) NSMutableArray* walls;
@property (nonatomic, readonly, retain) NSMutableArray* actors;

+ (CCScene*) scene;
+ (GameLayer*) sharedGameLayer;

@end
