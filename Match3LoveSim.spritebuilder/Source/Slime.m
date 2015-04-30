//
//  Slime.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Slime.h"
#import "Utility.h"

@implementation Slime
{
	CCSprite *_slimeSprite;
}


- (void)didLoadFromCCB
{
	_slimeSprite.texture.antialiased=NO;
}

- (void)stand
{
	CCAnimationManager* animationManager = self.animationManager;
	[animationManager runAnimationsForSequenceNamed:@"stand"];
}

- (void)spin
{
	CCAnimationManager* animationManager = self.animationManager;
	[animationManager runAnimationsForSequenceNamed:@"spin"];
}
@end
