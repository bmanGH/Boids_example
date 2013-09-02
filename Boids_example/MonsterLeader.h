//
//  MonsterLeader.h
//  Boids_example
//
//  Created by Xc Xu on 2/15/12.
//  Copyright (c) 2012 Break-medai. All rights reserved.
//

#import "Actor.h"

@interface MonsterLeader : Actor {
    CGPoint moveTarget;
}

@property (nonatomic, readwrite, assign) CGPoint moveTarget;

+ (id) monsterLeader;

@end
