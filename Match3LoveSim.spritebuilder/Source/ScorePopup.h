//
//  ScorePopup.h
//  Match3LoveSim
//
//  Created by Rao Li on 4/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Orb.h"

@interface ScorePopup : CCNode

@property (nonatomic, assign) int multiplier;
@property (nonatomic, assign) double score;
@property (nonatomic, assign) MyValue orbColor;
- (void) animate;
-(void)animateEnd;
@end
