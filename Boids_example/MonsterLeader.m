//
//  MonsterLeader.m
//  Boids_example
//
//  Created by Xc Xu on 2/15/12.
//  Copyright (c) 2012 Break-medai. All rights reserved.
//

#import "MonsterLeader.h"
#import "GameLayer.h"

@implementation MonsterLeader

@synthesize moveTarget;

+ (id) monsterLeader {
    return [[[MonsterLeader alloc] initWithFile:@"arrow2.png"] autorelease];
}

- (id) init {
    if (self = [super init]) {
        hp = 40;
        atk = 3;
        atkSpeed = 0.5;
        viewRange = 60;
        self.scale = 0.2;
        self.color = ccYELLOW;
        
        behaviourType = kLeader;
        maxSpeed = 40;
        
        neighbourRadius = 50;
        desiredSeparation = 15;
        
        separationWeight = 2;
        alignmentWeight = 0.75;
        cohesionWeight = 0.3;
        
        moveTarget = ccp(0,0);
        
        return self;
    }
    return nil;
}

- (CGPoint) flock:(NSArray*)neighbours {
    CGFloat s = ccpLength(velocity);
    CGPoint separation = ccpMult([self separate:neighbours], separationWeight * s);
    
    CGPoint targetVec = ccpSub(moveTarget, self.position);
    if (ccpDistance(targetVec, self.position) > 5) {
        targetVec = ccpNormalize2(targetVec);
        CGPoint move = ccpMult(targetVec, 0.2 * s);
        return ccpAdd(separation, move);
    }
    else {
        return separation;
    }
}

//- (void) update:(ccTime)dt {
//    [super update:dt];
//}

- (void) behaviour:(ccTime)dt {
    switch (state) {
        case kIdleState: {
            [super behaviour:dt];
            break;
        }
        case kMoveState: {
            [super behaviour:dt];
            break;
        }
        case kAttackState: {
            
            break;
        }
        default:
            [super behaviour:dt];
            break;
    }
}

@end
