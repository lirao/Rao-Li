//
//  Gameplay.m
//  Match3LoveSim
//
//  Created by Rao Li on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Orb.h"
#import "Grid.h"
#import "Level.h"
#import "Expression.h"
#import "Slime.h"
#import "TimeBar.h"
#import "AffectionBar.h"
#import "CCPhysics+ObjectiveChipmunk.h"


@implementation Gameplay {

	//	Level* _level;
	Grid* _grid;

	CCLabelTTF *_lifeLabel;
	CCLabelTTF *_affectionLabel;
	CCLabelTTF *_multiplierLabel;
	CCLabelTTF *_scoreLabel;

	Expression *_expressionA;
	Expression *_expressionB;
	Slime *_slimeA;
	Slime *_slimeB;

	TimeBar *_timeBar;
	AffectionBar *_affectionBar;
	
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
	_grid.gamePlay = self;

	// access audio object
	OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
	// play bgm
	[audio playBg:@"/Resources/Audio/tampi05.mp3" loop:YES];
	//Preload sfx
	[audio preloadEffect:@"/Resources/Audio/tampi05.mp3"];


}

- (void)update:(CCTime)delta {
//	_lifeLabel.string = [NSString stringWithFormat:@"%.f", _life];
//	_affectionLabel.string = [NSString stringWithFormat:@"%.f", _affection];
//	_affectionLabel.string = [NSString stringWithFormat:@"%dX", _multiplier];
//	_affectionLabel.string = [NSString stringWithFormat:@"%f", _score];

	_affectionBar.percentage =_affection/100;
	_timeBar.percentage = _life/100;

}

- (void) updateExpression: (MyValue)orbColor {
	[_expressionA changeExp:orbColor];
	[_expressionB changeExp:orbColor];
}

@end
