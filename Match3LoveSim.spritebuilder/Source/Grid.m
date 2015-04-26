//
//  Grid.m
//  Match3LoveSim
//
//  Created by Rao Li on 2/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Orb.h"
#import "Level.h"
#import "ScorePopup.h"

// these are variables that cannot be changed
static const int GRID_ROWS = 6;
static const int GRID_COLUMNS = 6;

@implementation Grid {
    CCPhysicsNode* _physicsNode;
    CCNode* _popupNode;
    NSMutableArray* _gridArray;
    float _cellWidth;
    float _cellHeight;
    Orb* _dragOrb;
    Orb* _realDragOrb;
    CGPoint _dragOffset;
    NSMutableSet* _clearBlk, *_clearStrip;
    NSMutableArray* _scoreStack;

    int _howManyToProcess;
    Level* _level;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
    // accept touches on the grid
    self.userInteractionEnabled = YES;
    //	//Load level 1
    //	CCScene* level = [CCBReader loadAsScene:@"Levels/Level1"];
    //	[_levelNode addChild:level];

    // visualize physics bodies & joints
    //	_physicsNode.debugDraw = TRUE;
    //become own physics delegate
    _physicsNode.collisionDelegate = self;
}
- (void)onEnter
{
    [super onEnter];

    [self setupGrid];

    //holds all Orbs to be cleared in a single continous block
    _clearBlk = [[NSMutableSet alloc] init];
    //holds a single strip of >3 orbs, used to build _clearBlk
    _clearStrip = [[NSMutableSet alloc] init];
    //pointer to the player-dragged orb
    _dragOrb = nil;

    //init values
    _gamePlay.affection = 0;
    _gamePlay.life = 1000;
    _gamePlay.multiplier = 0;
    [self turnEnd];

}

- (void)setupGrid
{
    // divide the grid's size by the number of columns/rows to figure out the
    // right width and height of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;

    float x = 0;
    float y = 0;

    // initialize the array as a blank NSMutableArray
    _gridArray = [[NSMutableArray alloc] init];

    // initialize Orbs. Use a 1D array instead of 2D to easily swap orbs across the board
    for (int i = 0; i < GRID_ROWS; i++) {
        x = 0;
        for (int j = 0; j < GRID_COLUMNS; j++) {
            Orb* orb = [[Orb alloc] initOrb];
            orb.position = ccp(x, y);
            [_physicsNode addChild:orb];

            // this is shorthand to access an array inside an array
            int index = i * GRID_COLUMNS + j;
            _gridArray[index] = orb;

            // make creatures visible to test this method, remove this once we know we
            // have filled the grid properly
            // creature.isAlive = YES;

            x += _cellWidth;
        }
        y += _cellHeight;
    }

    //Init the stack of score popups
    _scoreStack = [[NSMutableArray alloc] init];
}

/**
	Settling up phase after each round
 */

- (void)findMatchesAboveOrb:(Orb*)orb index:(int)index
{
    int y = index / GRID_COLUMNS;
    if (y == 0)
        return;
    else {
        [_clearStrip addObject:orb];
        int newIndex = index - GRID_COLUMNS; // y+1
        Orb* newOrb = _gridArray[newIndex];
        if (newOrb.orbColor == orb.orbColor) {
            [_clearStrip addObject:newOrb];
            //            NSLog(@"match above, color = %d, newColor = %d, index = %d", (int)orb.orbColor, (int)newOrb.orbColor, index);
            [self findMatchesAboveOrb:newOrb index:newIndex];
        }
    }
}

- (void)findMatchesBelowOrb:(Orb*)orb index:(int)index
{
    int y = index / GRID_COLUMNS;
    if (y == GRID_ROWS - 1)
        return;
    else {
        [_clearStrip addObject:orb];
        int newIndex = index + GRID_COLUMNS; //y-1
        Orb* newOrb = _gridArray[newIndex];
        if (newOrb.orbColor == orb.orbColor) {
            [_clearStrip addObject:orb];
            //            NSLog(@"match below, color = %d, newColor = %d, index = %d", (int)orb.orbColor, (int)newOrb.orbColor, index);
            [self findMatchesBelowOrb:newOrb index:newIndex];
        }
    }
}

