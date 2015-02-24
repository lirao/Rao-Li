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

static const float MIN_SPEED = 5.f;

@implementation Gameplay {
    CCPhysicsNode* _physicsNode;

    CCSprite* _bkgd;
    CCSprite* _hpBarBkgd;
    Orb* _dragOrb;
    Orb* _realDragOrb;
    CGPoint _dragOffset;
    NSMutableArray* _allOrbs;
    NSMutableSet* _run, *_tempRun;
    BOOL _allowInput;
    int _howManyToProcess;
	Level* _level;
}

- (id)init
{
    if ((self = [super init])) {

        _run = [[NSMutableSet alloc] init];
        _tempRun = [[NSMutableSet alloc] init];
        _dragOrb = nil;

        _allowInput = YES;
    }

    return self;
}



- (void)findMatchesAboveOrb:(Orb*)orb index:(int)index
{
    int y = index / 6;
    if (y == 0)
        return;
    else {
        [_tempRun addObject:orb];
        int newIndex = index - 6;
        Orb* newGem = _gems[newIndex];
        if (newGem.color == gem.color) {
            [_tempRun addObject:newGem];
            //NSLog(@"match above, color = %d, newColor = %d, index = %d, newIndex = %d", gem.color, newGem.color, index, newIndex);
            [self findMatchesAboveGem:newGem index:newIndex];
        }
    }
}

- (void)findMatchesBelowGem:(Gem*)gem index:(int)index
{
    int y = index / 6;
    if (y == 4)
        return;
    else {
        [_tempRun addObject:gem];
        int newIndex = index + 6;
        Gem* newGem = _gems[newIndex];
        if (newGem.color == gem.color) {
            [_tempRun addObject:gem];
            //NSLog(@"match below, color = %d, newColor = %d, index = %d, newIndex = %d", gem.color, newGem.color, index, newIndex);
            [self findMatchesBelowGem:newGem index:newIndex];
        }
    }
}

- (void)findMatchesLeftGem:(Gem*)gem index:(int)index
{
    int x = index % 6;
    if (x == 0)
        return;
    else {
        [_tempRun addObject:gem];
        int newIndex = index - 1;
        Gem* newGem = _gems[newIndex];
        if (newGem.color == gem.color) {
            [_tempRun addObject:gem];
            //NSLog(@"match left, color = %d, newColor = %d, index = %d, newIndex = %d, x = %d, temp count = %d", gem.color, newGem.color, index, newIndex, x, _tempRun.count);
            [self findMatchesLeftGem:newGem index:newIndex];
        }
    }
}

- (void)findMatchesRightGem:(Gem*)gem index:(int)index
{
    int x = index % 6;
    if (x == 5)
        return;
    else {
        [_tempRun addObject:gem];
        int newIndex = index + 1;
        Gem* newGem = _gems[newIndex];
        if (newGem.color == gem.color) {
            [_tempRun addObject:gem];
            //NSLog(@"match left, color = %d, newColor = %d, index = %d, newIndex = %d", gem.color, newGem.color, index, newIndex);
            [self findMatchesRightGem:newGem index:newIndex];
        }
    }
}

- (void)addRun:(NSMutableSet*)newRun
{
    [_run addObjectsFromArray:newRun.allObjects];
}

- (void)findRunFromGem:(Gem*)gem index:(int)index
{
    [_tempRun removeAllObjects];
    [self findMatchesAboveGem:gem index:index];
    if (_tempRun.count > 2)
        [self addRun:_tempRun];
    [_tempRun removeAllObjects];
    [self findMatchesBelowGem:gem index:index];
    if (_tempRun.count > 2)
        [self addRun:_tempRun];
    [_tempRun removeAllObjects];
    [self findMatchesLeftGem:gem index:index];
    if (_tempRun.count > 2)
        [self addRun:_tempRun];
    [_tempRun removeAllObjects];
    [self findMatchesRightGem:gem index:index];
    if (_tempRun.count > 2)
        [self addRun:_tempRun];
}

- (void)clearAndFillBoard
{
    // slide down
    NSMutableSet* used = [NSMutableSet set];
    for (int column = 0; column < 6; column++) {
        for (int row = 0; row < 5; row++) {
            int thisIndex = (row * 6) + column;
            Gem* thisGem = _gems[thisIndex];
            //if (![_run containsObject:thisGem]) continue;
            //NSLog(@"testing this %d, %d, %d", thisIndex, row, column);
            for (int newRow = row; newRow < 5; newRow++) {
                int newIndex = (newRow * 6) + column;
                Gem* newGem = _gems[newIndex];
                if (![_run containsObject:newGem] && ![used containsObject:newGem]) {
                    //NSLog(@"replace %d with %d", thisIndex, newIndex);
                    [used addObject:newGem];
                    [_gems replaceObjectAtIndex:thisIndex withObject:newGem];
                    [_gems replaceObjectAtIndex:newIndex withObject:thisGem];
                    break;
                }
            }
        }
    }
    // fill spaces
    for (Gem* gem in _run) {
        int index = [_gems indexOfObject:gem];
        int x = index % 6;
        Gem* newGem = [self createRandomGem];
        newGem.sprite.position = CGPointMake(27.5 + (x * 53), 290.5);
        [self addChild:newGem.sprite];
        [_gems replaceObjectAtIndex:index withObject:newGem];
        [self removeChild:gem.sprite];
    }
    [self updateGemPositionsAfterSwap:0.5];
}

