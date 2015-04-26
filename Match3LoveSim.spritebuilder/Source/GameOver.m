//
//  GameOver.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/25/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver

- (void) home
{
	CCScene* scene = [CCBReader loadAsScene:@"MainScene"];
	[[CCDirector sharedDirector] replaceScene:scene];
}

@end
