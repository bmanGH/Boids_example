//
//  Boid.h
//  Boids_example
//
//  Created by Xc Xu on 2/13/12.
//  Copyright (c) 2012 Break-medai. All rights reserved.
//

#import "cocos2d.h"

extern CGPoint ccpNormalize2 (const CGPoint v);

@interface Boid : CCSprite {
@protected
    CGPoint velocity;
    CGFloat maxSpeed;
    CGFloat neighbourRadius;
    CGFloat desiredSeparation;
    CGFloat separationWeight;
    CGFloat alignmentWeight;
    CGFloat cohesionWeight;
}

@property (nonatomic, readwrite, assign) CGPoint velocity;
@property (nonatomic, readwrite, assign) CGFloat maxSpeed;
@property (nonatomic, readwrite, assign) CGFloat neighbourRadius;
@property (nonatomic, readwrite, assign) CGFloat desiredSeparation;
@property (nonatomic, readwrite, assign) CGFloat separationWeight;
@property (nonatomic, readwrite, assign) CGFloat alignmentWeight;
@property (nonatomic, readwrite, assign) CGFloat cohesionWeight;


- (void) step:(NSArray*)neighbours time:(ccTime)dt;
- (CGPoint) flock:(NSArray*)neighbours;
- (CGPoint) separate:(NSArray*)neighbours;
- (CGPoint) align:(NSArray*)neighbours;
- (CGPoint) cohere:(NSArray*)neighbours;

@end
