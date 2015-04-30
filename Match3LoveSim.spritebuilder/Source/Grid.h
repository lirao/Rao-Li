//
//  Grid.h
//  Match3LoveSim
//
//  Created by Rao Li on 2/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Gameplay.h"

@interface Grid : CCNode<CCPhysicsCollisionDelegate>

@property (nonatomic, strong) Gameplay* gamePlay;

@end
