#import "MainScene.h"

@implementation MainScene

- (void)play
{
	// Replaces MainScene with game scene called Gameplay.ccb
	CCScene* gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
	[[CCDirector sharedDirector] replaceScene:gameplayScene];
}
- (void)plot
{
	// Replaces MainScene with game scene called Gameplay.ccb
	CCScene* scene = [CCBReader loadAsScene:@"Plot"];
	[[CCDirector sharedDirector] replaceScene:scene];
}
- (void)credits
{
	// Replaces MainScene with game scene called Gameplay.ccb
	CCScene* scene = [CCBReader loadAsScene:@"Credits"];
	[[CCDirector sharedDirector] replaceScene:scene];
}
@end
