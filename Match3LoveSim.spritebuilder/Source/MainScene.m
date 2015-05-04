#import "MainScene.h"
#import "Utility.h"
#import "PlotNode.h"
#import "TutorialNode.h"

@implementation MainScene {
    CCLabelTTF* _levelCount;
    CCButton* _skipButton;
    CCButton* _plotButton;
    CCButton* _tutorialEndButton;

    PlotNode* _currentPlot;
    TutorialNode* _tutorial;

    CCNode* _content;
	CCNode* _plotHighlight;
}

- (void)didLoadFromCCB
{
    NSString* defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"SaveDefaults" ofType:@"plist"];
    NSDictionary* defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];

    self.dayCounter = Utility.pDayCounter;

	_plotHighlight.visible = Utility.pHighlightPlot;
    if (!Utility.pTutorialPlayed) {
        _content.visible = NO;
        _skipButton.visible = YES;
        _currentPlot.visible = YES;
        _plotButton.visible = YES;
    }
}

- (void)play
{
    [Utility switchScene:@"Gameplay"];
}
- (void)plot
{
    [Utility switchScene:@"Plot"];
}
- (void)credits
{
	Utility.pUnlockedSceneCount=5;
    [Utility switchScene:@"Credits"];
}

- (void)home
{
    [Utility switchScene:@"MainScene"];
}

- (void)setDayCounter:(long)dayCounter
{
    _dayCounter = dayCounter;
    _levelCount.string = [NSString stringWithFormat:@"%ld", _dayCounter];
}

- (void)skip
{
    _skipButton.visible = NO;
    _plotButton.visible = NO;
    _currentPlot.visible = NO;
    _tutorial.visible = YES;
    _tutorialEndButton.visible = YES;
    Utility.pTutorialPlayed = YES;
}

- (void)closeTutorial
{
    _tutorialEndButton.visible = NO;
    _tutorial.visible = NO;
    _content.visible = YES;
}

- (void)next
{
    if (!_tutorial.visible) {
        int currScene = [_currentPlot next];
        //Scene has ended, remove overlay
        if (currScene == -1)
            [self skip];
    }
    else {
        int currScene = [_tutorial next];
        //Scene has ended, remove overlay
        if (currScene == -1)
            [self closeTutorial];
    }
}

@end
