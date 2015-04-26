//
//  TimeBar.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TimeBar.h"

@implementation TimeBar

- (void)setScore:(double)score
{
	self.percentage = score;
}

+ (instancetype)progressWithDefault
{
	TimeBar* _timeBar = [super progressWithSprite:[CCSprite spriteWithImageNamed:@"Assets/gradientorange.png"]];
	_timeBar.type = CCProgressNodeTypeBar;
	_timeBar.midpoint = ccp(0, 0);
	_timeBar.barChangeRate = ccp(1, 0);
	_timeBar.opacity = 1;
	_timeBar.score = 100;

	return _timeBar;
}

@end
