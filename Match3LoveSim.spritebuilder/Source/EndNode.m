//
//  EndNode.m
//  Match3Shooter
//
//  Created by Rao Li on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EndNode.h"

@implementation EndNode

- (void)didLoadFromCCB {
	self.physicsBody.collisionType = @"end";
}

@end
