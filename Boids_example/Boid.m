//
//  Boid.m
//  Boids_example
//
//  Created by Xc Xu on 2/13/12.
//  Copyright (c) 2012 Break-medai. All rights reserved.
//

#import "Boid.h"

CGPoint
ccpNormalize2(const CGPoint v)
{
    CGFloat l = ccpLength(v);
    if (l == 0)
        return ccp(0,0);
    else
        return ccpMult(v, 1.0f/ccpLength(v));
}

@implementation Boid

@synthesize velocity;
@synthesize maxSpeed;
@synthesize neighbourRadius;
@synthesize desiredSeparation;
@synthesize separationWeight;
@synthesize alignmentWeight;
@synthesize cohesionWeight;

- (id) init {
    if (self = [super init]) {
        velocity = ccp(0, 0);
        maxSpeed = 60;
        neighbourRadius = 50;
        desiredSeparation = 10;
        
        separationWeight = 2;
        alignmentWeight = 0.75;
        cohesionWeight = 0.3;
        return self;
    }
    return nil;
}

- (void) step:(NSArray*)neighbours time:(ccTime)dt { 
    CGPoint acceleration = [self flock:neighbours];
    velocity = ccpAdd(velocity, acceleration);
    CGFloat s = ccpLength(velocity);
    if (s > maxSpeed)
        velocity = ccpMult(ccpNormalize2(velocity), maxSpeed);
    self.position = ccpAdd(self.position, ccpMult(velocity, dt));
}

- (CGPoint) flock:(NSArray*)neighbours {
    CGFloat s = ccpLength(velocity);
    CGPoint separation = ccpMult([self separate:neighbours], separationWeight * s);
    CGPoint alignment = ccpMult([self align:neighbours], alignmentWeight * s);
    CGPoint cohesion = ccpMult([self cohere:neighbours], cohesionWeight * s);
    return ccpAdd(ccpAdd(separation, alignment), cohesion);
}

- (CGPoint) separate:(NSArray*)neighbours {
    CGPoint mean = CGPointZero;
    NSInteger count = 0;
    for (Boid* boid in neighbours) {
        if (boid == self)
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
    for (Boid* boid in neighbours) {
        if (boid == self)
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
    for (Boid* boid in neighbours) {
        if (boid == self)
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

@end
