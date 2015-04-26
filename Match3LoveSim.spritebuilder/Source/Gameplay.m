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

    CCLabelTTF* _lifeLabel;
    CCLabelTTF* _affectionLabel;
    CCLabelTTF* _multiplierLabel;
    CCLabelTTF* _scoreLabel;

    Expression* _expressionA;
    Expression* _expressionB;
    Slime* _slimeA;
    Slime* _slimeB;

    TimeBar* _timeBar;
    AffectionBar* _affectionBar;

    CCSprite* _heartSprite;
    CCSprite* _gradientSprite;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
    _grid.gamePlay = self;

    // access audio object
    OALSimpleAudio* audio = [OALSimpleAudio sharedInstance];
    // play bgm
    [audio playBg:@"/Resources/Audio/tampi05.mp3" loop:YES];
    //Preload sfx
    [audio preloadEffect:@"/Resources/Audio/tampi05.mp3"];

    _affectionBar = [AffectionBar progressWithDefault];
    _affectionBar.position = _heartSprite.position;
    _affectionBar.anchorPoint = _heartSprite.anchorPoint;
    _affectionBar.positionType = _heartSprite.positionType;
    [self addChild:_affectionBar];

    _timeBar = [TimeBar progressWithDefault];
    _timeBar.position = _gradientSprite.position;
    _timeBar.anchorPoint = _gradientSprite.anchorPoint;
    _timeBar.positionType = _heartSprite.positionType;
    [self addChild:_timeBar];
}

- (void)update:(CCTime)delta
{
    //	_lifeLabel.string = [NSString stringWithFormat:@"%.f", _life];
    //	_affectionLabel.string = [NSString stringWithFormat:@"%.f", _affection];
    //	_affectionLabel.string = [NSString stringWithFormat:@"%dX", _multiplier];
    //	_affectionLabel.string = [NSString stringWithFormat:@"%f", _score];
}

- (void)updateExpression:(MyValue)orbColor
{
    [_expressionA changeExp:orbColor];
    [_expressionB changeExp:orbColor];
}

- (void)setLife:(double)life
{
    if (life > 100)
        life = 100;
    else if (life <= 0)
        life = 0;
    _life = life;
    _timeBar.percentage = self.life;
}

- (void)setAffection:(double)affection
{
    if (affection > 1000)
        affection = 1000;
    else if (affection <= 0)
        affection = 0;
    _affection = affection;
    _affectionBar.percentage = self.affection / 10;
}

- (void)endDay
{
}

- (void)home
{
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}
@end
