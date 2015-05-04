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
	//Save score to persistent storage so that saves can be continued
	Utility.pAffection = score;
	if (score> Utility.pHighScore)
		Utility.pHighScore=score;

	//Check if end affection is high enough to unlock stuff
	long currentUnlock = score/20;
	if (Utility.pUnlockedSceneCount<currentUnlock)
	{
		Utility.pUnlockedSceneCount=currentUnlock;
		Utility.pHighlightPlot = YES;
	}

	self.percentage = score;
}

+ (instancetype)progressWithDefault
{
    AffectionBar* _affectionBar = [super progressWithSprite:[CCSprite spriteWithImageNamed:@"Assets/heartbar2x.png"]];
    _affectionBar.type = CCProgressNodeTypeBar;
    _affectionBar.midpoint = ccp(0, 0);
    _affectionBar.barChangeRate = ccp(1, 0);
    _affectionBar.opacity = 1;
	//Continue the last play session
    _affectionBar.score = Utility.pAffection;

    return _affectionBar;
}

@end