- (void)findMatchesLeftOrb:(Orb*)orb index:(int)index
{
    int x = index % GRID_COLUMNS;
    if (x == 0)
        return;
    else {
        [_clearStrip addObject:orb];
        int newIndex = index - 1; //x-1
        Orb* newOrb = _gridArray[newIndex];
        if (newOrb.orbColor == orb.orbColor) {
            [_clearStrip addObject:orb];
            //            NSLog(@"match left, color = %d, newColor = %d, index = %d", (int)orb.orbColor, (int)newOrb.orbColor, index);
            [self findMatchesLeftOrb:newOrb index:newIndex];
        }
    }
}

- (void)findMatchesRightOrb:(Orb*)orb index:(int)index
{
    int x = index % GRID_COLUMNS;
    if (x == GRID_COLUMNS - 1)
        return;
    else {
        [_clearStrip addObject:orb];
        int newIndex = index + 1; //x+1
        Orb* newOrb = _gridArray[newIndex];
        if (newOrb.orbColor == orb.orbColor) {
            [_clearStrip addObject:orb];
            //            NSLog(@"match right, color = %d, newColor = %d, index = %d", (int)orb.orbColor, (int)newOrb.orbColor, index);
            [self findMatchesRightOrb:newOrb index:newIndex];
        }
    }
}

- (void)addRun:(NSMutableSet*)newRun
{
    [_clearBlk addObjectsFromArray:newRun.allObjects];
}

- (void)findRunFromOrb:(Orb*)orb index:(int)index
{
    [_clearStrip removeAllObjects];
    [self findMatchesAboveOrb:orb index:index];
    if (_clearStrip.count > 2)
        [self addRun:_clearStrip];
    [_clearStrip removeAllObjects];
    [self findMatchesBelowOrb:orb index:index];
    if (_clearStrip.count > 2)
        [self addRun:_clearStrip];
    [_clearStrip removeAllObjects];
    [self findMatchesLeftOrb:orb index:index];
    if (_clearStrip.count > 2)
        [self addRun:_clearStrip];
    [_clearStrip removeAllObjects];
    [self findMatchesRightOrb:orb index:index];
    if (_clearStrip.count > 2)
        [self addRun:_clearStrip];
}

- (void)clearAndFillBoard
{
    // slide down
    NSMutableSet* used = [NSMutableSet set];
    for (int i = 0; i < GRID_COLUMNS; i++) {
        for (int j = 0; j < GRID_ROWS; j++) {
            int index = j * GRID_COLUMNS + i;
            Orb* thisOrb = _gridArray[index];

            //NSLog(@"testing this %d, %d, %d", thisIndex, row, column);
            for (int newRow = j; newRow < GRID_ROWS; newRow++) {
                int newIndex = newRow * GRID_COLUMNS + i;
                Orb* newOrb = _gridArray[newIndex];
                if (![_clearBlk containsObject:newOrb] && ![used containsObject:newOrb]) {
                    //NSLog(@"replace %d with %d", thisIndex, newIndex);
                    [used addObject:newOrb];
                    [_gridArray replaceObjectAtIndex:index withObject:newOrb];
                    [_gridArray replaceObjectAtIndex:newIndex withObject:thisOrb];
                    break;
                }
            }
        }
    }
    //
    for (Orb* orb in _clearBlk) {
        int index = (int)[_gridArray indexOfObject:orb];
        int x = index % GRID_COLUMNS;
        int y = index / GRID_COLUMNS;
        Orb* newOrb = [[Orb alloc] initOrb];
        newOrb.position = ccp(x * _cellWidth, (GRID_ROWS + y) * _cellHeight);
        [_physicsNode addChild:newOrb];
        [_gridArray replaceObjectAtIndex:index withObject:newOrb];
        [_physicsNode removeChild:orb];
    }
    [self updateOrbPositionsAfterSwap:0.5];
}

