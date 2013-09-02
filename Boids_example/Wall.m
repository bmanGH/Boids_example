//
//  Wall.m
//  Boids_example
//
//  Created by Xc Xu on 2/14/12.
//  Copyright (c) 2012 Break-medai. All rights reserved.
//

#import "Wall.h"

@implementation Wall

+ (id) wall {
    return [[[self alloc] initWithFile:@"wall1.png"] autorelease];
}

- (id) init {
    if (self = [super init]) {
        hp = 15;
        atk = 0;
        self.scale = 0.1;
        
        behaviourType = kNoFlock;
        maxSpeed = 0;
        neighbourRadius = 0;
        desiredSeparation = 10;
        
        separationWeight = 0;
        alignmentWeight = 0;
        cohesionWeight = 0;
        
        return self;
    }
    return nil;
}

- (void) update:(ccTime)dt {
    
}

@end
