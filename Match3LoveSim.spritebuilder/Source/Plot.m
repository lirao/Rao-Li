//
//  Plot.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Plot.h"
#import "Utility.h"

@implementation Plot {
    CCNode* _plotIntro;
    CCNode* _plotH0;
    CCNode* _plotH1;
    CCNode* _plotH2;
    CCNode* _plotH3;
    CCNode* _plotH4;
    CCNode* _plotH5;
    CCNode* _buttonGroup;
    CCButton* _backButton;
    CCButton* _skipButton;
	
	CCButton* _buttonH0;
	CCButton* _buttonH1;
	CCButton* _buttonH2;
	CCButton* _buttonH3;
	CCButton* _buttonH4;
	CCButton* _buttonH5;

    CCNode* _currentPlot;
}

- (void)didLoadFromCCB
{
	
}

- (void)loadPlot:(CCNode*)plotNode
{
	_buttonGroup.visible = NO;
    _currentPlot = plotNode;
    _currentPlot.visible = YES;
    _skipButton.visible = YES;
    _backButton.visible = NO;
}

- (void)intro
{
    [self loadPlot:_plotIntro];
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
//    [self loadPlot:_plotH2];
}
- (void)heart3
{
//    [self loadPlot:_plotH3];
}
- (void)heart4
{
//    [self loadPlot:_plotH4];
}
- (void)heart5
{
//    [self loadPlot:_plotH5];
}

- (void)home
{
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)skip
{
	_buttonGroup.visible = YES;
	_backButton.visible = YES;
    _skipButton.visible = NO;
    _currentPlot.visible = NO;
    _currentPlot = nil;
}

@end