- (void)updateOrbPositionsAfterSwap:(float)duration
{
    float x = 0;
    float y = 0;

    // fix orbs order
    for (int i = 0; i < GRID_ROWS; i++) {
        x = 0;
        for (int j = 0; j < GRID_COLUMNS; j++) {
            int index = i * GRID_COLUMNS + j;
            Orb* container = _gridArray[index];
            if (container.position.x != x || container.position.y != y) {
                CCActionMoveTo* moveTo =
                    [[CCActionMoveTo alloc] initWithDuration:duration position:ccp(x, y)];
                [container runAction:moveTo];
            }
            x += _cellWidth;
        }
        y += _cellHeight;
    }
}

- (void)processBatches:(NSMutableArray*)batches
{
    if (batches.count == 0)
        return;

    NSMutableArray* batch = [batches lastObject];
    [self updateScore:batch];
    for (Orb* orb in batch) {

        CCActionFadeOut* fadeOut = [CCActionFadeOut actionWithDuration:1];
        CCActionCallBlock* completion = [[CCActionCallBlock alloc] initWithBlock:^{
			_howManyToProcess --;
			if (_howManyToProcess == 0)
			{
				[self clearAndFillBoard];
				float delayInSeconds = 1;
				dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
				dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
				[self turnEnd];
				});
			}
        }];
        CCActionSequence* sequence = [[CCActionSequence alloc] initOne:fadeOut two:completion];
        [orb runAction:sequence];
    }
    [batches removeObject:batch];
    float delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
		[self processBatches:batches];
    });
}

//Create a score label and put it in the stack
- (void)updateScore:(NSMutableArray*)orbs
{
    ScorePopup* popup = (ScorePopup*)[CCBReader load:@"ScorePopup"];
    [_scoreStack addObject:popup];

    //save scoring info
    Orb* sampleOrb = (Orb*)orbs[0];
    popup.orbColor = sampleOrb.orbColor;
    [popup setScore:orbs.count];
    [popup setMultiplier:(int)_scoreStack.count];

    popup.position = ccp(sampleOrb.position.x + _cellWidth / 2, sampleOrb.position.y + _cellHeight / 2);
    popup.opacity = 0;
    [_popupNode addChild:popup];

	//Change expression
	[_gamePlay updateExpression:sampleOrb.orbColor];
}

- (void)calculateScore
{
    int totalMultiplier = (int)_scoreStack.count;

    //settle up scores
    for (ScorePopup* popup in _scoreStack) {
        //Fade out first
        CCActionFadeTo* halfFadeOut = [CCActionFadeTo actionWithDuration:0.5 opacity:0.5];
        CCActionFadeTo* fadeIn = [CCActionFadeTo actionWithDuration:0.5 opacity:1];
        CCActionSequence* changeFade = [CCActionSequence actionWithArray:@[ halfFadeOut, fadeIn ]];
        CCActionRepeat* repeatAction = [CCActionRepeat actionWithAction:changeFade times:3];
        CCActionDelay* delayLong = [CCActionDelay actionWithDuration:1];
        CCActionFadeOut* fadeOut = [CCActionFadeOut actionWithDuration:1];
        CCActionSequence* blink = [CCActionSequence actionWithArray:@[ changeFade, fadeOut ]];
        [popup runAction:blink];

        [popup setMultiplier:totalMultiplier];
        long score = (1 + totalMultiplier / 10) * popup.score;
        long scoreDown = (1 - totalMultiplier / 10) * popup.score;
        switch (popup.orbColor) {
        case HEAL:
            _gamePlay.life += score;
            [popup setScore:score];
            break;
        case PTUP:
            _gamePlay.affection += score;
            [popup setScore:score];
            break;
        case PTUPSP:
            _gamePlay.affection += score * 2;
            [popup setScore:score * 2];
            break;
        case PTDOWN:
            _gamePlay.affection -= scoreDown;
            [popup setScore:scoreDown];
            break;
        case PTDOWNSP:
            _gamePlay.affection -= scoreDown * 2;
            [popup setScore:scoreDown * 2];
            break;
        default:
            break;
        }
    }

    //    for (ScorePopup* popup in _scoreStack) {
    //        CCActionFadeOut* fadeOut = [CCActionFadeOut actionWithDuration:1];
    //        CCActionDelay* delay = [CCActionDelay actionWithDuration:0.5];
    //        CCActionSequence* outFade = [CCActionSequence actionWithArray:@[ delay, fadeOut ]];
    //        [popup runAction:outFade];
    //    }
    //
    //    _gamePlay.multiplier++;
}

