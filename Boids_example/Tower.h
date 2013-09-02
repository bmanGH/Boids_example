//
//  Tower.h
//  Boids_example
//
//  Created by Xc Xu on 2/14/12.
//  Copyright (c) 2012 Break-medai. All rights reserved.
//

#import "Actor.h"

@interface Tower : Actor {
    CGFloat atkRange;
    CCSprite* bullet;
    CGPoint bulletTargetPos;
}

+ (id) tower;

- (void) fireBullet;
- (void) bulletHit;

@end
