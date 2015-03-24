//
//  Grid.h
//  Match3LoveSim
//
//  Created by Rao Li on 2/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Grid : CCNode

@property (nonatomic, assign) int life;
@property (nonatomic, assign) int affection;
//@property (nonatomic, assign) float cellWidth;
//@property (nonatomic, assign) float cellHeight;
@property (nonatomic, strong) Gameplay* gamePlay;

@end
