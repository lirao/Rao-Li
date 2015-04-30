#import "MainScene.h"
#import "Utility.h"

@implementation MainScene
{
	CCLabelTTF *_levelCount;
}

- (void)didLoadFromCCB
{
	NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"SaveDefaults" ofType:@"plist"];
	NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];

	self.dayCounter = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"DayCounter"];
}

- (void)play
{
	// Replaces MainScene with game scene called Gameplay.ccb
	CCScene* gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
	[[CCDirector sharedDirector] replaceScene:gameplayScene];
}
- (void)plot
{
	CCScene* scene = [CCBReader loadAsScene:@"Plot"];
	[[CCDirector sharedDirector] replaceScene:scene];
}
- (void)credits
{
//	CCScene* scene = [CCBReader loadAsScene:@"Credits"];
//	[[CCDirector sharedDirector] replaceScene:scene];
}

- (void) home
{
	CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
	[[CCDirector sharedDirector] replaceScene:scene];
}

- (void) setDayCounter:(int)dayCounter
{
	_dayCounter = dayCounter;
	_levelCount.string = [NSString stringWithFormat:@"%d", _dayCounter];
}
@end
