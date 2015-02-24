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
#import "Level.h"
#import "CCPhysics+ObjectiveChipmunk.h"


@implementation Gameplay {
    CCPhysicsNode* _physicsNode;

	//	Level* _level;
	Grid* _grid;

	CCLabelTTF *_lifeLabel;
	CCLabelTTF *_affectionLabel;

}

- (id)init
{
    if ((self = [super init])) {
    }

    return self;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
//    // tell this scene to accept touches
//    self.userInteractionEnabled = TRUE;
//    //Load test
//    CCScene* level = [CCBReader loadAsScene:@"Levels/TestLevel"];
//    [_levelNode addChild:level];

    // nothing shall collide with our invisible nodes
    //	_pullbackNode.physicsBody.collisionMask = @[];
    //	_mouseJointNode.physicsBody.collisionMask = @[];

    // visualize physics bodies & joints
    //_physicsNode.debugDraw = TRUE;

    //become own physics delegate
//    _physicsNode.collisionDelegate = self;

}
- (void)update:(CCTime)delta {

	_lifeLabel.string = [NSString stringWithFormat:@"%d", _grid.life];
	_affectionLabel.string = [NSString stringWithFormat:@"%d", _grid.affection];
}

@end
