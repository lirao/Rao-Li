//
//  Gameplay.h
//  Match3LoveSim
//
//  Created by Rao Li on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Orb.h"


@interface Gameplay : CCNode

@property (nonatomic, assign) double life;
@property (nonatomic, assign) double affection;
@property (nonatomic, assign) int multiplier;
@property (nonatomic, assign) double score;
- (void) updateExpression: (MyValue)orbColor;
- (void) endDay;
@end