- (void)processBatches:(NSMutableArray*)batches
{
    if (batches.count == 0)
        return;
    NSMutableArray* batch = [batches lastObject];

    for (Gem* gem in batch) {
        CCFadeOut* fadeOut = [[CCFadeOut alloc] initWithDuration:0.25];
        CCCallBlock* completion = [[CCCallBlock alloc] initWithBlock:^{
			_howManyToProcess --;
			if (_howManyToProcess == 0)
			{
				[self clearAndFillBoard];
				float delayInSeconds = 0.75;
				dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
				dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
					[self turnEnd];
				});
			}
        }];
        CCSequence* sequence = [[CCSequence alloc] initOne:fadeOut two:completion];
        [gem.sprite runAction:sequence];
    }
    [batches removeObject:batch];
    float delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
		[self processBatches:batches];
    });
}

- (void)turnEnd
{
    _allowInput = NO;
    [_run removeAllObjects];
    for (int i = 29; i >= 0; i--) {
        [self findRunFromGem:_gems[i] index:i];
    }
    if (_run.count > 0) {
        _howManyToProcess = _run.count;

        NSMutableArray* batches = [NSMutableArray array];
        for (int i = 1; i < 7; i++) {
            NSMutableArray* batch = [NSMutableArray array];
            for (Gem* gem in _run) {
                if (gem.color == i) {
                    [batch addObject:gem];
                }
            }
            if (batch.count > 0)
                [batches addObject:batch];
        }

        //NSLog(@"batches %d", batches.count);
        [self processBatches:batches];
    }
    else {
        _allowInput = YES;
    }
}

#pragma mark touch handling

- (BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent*)event
{
    if (!_allowInput)
        return NO;

    CGPoint location = [self convertTouchToNodeSpace:touch];

    //NSLog(@"%@", _gems);

    for (Gem* container in _gems) {
        if (!_dragGem && CGRectContainsPoint(container.sprite.boundingBox, location)) {
            _dragGem = [[Gem alloc] init];
            _dragGem.color = container.color;
            _dragGem.sprite = [self createGemWithColor:container.color];
            [_dragGem.sprite setPosition:container.sprite.position];
            [self addChild:_dragGem.sprite];
            _realDragGem = container;
            container.sprite.opacity = 128;
            _dragOffset = CGPointMake(location.x - container.sprite.boundingBox.origin.x - 26.5, location.y - container.sprite.boundingBox.origin.y - 26.5);
            _dragGem.sprite.zOrder = 10;
            return YES;
        }
    }
    return NO;
}

- (void)updateGemPositionsAfterSwap:(float)duration
{
    float startY = 25.5;
    float startX = 27.5;

    for (int y = 0; y < 5; y++) {
        for (int x = 0; x < 6; x++) {
            int idx = x + (y * 6);
            Gem* container = _gems[idx];
            if (container.sprite.position.x != startX || container.sprite.position.y != startY) {
                CCMoveTo* moveTo = [[CCMoveTo alloc] initWithDuration:duration position:CGPointMake(startX, startY)];
                [container.sprite runAction:moveTo];
            }
            startX += 53;
        }
        startY += 53;
        startX = 27.5;
    }
}

- (void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent*)event
{
    if (!_allowInput)
        return;

    if (_dragGem) {
        CGPoint location = [self convertTouchToNodeSpace:touch];
        location.x -= _dragOffset.x;
        location.y -= _dragOffset.y;
        [_dragGem.sprite setPosition:location];
        Gem* swapGem = nil;
        for (Gem* container in _gems) {
            if (container != _realDragGem && container.sprite.numberOfRunningActions == 0 && CGRectContainsPoint(container.sprite.boundingBox, location)) {
                swapGem = container;
                break;
            }
        }
        if (swapGem) {
            int idxA = [_gems indexOfObject:swapGem];
            int idxB = [_gems indexOfObject:_realDragGem];
            [_gems replaceObjectAtIndex:idxA withObject:_realDragGem];
            [_gems replaceObjectAtIndex:idxB withObject:swapGem];
            [self updateGemPositionsAfterSwap:0.05];
        }
    }
}

- (void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent*)event
{
    [self removeChild:_dragGem.sprite];
    _realDragGem.sprite.opacity = 255.0;
    _realDragGem = nil;
    _dragGem = nil;
    _dragOffset = CGPointZero;
    [self turnEnd];
}

- (void)ccTouchCancelled:(UITouch*)touch withEvent:(UIEvent*)event
{
    [self ccTouchEnded:touch withEvent:event];
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

- (void)update:(CCTime)delta
{
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

    id bezierForward = [CCActionBezierTo];
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



@end
