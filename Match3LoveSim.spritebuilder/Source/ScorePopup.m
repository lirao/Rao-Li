//
//  ScorePopup.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ScorePopup.h"
#import "Utility.h"

@implementation ScorePopup {
    CCLabelTTF* _comboLabel;
    CCLabelTTF* _label;
}

- (void)setMultiplier:(int)value
{
    _multiplier = value;
    _comboLabel.string = [NSString stringWithFormat:@"%dX", _multiplier];
}

- (void)setScore:(double)value
{
    _score = value;
    _label.string = [NSString stringWithFormat:@"%.f", _score];
}

- (CCAction *)runAction:(CCAction *)action
{
	CCAction *cloneAction = [action copy];

	[_comboLabel runAction:action];
	[_label runAction:cloneAction];
	return action;
}

-(void)animate
{
	[Utility animate:self name:@"Expand"];
}
-(void)animateEnd
{
	CCAnimationManager* animationManager = self.animationManager;
	[animationManager runAnimationsForSequenceNamed:@"ExpandEnd"];
}
@end
