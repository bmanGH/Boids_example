//
//  Tower.m
//  Boids_example
//
//  Created by Xc Xu on 2/14/12.
//  Copyright (c) 2012 Break-medai. All rights reserved.
//

#import "Tower.h"
#import "GameLayer.h"
#import "Monster.h"
#import "Tower.h"

@implementation Tower

+ (id) tower {
    return [[[self alloc] initWithFile:@"Tower.png"] autorelease];
}

- (id) init {
    if (self = [super init]) {
        hp = 50;
        atk = 5;
        viewRange = 100;
        atkRange = 15;
        atkSpeed = 2;
        self.scale = 0.2;
        behaviourType = kNoFlock;
        
        maxSpeed = 0;
        neighbourRadius = 0;
        desiredSeparation = 20;
        
        separationWeight = 0;
        alignmentWeight = 0;
        cohesionWeight = 0;
        
        bullet = [[CCSprite alloc] initWithFile:@"bullet1.png"];
        bullet.scale = 0.1;
        bullet.color = ccMAGENTA;
        bullet.visible = NO;
        [[GameLayer sharedGameLayer] addChild:bullet];
        
        velocity = ccp(1,0);
        
        return self;
    }
    return nil;
}

- (void) setForward:(CGPoint)forward {
    self.rotation = CC_RADIANS_TO_DEGREES(ccpAngleSigned(forward, ccp(1, 0)));
}

- (void) update:(ccTime)dt {
    if (atkTarget) {
        velocity = ccpSub(atkTarget.position, self.position);
    }
    [super update:dt];
}

- (void) behaviour:(ccTime)dt {
    switch (state) {
        case kIdleState:
        case kMoveState: {
            for (Monster* monster in [GameLayer sharedGameLayer].monsters) {
                if (monster.forceColor != self.forceColor && [monster isAlive]) {
                    CGPoint dis = ccpSub(monster.position, self.position);
                    if (ccpLengthSQ(dis) <= viewRange * viewRange) {
                        self.atkTarget = monster;
                        state = kAttackState;
                        return;
                    }
                }
            }
            for (Tower* tower in [GameLayer sharedGameLayer].towers) {
                if (tower.forceColor != self.forceColor && [tower isAlive]) {
                    CGPoint dis = ccpSub(tower.position, self.position);
                    if (ccpLengthSQ(dis) <= viewRange * viewRange) {
                        self.atkTarget = tower;
                        state = kAttackState;
                        return;
                    }
                }
            }
            
            break;
        }
        case kAttackState: {
            if ([atkTarget isAlive] == NO) {
                state = kIdleState;
                return;
            }
            if (ccpDistance(self.position, atkTarget.position) <= viewRange) {
                if (atkCooldown <= 0) {
                    [self fireBullet];
                    atkCooldown = atkSpeed;
                }
                else {
                    atkCooldown -= dt;
                }
            }
            else {
                state = kIdleState;
                return;
            }
            break;
        }
        default: {
            [super behaviour:dt];
            break;
        }
    }
}

- (void) fireBullet {
    bullet.visible = YES;
    bullet.position = self.position;
    [bullet runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1 position:atkTarget.position], [CCCallFunc actionWithTarget:self selector:@selector(bulletHit)], nil]];
}

- (void) bulletHit {
    bullet.visible = NO;
    
    for (Monster* monster in [GameLayer sharedGameLayer].monsters) {
        if (monster.forceColor != self.forceColor && [monster isAlive]) {
            CGPoint dis = ccpSub(monster.position, bullet.position);
            if (ccpLengthSQ(dis) <= atkRange * atkRange) {
                [monster damage:atk];
            }
        }
    }
    for (Tower* tower in [GameLayer sharedGameLayer].towers) {
        if (tower.forceColor != self.forceColor && [tower isAlive]) {
            CGPoint dis = ccpSub(tower.position, bullet.position);
            if (ccpLengthSQ(dis) <= atkRange * atkRange) {
                [tower damage:atk];
            }
        }
    }
}

- (void) dealloc {
    [bullet release];
    
    [super dealloc];
}

@end