- (void)touchBegan:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
    if (self.userInteractionEnabled) {
        //get the x,y coordinates of the touch
        CGPoint touchLocation = [touch locationInNode:_physicsNode];

        //get the Orb at that location

        for (Orb* currOrb in _gridArray) {
            //Find the orb that's being tapped
            if (!_dragOrb && CGRectContainsPoint([currOrb boundingBox], touchLocation)) {
                //Clone the starting orb to create a ghost orb dragged
                _dragOrb = [[Orb alloc] initWithColor:currOrb.orbColor];
                [_dragOrb setPosition:currOrb.position];
                _dragOrb.opacity = 0.6;
                //Calculate the position of the mouse pointer to the
                _dragOffset = CGPointMake(touchLocation.x - currOrb.boundingBox.origin.x, touchLocation.y - currOrb.boundingBox.origin.y);

                _dragOrb.physicsBody.collisionType = @"dragOrb";

                [_physicsNode addChild:_dragOrb];
                _realDragOrb = currOrb;
                return;
            }
        }
    }
}

- (void)touchEnded:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
    [_popupNode removeAllChildren];
    [_scoreStack removeAllObjects];

    // when touches end, meaning the user releases their finger, release the temp Orb object
    [_physicsNode removeChild:_dragOrb];
    _realDragOrb.opacity = 1;

    //Clear the pointers
    _realDragOrb = nil;
    _dragOrb = nil;
    _dragOffset = CGPointZero;
    [self turnEnd];

	if (_gamePlay.life == 0)
	{
		[_gamePlay endDay];
	}
}

//Settle up
- (void)turnEnd
{
    self.userInteractionEnabled = NO;

    [_clearBlk removeAllObjects];
    for (int i = 0; i < GRID_COLUMNS * GRID_ROWS; i++) {
        [self findRunFromOrb:_gridArray[i] index:i];
    }
    if (_clearBlk.count > 0) {
        _howManyToProcess = (int)_clearBlk.count;

        NSMutableArray* batches = [NSMutableArray array];
        for (int i = 0; i < color_count; i++) {
            NSMutableArray* batch = [NSMutableArray array];
            for (Orb* orb in _clearBlk) {
                if (orb.orbColor == i) {
                    [batch addObject:orb];
                }
            }
            if (batch.count > 0)
                [batches addObject:batch];
        }

        //NSLog(@"batches %d", batches.count);
        [self processBatches:batches];
    }
    else {
        [_popupNode runAction:[CCActionDelay actionWithDuration:2.0]];
        [self calculateScore];
        self.userInteractionEnabled = YES;
    }
}

- (void)touchCancelled:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
    [self touchEnded:touch withEvent:event];
}

- (void)touchMoved:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
    if (!self.userInteractionEnabled)
        return;

    if (_dragOrb) {
        CGPoint location = [touch locationInNode:self];
        location.x -= _dragOffset.x;
        location.y -= _dragOffset.y;
        [_dragOrb setPosition:location];
        //Minus 1 life for every drag event fired
        _gamePlay.life--;
    }
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair*)pair dragOrb:(Orb*)dragOrb orb:(Orb*)orb
{
    NSLog(@"%@", dragOrb.physicsBody.collisionType);
    NSLog(@"%@", orb.physicsBody.collisionType);
    if (_dragOrb) {
        //Find the orb that it swapped with
        Orb* swapOrb = orb;
        [_realDragOrb setColor:swapOrb.orbColor];
        [swapOrb setColor:_dragOrb.orbColor];
        _realDragOrb = swapOrb;
    }

    return NO;
}

@end
