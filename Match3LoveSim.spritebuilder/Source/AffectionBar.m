//
//  AffectionBar.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "AffectionBar.h"
#import "Utility.h"

@implementation AffectionBar

- (void)setScore:(double)score
{
	//Save score to persistent storage
	Utility.pAffection = score;
	self.percentage = score;
}

+ (instancetype)progressWithDefault
{
    AffectionBar* _affectionBar = [super progressWithSprite:[CCSprite spriteWithImageNamed:@"Assets/heartbar2x.png"]];
    _affectionBar.type = CCProgressNodeTypeBar;
    _affectionBar.midpoint = ccp(0, 0);
    _affectionBar.barChangeRate = ccp(1, 0);
    _affectionBar.opacity = 1;
    _affectionBar.score = Utility.pAffection;

    return _affectionBar;
}

@end
