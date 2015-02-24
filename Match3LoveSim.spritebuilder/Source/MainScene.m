#import "MainScene.h"

@implementation MainScene

- (void)play
{
	// Replaces MainScene with game scene called Gameplay.ccb
	CCScene* gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
	[[CCDirector sharedDirector] replaceScene:gameplayScene];
}
@end
