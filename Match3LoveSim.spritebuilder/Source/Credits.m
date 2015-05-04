//
//  Credits.m
//  Match3LoveSim
//
//  Created by Rao Li on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Credits.h"
#import "Utility.h"
@implementation Credits
{
	CCLabelTTF* _highScore;
	CCLabelTTF* _maxCombo;
}
- (void)didLoadFromCCB
{
	_highScore.string = [NSString stringWithFormat:@"%f", Utility.pHighScore];
	_maxCombo.string= [NSString stringWithFormat:@"%ld", Utility.pMaxCombo];

}
- (void)home
{
	CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
	[[CCDirector sharedDirector] replaceScene:scene];
}
- (void)reset
{
	Utility.pTutorialPlayed=NO;
	Utility.pHighlightPlot=YES;
}
@end
