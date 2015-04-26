#import "MainScene.h"

@implementation MainScene

- (void)didLoadFromCCB
{
//	NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"Save.plist" ofType:@"plist"];
//	NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
//	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];
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
	CCScene* scene = [CCBReader loadAsScene:@"Credits"];
	[[CCDirector sharedDirector] replaceScene:scene];
}

- (void) home
{
	CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
	[[CCDirector sharedDirector] replaceScene:scene];
}
@end
