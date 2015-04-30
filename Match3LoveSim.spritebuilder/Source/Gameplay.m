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
#import "Expression.h"
#import "Slime.h"
#import "TimeBar.h"
#import "AffectionBar.h"
#import "GameOver.h"
#import "Utility.h"
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
    CCNode* _popupA;
    CCNode* _popupB;

    TimeBar* _timeBar;
    AffectionBar* _affectionBar;

    CCSprite* _heartSprite;
    CCSprite* _gradientSprite;

    GameOver* _gameOver;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
    _grid.gamePlay = self;

    // access audio object
    OALSimpleAudio* audio = [OALSimpleAudio sharedInstance];
    // play bgm
    [audio playBg:@"/Audio/tampi05.mp3" loop:YES];
    //Preload sfx
    [audio preloadEffect:@"/Audio/tampi05.mp3"];

    _affectionBar = [AffectionBar progressWithDefault];
    _affectionBar.position = _heartSprite.position;
    _affectionBar.anchorPoint = _heartSprite.anchorPoint;
    _affectionBar.positionType = _heartSprite.positionType;
    [self addChild:_affectionBar];
    _affection = _affectionBar.percentage; //Sync up _affection from saved value

    _timeBar = [TimeBar progressWithDefault];
    _timeBar.position = _gradientSprite.position;
    _timeBar.anchorPoint = _gradientSprite.anchorPoint;
    _timeBar.positionType = _heartSprite.positionType;
    [self addChild:_timeBar];
    //Init values;
    self.life = 100;
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
    switch (orbColor) {
    case HEAL:
        [Utility animate:_popupA name:@"eat"];
        break;
    case PTDOWN:
        [Utility animate:_popupB name:@"anger"];
        break;
    case PTDOWNSP:
        [Utility animate:_popupB name:@"heartbreak"];
        break;
    case NEUTRAL:
        [Utility animate:_slimeA name:@"spin"];
        [Utility animate:_slimeB name:@"spin"];
        break;
    case PTUP:
        [Utility animate:_popupB name:@"musicnote"];
        break;
    case PTUPSP:
        [Utility animate:_popupB name:@"heartup"];
        break;
    default:
        break;
    }
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
    _affectionBar.score = self.affection / 10;
}

- (void)endDay
{
    int dayCounter = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"DayCounter"];
    [[NSUserDefaults standardUserDefaults] setInteger:(dayCounter + 1)forKey:@"DayCounter"];

    _gameOver.visible = YES;
}
- (void)heartAnimate
{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"heartup"];
}

- (void)home
{
    CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}
@end
