//
//  AffectionBar.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "AffectionBar.h"

@implementation AffectionBar

- (void)setScore:(double)score
{
	//Save score to persistent storage
	[[NSUserDefaults standardUserDefaults] setDouble:score forKey:@"Affection"];
	self.percentage = score;
}

+ (instancetype)progressWithDefault
{
    AffectionBar* _affectionBar = [super progressWithSprite:[CCSprite spriteWithImageNamed:@"Assets/heartbar2x.png"]];
    _affectionBar.type = CCProgressNodeTypeBar;
    _affectionBar.midpoint = ccp(0, 0);
    _affectionBar.barChangeRate = ccp(1, 0);
    _affectionBar.opacity = 1;
    _affectionBar.score = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Affection"];

    return _affectionBar;
}

@end
