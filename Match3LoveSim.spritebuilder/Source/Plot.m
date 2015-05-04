//
//  Plot.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Plot.h"
#import "Utility.h"
#import "PlotNode.h"
#import "TutorialNode.h"

@implementation Plot {
    PlotNode* _plotIntro;
    PlotNode* _plotH0;
    PlotNode* _plotH1;
    PlotNode* _plotH2;
    PlotNode* _plotH3;
    PlotNode* _plotH4;
    PlotNode* _plotH5;
	TutorialNode* _plotTutorial;

    CCNode* _buttonGroup;

	CCButton* _backButton;
    CCButton* _skipButton;
	CCButton* _plotButton;

	CCButton* _buttonH0;
	CCButton* _buttonH1;
	CCButton* _buttonH2;
	CCButton* _buttonH3;
	CCButton* _buttonH4;
	CCButton* _buttonH5;

    PlotNode* _currentPlot;

}

- (void)didLoadFromCCB
{
	NSArray* buttonArray = [NSArray arrayWithObjects: _buttonH0, _buttonH1, _buttonH2, _buttonH2,_buttonH3,_buttonH4, _buttonH5,nil];
	long unlockCount = Utility.pUnlockedSceneCount;

	for (int i=0; i<7;i++)
	{
		CCButton* button = buttonArray[i];
		if (unlockCount >= i)
		{
			button.enabled=YES;
		}
		else
		{
			button.enabled=NO;
		}
	}

	Utility.pHighlightPlot = NO;
}

- (void)loadPlot:(PlotNode*)plotNode
{
	_buttonGroup.visible = NO;
    _currentPlot = plotNode;
    _currentPlot.visible = YES;
    _skipButton.visible = YES;
    _backButton.visible = NO;
	_plotButton.visible = YES;
}

- (void)intro
{
    [self loadPlot:_plotIntro];
}
- (void)tutorial
{
	[self loadPlot:_plotTutorial];
}

- (void)heart0
{
    [self loadPlot:_plotH0];
}
- (void)heart1
{
    [self loadPlot:_plotH1];
}
- (void)heart2
{
    [self loadPlot:_plotH2];
}
- (void)heart3
{
    [self loadPlot:_plotH3];
}
- (void)heart4
{
    [self loadPlot:_plotH4];
}
- (void)heart5
{
    [self loadPlot:_plotH5];
}



- (void)home
{
	[Utility switchScene:@"MainScene"];
}
- (void)skip
{
	_buttonGroup.visible = YES;
	_backButton.visible = YES;
    _skipButton.visible = NO;
	_plotButton.visible = NO;
    _currentPlot.visible = NO;
    _currentPlot = nil;
}

-(void)next
{
	int currScene = [_currentPlot next];
	//Scene has ended, remove overlay
	if (currScene == -1)
	{
		[self skip];
	}
}

@end
