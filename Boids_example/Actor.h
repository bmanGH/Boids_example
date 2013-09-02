//
//  Actor.h
//  Boids_example
//
//  Created by Xc Xu on 2/14/12.
//  Copyright (c) 2012 Break-medai. All rights reserved.
//

#import "Boid.h"


typedef enum _BehaviourType {
    kNoFlock,
    kLeader,
    kBoid,
    kObstacle
} BehaviourType;

typedef enum _ActorState {
    kIdleState,
    kAttackState,
    kMoveState,
    kDeathState
} ActorState;

typedef enum _ForceColor {
    kForceWhite,
    kForceBlue
} ForceColor;

@interface Actor : Boid {
@protected
    ForceColor forceColor;
    BehaviourType behaviourType;
    ActorState state;
    NSInteger hp;
    NSInteger atk;
    CGFloat viewRange;
    CGFloat atkSpeed;
    CGFloat atkCooldown;
    NSInteger damageEffectTimer;
    Actor* atkTarget;
}

@property (nonatomic, readwrite, assign) BehaviourType behaviourType;
@property (nonatomic, readwrite, assign) NSInteger atk;
@property (nonatomic, readwrite, assign) ForceColor forceColor;
@property (nonatomic, readwrite, retain) Actor* atkTarget;

- (void) damage:(NSInteger)value;
- (BOOL) isAlive;
- (void) setForward:(CGPoint)forward;
- (void) update:(ccTime)dt;
- (void) behaviour:(ccTime)dt;

@end
