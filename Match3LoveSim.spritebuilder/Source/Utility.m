//
//  Utility.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Utility.h"

@implementation Utility
{

}

+(void) animate:(CCNode*)node name:(NSString*)name
{
	CCAnimationManager* animationManager = node.animationManager;
	[animationManager runAnimationsForSequenceNamed:name];
}


@end
