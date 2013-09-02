//
//  Monster.m
//  Boids_example
//
//  Created by Xc Xu on 2/14/12.
//  Copyright (c) 2012 Break-medai. All rights reserved.
//

#import "Monster.h"
#import "MonsterLeader.h"
#import "GameLayer.h"
#import "Tower.h"

@implementation Monster

@synthesize leader;

+ (id) monsterWithLeader:(MonsterLeader*)monsterLeader {
    Monster* one = [[[self alloc] initWithFile:@"arrow2.png"] autorelease];
    one.leader = monsterLeader;
    return one;
}

- (id) init {
    if (self = [super init]) {
        hp = 10;
        atk = 1;
        atkSpeed = 0.5;
        viewRange = 40;
        self.scale = 0.1;
        
        behaviourType = kBoid;
        maxSpeed = 60;
        neighbourRadius = 50;
        desiredSeparation = 10;
        
        separationWeight = 4;
        alignmentWeight = 0.75;
        cohesionWeight = 0.3;
        
        return self;
    }
    return nil;
}

//- (CGPoint) cohere:(NSArray *)neighbours {
//    if (leader) {
//        CGPoint mean = leader.position;
//            
//        CGPoint desired = ccpSub(mean, self.position);
//        desired = ccpNormalize2(desired);
//        CGFloat d = ccpDistance(self.position, mean);
//        mean = ccpMult(desired, (d / leader.neighbourRadius) * (d / leader.neighbourRadius));
//        
//        return mean;
//    }
//    else {
//        return [super cohere:neighbours];
//    }
//}

- (void) step:(NSArray *)neighbours time:(ccTime)dt {
    switch (state) {
        case kIdleState:
        case kMoveState: {
            if (leader && [leader isAlive]) {
                CGFloat d = ccpDistance(self.position, leader.position);
                if (d < leader.neighbourRadius) {
        //            CGPoint acceleration = [self flock:neighbours];
        //            velocity = ccpAdd(velocity, acceleration);
        //            CCLOG(@"s0 %f :: %f", (d - leader.desiredSeparation), (leader.neighbourRadius - leader.desiredSeparation));
        //            CGFloat s = (d - leader.desiredSeparation) / (leader.neighbourRadius - leader.desiredSeparation);
        //            s = maxSpeed * s;
        //            CCLOG(@"s %f :: %f", s, ((d - leader.desiredSeparation) / (leader.neighbourRadius - leader.desiredSeparation)));
        ////            if (s < 0)
        ////                s = 0;
        //            if (ccpLength(velocity) > s)
        //                velocity = ccpMult(ccpNormalize2(velocity), s);
        //            if (s < 0.2)
        //                return;
        //            self.position = ccpAdd(self.position, ccpMult(velocity, dt));
                    
                    CGPoint acceleration = [self flock:neighbours];
                    velocity = ccpAdd(velocity, acceleration);
                    CGFloat s = ccpLength(leader.velocity);
                    if (ccpLength(velocity) > s)
                        velocity = ccpMult(ccpNormalize2(velocity), s);
                    self.position = ccpAdd(self.position, ccpMult(velocity, dt));
                }
                else {
                    CGPoint acceleration = [self flock:neighbours];
                    velocity = ccpAdd(velocity, acceleration);
                    if (ccpLength(velocity) > maxSpeed)
                        velocity = ccpMult(ccpNormalize2(velocity), maxSpeed);
                    self.position = ccpAdd(self.position, ccpMult(velocity, dt));
                }
            }
            else {
                CGPoint acceleration = [self flock:neighbours];
                velocity = ccpAdd(velocity, acceleration);
                if (ccpLength(velocity) > maxSpeed)
                    velocity = ccpMult(ccpNormalize2(velocity), maxSpeed);
                self.position = ccpAdd(self.position, ccpMult(velocity, dt));
            }
            break;
        }
        case kAttackState: {
            CGPoint acceleration = [self flock:neighbours];
            velocity = ccpAdd(velocity, acceleration);
            if (ccpLength(velocity) > maxSpeed)
                velocity = ccpMult(ccpNormalize2(velocity), maxSpeed);
            self.position = ccpAdd(self.position, ccpMult(velocity, dt));
            break;
        }
        case kDeathState: {
            break;
        }
    }
}

