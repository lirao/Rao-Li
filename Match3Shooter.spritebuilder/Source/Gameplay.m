//
//  Gameplay.m
//  Match3Shooter
//
//  Created by Rao Li on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "EndNode.h"
#import "CCActionInterval.h"

static const float MIN_SPEED = 5.f;

@implementation Gameplay {
	CCPhysicsNode* _physicsNode;
	CCNode* _startNode;
	CCNode* _endNode;
	CCNode* _levelNode;
//	CCNode* _pullbackNode;
	//Mouse pullback
//	CCNode* _mouseJointNode;
//	CCPhysicsJoint* _mouseJoint;

	ccBezierConfig _ballPath;
	CCActionBezierTo ballPathAction;

	//Ball launch
//	Penguin* _currentPenguin;
//	CCPhysicsJoint* _penguinCatapultJoint;

	//Track the scroll action
//	CCAction* _followPenguin;
}

- (void)update:(CCTime)delta
{
	if (_currentPenguin.launched) {
		// if speed is below minimum speed, assume this attempt is over
		if (ccpLength(_currentPenguin.physicsBody.velocity) < MIN_SPEED) {
			[self nextAttempt];
			return;
		}

		int xMin = _currentPenguin.boundingBox.origin.x;

		if (xMin < self.boundingBox.origin.x) {
			[self nextAttempt];
			return;
		}

		int xMax = xMin + _currentPenguin.boundingBox.size.width;

		if (xMax > (self.boundingBox.origin.x + self.boundingBox.size.width)) {
			[self nextAttempt];
			return;
		}
	}
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
	// tell this scene to accept touches
	self.userInteractionEnabled = TRUE;
	//Load test
	CCScene* level = [CCBReader loadAsScene:@"Levels/TestLevel"];
	[_levelNode addChild:level];

	// nothing shall collide with our invisible nodes
//	_pullbackNode.physicsBody.collisionMask = @[];
//	_mouseJointNode.physicsBody.collisionMask = @[];

	// visualize physics bodies & joints
	//_physicsNode.debugDraw = TRUE;

	//become own physics delegate
	_physicsNode.collisionDelegate = self;

	//Set up bezier curve

	_ballPath.controlPoint_1 = CGPointMake(-20.0f, 290.0f);
	_ballPath.controlPoint_2 = CGPointMake(260, 290.0f);
	_ballPath.endPosition = [_endNode positionInPoints];

	id bezierForward = [CCActionBezierTo ];
//	[sprite runAction:bezierForward];



}

// called on every touch in this scene
- (void)touchBegan:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{

	//Get the touchlocation
	CGPoint touchLocation = [touch locationInNode:_contentNode];

	// start catapult dragging when a touch inside of the catapult arm occurs
	if (CGRectContainsPoint([_catapultArm boundingBox], touchLocation)) {

		// move the mouseJointNode to the touch position
		_mouseJointNode.position = touchLocation;

		// setup a spring joint between the mouseJointNode and the catapultArm
		_mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0, 0) anchorB:ccp(34, 138) restLength:0.f stiffness:3000.f damping:50.f];

		// create a penguin from the ccb-file
		_currentPenguin = (Penguin*)[CCBReader load:@"Penguin"];
		// initially position it on the scoop. 34,138 is the position in the node space of the _catapultArm
		CGPoint penguinPosition = [_catapultArm convertToWorldSpace:ccp(34, 138)];
		// transform the world position to the node space to which the penguin will be added (_physicsNode)
		_currentPenguin.position = [_physicsNode convertToNodeSpace:penguinPosition];
		// add it to the physics world
		[_physicsNode addChild:_currentPenguin];
		// we don't want the penguin to rotate in the scoop
		_currentPenguin.physicsBody.allowsRotation = FALSE;

		// create a joint to keep the penguin fixed to the scoop until the catapult is released
		_penguinCatapultJoint = [CCPhysicsJoint connectedPivotJointWithBodyA:_currentPenguin.physicsBody bodyB:_catapultArm.physicsBody anchorA:_currentPenguin.anchorPointInPoints];
	}
}

- (void)touchMoved:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
	// whenever touches move, update the position of the mouseJointNode to the touch position
	CGPoint touchLocation = [touch locationInNode:_contentNode];
	_mouseJointNode.position = touchLocation;
}

- (void)touchEnded:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
	// when touches end, meaning the user releases their finger, release the catapult
	[self releaseCatapult];
}

- (void)touchCancelled:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
	// when touches are cancelled, meaning the user drags their finger off the screen or onto something else, release the catapult
	[self releaseCatapult];
}

//- (void)launchPenguin {
//	// loads the Penguin.ccb we have set up in Spritebuilder
//	CCNode* penguin = [CCBReader load:@"Penguin"];
//	// position the penguin at the bowl of the catapult
//	penguin.position = ccpAdd(_catapultArm.position, ccp(16, 50));
//
//	// add the penguin to the physicsNode of this scene (because it has physics enabled)
//	[_physicsNode addChild:penguin];
//
//	// manually create & apply a force to launch the penguin
//	CGPoint launchDirection = ccp(1, 0);
//	CGPoint force = ccpMult(launchDirection, 8000);
//	[penguin.physicsBody applyForce:force];
//
//	// ensure followed object is in visible are when starting
//	self.position = ccp(0, 0);
//	CCActionFollow *follow = [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
//	[_contentNode runAction:follow];
//}

- (void)releaseCatapult
{
	if (_mouseJoint != nil) {
		// releases the joint and lets the catapult snap back
		[_mouseJoint invalidate];
		_mouseJoint = nil;

		// releases the joint and lets the penguin fly
		[_penguinCatapultJoint invalidate];
		_penguinCatapultJoint = nil;

		// after snapping rotation is fine
		_currentPenguin.physicsBody.allowsRotation = TRUE;

		// follow the flying penguin
		_followPenguin = [CCActionFollow actionWithTarget:_currentPenguin worldBoundary:self.boundingBox];
		[_contentNode runAction:_followPenguin];

		_currentPenguin.launched = TRUE;
	}
}

- (void)retry
{
	// reload this level
	[[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"Gameplay"]];
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair*)pair seal:(CCNode*)nodeA wildcard:(CCNode*)nodeB
{

	float energy = [pair totalKineticEnergy];
	CCLOG(@"Something collided with a seal! Energy = %f", energy);

	// if energy is large enough, remove the seal
	if (energy > 50000.f) {
		//the block ensures that if seal collides more than once within a single frame, the following code only occur once per key per frame
		//In this case the key is nodeA, the seal
		[[_physicsNode space] addPostStepBlock:^{
			[self sealRemoved:nodeA];
		} key:nodeA];
	}
}

- (void)sealRemoved:(CCNode*)seal
{
	// load particle effect
	CCParticleSystem* explosion = (CCParticleSystem*)[CCBReader load:@"SealExplosion"];
	// make the particle effect clean itself up, once it is completed
	explosion.autoRemoveOnFinish = TRUE;
	// place the particle effect on the seals position
	explosion.position = seal.position;
	// add the particle effect to the same node the seal is on
	[seal.parent addChild:explosion];

	// finally, remove the destroyed seal
	[seal removeFromParent];
}

- (void)nextAttempt
{
	_currentPenguin = nil;
	[_contentNode stopAction:_followPenguin];

	CCActionMoveTo* actionMoveTo = [CCActionMoveTo actionWithDuration:1.f position:ccp(0, 0)];
	[_contentNode runAction:actionMoveTo];
}

@end
