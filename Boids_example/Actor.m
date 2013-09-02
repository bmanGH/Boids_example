//
//  Actor.m
//  Boids_example
//
//  Created by Xc Xu on 2/14/12.
//  Copyright (c) 2012 Break-medai. All rights reserved.
//

#import "Actor.h"
#import "GameLayer.h"

@interface Actor (Private)

- (CGPoint) avoidObstacle:(NSArray*)obstacles;

@end

@implementation Actor

@synthesize atk;
@synthesize behaviourType;
@synthesize forceColor;
@synthesize atkTarget;

- (id) init {
    if (self = [super init]) {
        forceColor = kForceWhite;
        behaviourType = kBoid;
        state = kIdleState;
        [self scheduleUpdate];
        return self;
    }
    return nil;
}

- (void) damage:(NSInteger)value {
    hp -= value;
    damageEffectTimer = 3;
    self.color = ccRED;
    if (hp <= 0) {
//        self.visible = NO;
        self.color = ccGRAY;
        state = kDeathState;
        [self unscheduleUpdate];
    }
}

- (BOOL) isAlive {
    return (hp > 0);
}

- (void) setForward:(CGPoint)forward {
    self.rotation = CC_RADIANS_TO_DEGREES(ccpAngleSigned(forward, ccp(0, 1)));
}

- (void) setForceColor:(ForceColor)value {
    forceColor = value;
    if (forceColor == kForceWhite)
        self.color = ccWHITE;
    else
        self.color = ccBLUE;
}

- (void) update:(ccTime)dt {
    [self behaviour:dt];
    
    [self setForward:self.velocity];
    
    if (atkCooldown > 0) {
        atkCooldown -= dt;
    }
    
    if (damageEffectTimer > 0) {
        damageEffectTimer--;
        if (damageEffectTimer <= 0) {
            if (self.forceColor == kForceWhite)
                self.color = ccWHITE;
            else
                self.color = ccBLUE;
        }
    }
}

- (void) behaviour:(ccTime)dt {
    switch (state) {
        case kIdleState:
        case kMoveState: {
            switch (behaviourType) {
                case kNoFlock: {
                    break;
                }
                case kLeader: {
                    [self step:[GameLayer sharedGameLayer].walls time:dt];
                    break;
                }
                case kBoid: {
                    [self step:[GameLayer sharedGameLayer].actors time:dt];
                    break;
                }
                case kObstacle: {
                    break;
                }
            }
            break;
        }
        case kAttackState: {
            break;
        }
        case kDeathState: {
            break;
        }
    }
}

- (CGPoint) separate:(NSArray*)neighbours {
    CGPoint mean = CGPointZero;
    NSInteger count = 0;
    for (Actor* boid in neighbours) {
        if (boid == self || [boid isAlive] == NO)
            continue;
        
        CGFloat dis = ccpDistance(self.position, boid.position);
        if (dis < (desiredSeparation + boid.desiredSeparation)) {
            CGPoint p = ccpSub(self.position, boid.position);
            p = ccpNormalize2(p);
            p = ccpMult(p, ((desiredSeparation + boid.desiredSeparation) - dis) / (desiredSeparation + boid.desiredSeparation));
            mean = ccpAdd(mean, p);
            count++;
        }
    }
    
    if (count > 0) {
        mean = ccpMult(mean, 1.0 / count);
    }
    
    return mean;
}

- (CGPoint) align:(NSArray*)neighbours {
    CGPoint mean = CGPointZero;
    NSInteger count = 0;
    for (Actor* boid in neighbours) {
        if (boid == self || [boid isAlive] == NO)
            continue;
        
        CGFloat dis = ccpDistance(self.position, boid.position);
        if (dis < neighbourRadius) {
            mean = ccpAdd(mean, boid.velocity);
            count++;
        }
    }
    
    if (count > 0) {
        mean = ccpMult(mean, 1.0 / count);
        mean = ccpNormalize2(mean);
        CGFloat s = ccpLength(mean);
        mean = ccpMult(mean, s / maxSpeed);
    }
    
    return mean;
}

- (CGPoint) cohere:(NSArray*)neighbours {
    CGPoint mean = CGPointZero;
    NSInteger count = 0;
    for (Actor* boid in neighbours) {
        if (boid == self || [boid isAlive] == NO)
            continue;
        
        CGFloat dis = ccpDistance(boid.position, self.position);
        if (dis < neighbourRadius) {
            mean = ccpAdd(mean, boid.position);
            count++;
        }
    }
    
    if (count > 0) {
        mean = ccpMult(mean, 1.0 / count);
        
        CGPoint desired = ccpSub(mean, self.position);
        desired = ccpNormalize2(desired);
        CGFloat d = ccpDistance(self.position, mean);
        //        mean = ccpMult(desired, (d / neighbourRadius) * (d / neighbourRadius));
        mean = ccpMult(desired, (d / neighbourRadius));
    }
    
    return mean;
}

- (void) dealloc {
    [self unscheduleUpdate];
    [super dealloc];
}

@end
