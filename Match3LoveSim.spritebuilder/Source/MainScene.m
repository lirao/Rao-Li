#import "MainScene.h"
#import "Utility.h"
#import "PlotNode.h"

@implementation MainScene {
    CCLabelTTF* _levelCount;
    CCButton* _skipButton;
    CCButton* _plotButton;

    PlotNode* _currentPlot;
}

- (void)didLoadFromCCB
{
    NSString* defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"SaveDefaults" ofType:@"plist"];
    NSDictionary* defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];

    self.dayCounter = Utility.pDayCounter;

    if (!Utility.pTutorialPlayed) {
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
	Utility.pTutorialPlayed = YES;
}

- (void)next
{
    int currScene = [_currentPlot next];
    //Scene has ended, remove overlay
    if (currScene == -1) {
        [self skip];
    }
}

@end
