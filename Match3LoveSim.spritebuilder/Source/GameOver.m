//
//  GameOver.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/25/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOver.h"
#import "Utility.h"

@implementation GameOver
{
	CCButton* _button;
}

-(void)didLoadFromCCB
{
	if (Utility.pHighlightPlot)
	{
		_button.label.string = @"Continue";
	}
	else
	{
		_button.label.string = @"Replay?";
	}
}


- (void) home
{
	if (Utility.pHighlightPlot)
	{
		[Utility switchScene:@"MainScene"];
	}
	else
	{
		[Utility switchScene:@"Gameplay"];
	}
}

@end
