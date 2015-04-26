//
//  Plot.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Plot.h"

@implementation Plot {
	CCNode *_plotIntro;
	CCNode *_plotH0;
	CCNode *_plotH1;
	CCNode *_plotH2;
	CCNode *_plotH3;
	CCNode *_plotH4;
	CCNode *_plotH5;
	CCNode *_buttonGroup;
	CCButton *_backButton;
	CCButton *_skipButton;


	CCNode *_currentPlot;

}

-(void)didLoadFromCCB
{
	[self removeChild:_plotIntro];
	[self removeChild:_plotH0];
	[self removeChild:_plotH1];
	[self removeChild:_plotH2];
	[self removeChild:_plotH3];
	[self removeChild:_plotH4];
	[self removeChild:_plotH5];

}

-(void)loadPlot: (CCNode*) plotNode
{
	_currentPlot=plotNode;
	[self addChild:_currentPlot];
	_skipButton.visible = YES;
	_backButton.visible = NO;

}

- (void)intro
{
	[self loadPlot: _plotIntro];
}
- (void)heart0
{
	[self loadPlot: _plotH0];
}
- (void)heart1
{
	[self loadPlot: _plotH1];
}
- (void)heart2
{
	[self loadPlot: _plotH2];
}
- (void)heart3
{
	[self loadPlot: _plotH3];
}
- (void)heart4
{
	[self loadPlot: _plotH4];
}
- (void)heart5
{
	[self loadPlot: _plotH5];
}

- (void)next
{

}

- (void)home
{
	CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
	[[CCDirector sharedDirector] replaceScene:scene];
}

- (void)skip
{
	_skipButton.visible = NO;
	_currentPlot.visible = NO;
	[self removeChild: _currentPlot];
	_currentPlot = nil;
}

@end