- (CGPoint) flock:(NSArray *)neighbours {
    switch (state) {
        case kIdleState:
        case kMoveState: {
            if (leader && [leader isAlive]) {
                CGFloat d = ccpDistance(self.position, leader.position);
                if (d > neighbourRadius) {
                    CGFloat s = ccpLength(velocity);
                    CGPoint separation = ccpMult([self separate:neighbours], separationWeight * s);
                    CGPoint alignment = ccpMult([self align:neighbours], alignmentWeight * s);
                    CGPoint cohesion = ccpMult([self cohere:neighbours], cohesionWeight * s);
                    CGPoint acceleration = ccpAdd(ccpAdd(separation, alignment), cohesion);
                    
                    CGPoint followVec = ccpSub(leader.position, self.position);
                    followVec = ccpNormalize2(followVec);
                    CGPoint follow = ccpMult(followVec, 0.1 * s);
                    return ccpAdd(acceleration, follow);
                }
                else {
                    CGFloat s = ccpLength(leader.velocity);
                    CGPoint separation = ccpMult([self separate:neighbours], separationWeight * s);
                    CGPoint v = ccpNormalize2(leader.velocity);
                    CGFloat sl = ccpLength(leader.velocity);
                    v = ccpMult(v, sl / leader.maxSpeed);
                    CGPoint alignment = ccpMult(v, 0.1 * s);
                    CGPoint cohesion = ccpMult([self cohere:neighbours], cohesionWeight * s);
                    CGPoint acceleration = ccpAdd(ccpAdd(separation, alignment), cohesion);
                    return acceleration;
                }
        //        else if (d > desiredSeparation) {
        //            CGFloat s = ccpLength(velocity);
        //            CGPoint separation = ccpMult([self separate:neighbours], separationWeight * s);
        //            CGPoint alignment = ccpMult([self align:neighbours], alignmentWeight * s);
        //            CGPoint cohesion = ccpMult([self cohere:neighbours], cohesionWeight * s);
        //            CGPoint acceleration = ccpAdd(ccpAdd(separation, alignment), cohesion);
        //            
        //            CGPoint followVec = ccpSub(leader.position, self.position);
        //            followVec = ccpNormalize2(followVec);
        ////            CGFloat s = ccpLength(velocity);
        //            CGPoint follow = ccpMult(followVec, s * (d / neighbourRadius) * (d / neighbourRadius));
        //            return ccpAdd(acceleration, follow);       
        //        }
        //        else {
        //            CGFloat s = ccpLength(velocity);
        //            CGPoint separation = ccpMult([self separate:neighbours], separationWeight * s);
        //            CGPoint alignment = ccpMult([self align:neighbours], alignmentWeight * s);
        //            CGPoint cohesion = ccpMult([self cohere:neighbours], cohesionWeight * s);
        //            CGPoint acceleration = ccpAdd(ccpAdd(separation, alignment), cohesion);
        //            return acceleration;
        //        }
            }
            else {
                CGFloat s = ccpLength(velocity);
                CGPoint separation = ccpMult([self separate:neighbours], separationWeight * s);
                CGPoint alignment = ccpMult([self align:neighbours], alignmentWeight * s);
                CGPoint cohesion = ccpMult([self cohere:neighbours], cohesionWeight * s);
                CGPoint acceleration = ccpAdd(ccpAdd(separation, alignment), cohesion);
                return acceleration;
            }
        }
        case kAttackState: {
            CGFloat s = ccpLength(velocity);
            CGPoint separation = ccpMult([self separate:neighbours], separationWeight * s);
            CGPoint traceVec = ccpSub(atkTarget.position, self.position);
            traceVec = ccpNormalize2(traceVec);
            CGPoint trace = ccpMult(traceVec, 0.5 * s);
            return ccpAdd(separation, trace);
        }
        case kDeathState: {
            return ccp(0,0);
        }
    }
    return ccp(0,0);
}

//- (void) update:(ccTime)dt {
//    [super update:dt];
//}

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
            
            [super behaviour:dt];
        }
        case kAttackState: {
            if ([atkTarget isAlive] == NO) {
                state = kIdleState;
                return;
            }
            if (ccpDistance(self.position, atkTarget.position) <= (self.desiredSeparation + atkTarget.desiredSeparation + 2.5)) {
                if (atkCooldown <= 0) {
                    [atkTarget damage:atk];
                    atkCooldown = atkSpeed;
                }
                else {
                    atkCooldown -= dt;
                }
            }
            else {
                [self step:[GameLayer sharedGameLayer].actors time:dt];
            }
            break;
        }
        default: {
            [super behaviour:dt];
            break;
        }
    }
}

- (void) dealloc {
    self.leader = nil;
    
    [super dealloc];
}

@end
