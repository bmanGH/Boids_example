//
//  Monster.h
//  Boids_example
//
//  Created by Xc Xu on 2/14/12.
//  Copyright (c) 2012 Break-medai. All rights reserved.
//

#import "Actor.h"

@class MonsterLeader;
@interface Monster : Actor {
    MonsterLeader* leader;
}

@property (nonatomic, readwrite, retain) MonsterLeader* leader;

+ (id) monsterWithLeader:(MonsterLeader*)monsterLeader;

@end
