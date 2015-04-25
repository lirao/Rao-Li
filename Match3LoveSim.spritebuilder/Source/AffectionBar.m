//
//  AffectionBar.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "AffectionBar.h"

static long TOTAL_AFFECTION = 1000;
@implementation AffectionBar {
    //	CCSprite *_barSprite;
}

- (void)setScore:(double)score
{
	self.percentage = score;
}

//- (void)didLoadFromCCB
//{
//	self.sprite = _barSprite;
//	[self removeChild:_barSprite];
//	self.type = CCProgressNodeTypeBar;
//	self.midpoint = ccp(0,0);
//
//	//Load the persisted score
////	NSInteger score = [[NSUserDefaults standardUserDefaults] integerForKey:@"kCumulativeScore"];
//	self.percentage = 100;
//}
+ (instancetype)affectionBarDefault
{
    AffectionBar* _affectionBar = [super progressWithSprite:[CCSprite spriteWithImageNamed:@"Assets/heartbar2x.png"]];
    _affectionBar.type = CCProgressNodeTypeBar;
    _affectionBar.midpoint = ccp(0, 0);
    _affectionBar.barChangeRate = ccp(1, 0);
    _affectionBar.opacity = 1;
    _affectionBar.score = 45;

    return _affectionBar;
}

@end
