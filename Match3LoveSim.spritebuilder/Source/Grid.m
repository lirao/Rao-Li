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

// these are variables that cannot be changed
static const int GRID_ROWS = 6;
static const int GRID_COLUMNS = 6;

@implementation Grid {
    NSMutableArray* _gridArray;
    float _cellWidth;
    float _cellHeight;
    Orb* _dragOrb;
    Orb* _realDragOrb;
    CGPoint _dragOffset;
    NSMutableArray* _allOrbs;
    NSMutableSet* _clearBlk, *_clearStrip;

    int _howManyToProcess;
    Level* _level;
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

    // accept touches on the grid
    self.userInteractionEnabled = YES;

    //init values
    self.affection = 0;
    self.life = 1000;
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
            [self addChild:orb];

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
}
//- (Orb*)orbForTouchPosition:(CGPoint)touchPosition
//{
//    //get the row and column that was touched, return the Creature inside the corresponding cell
//    int row = touchPosition.y / _cellHeight;
//    int column = touchPosition.x / _cellWidth;
//    return _gridArray[[self resolveIndexOfX:row AndY:column]];
//}

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
            NSLog(@"match above, color = %d, newColor = %d, index = %d", (int)orb.orbColor, (int)newOrb.orbColor, index);
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
            NSLog(@"match above, color = %d, newColor = %d, index = %d", (int)orb.orbColor, (int)newOrb.orbColor, index);
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
            NSLog(@"match above, color = %d, newColor = %d, index = %d", (int)orb.orbColor, (int)newOrb.orbColor, index);
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
            NSLog(@"match above, color = %d, newColor = %d, index = %d", (int)orb.orbColor, (int)newOrb.orbColor, index);
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
        newOrb.position = ccp(x * _cellWidth, (GRID_ROWS+y) * _cellHeight);
        [self addChild:newOrb];
        [_gridArray replaceObjectAtIndex:index withObject:newOrb];
        [self removeChild:orb];
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
    _affection += batch.count;

    for (Orb* orb in batch) {
        CCActionFadeOut* fadeOut = [[CCActionFadeOut alloc] initWithDuration:0.25];
        CCActionCallBlock* completion = [[CCActionCallBlock alloc] initWithBlock:^{
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
        CCActionSequence* sequence = [[CCActionSequence alloc] initOne:fadeOut two:completion];
        [orb runAction:sequence];
    }
    [batches removeObject:batch];
    float delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
		[self processBatches:batches];
    });
}


- (void)touchBegan:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
	if (self.userInteractionEnabled)

	{
		//get the x,y coordinates of the touch
		CGPoint touchLocation = [touch locationInNode:self];

		//get the Orb at that location

		for (Orb* currOrb in _gridArray) {
			//Find the orb that's being tapped
			if (!_dragOrb && CGRectContainsPoint(currOrb.boundingBox, touchLocation)) {
				//Clone the starting orb to create a ghost orb dragged
				_dragOrb = [[Orb alloc] initWithColor:currOrb.orbColor];
				[_dragOrb setPosition:currOrb.position];
				currOrb.opacity = 64;
				//Calculate the position of the mouse pointer to the
				_dragOffset = CGPointMake(touchLocation.x - currOrb.boundingBox.origin.x, touchLocation.y - currOrb.boundingBox.origin.y);

				[self addChild:_dragOrb];
				_realDragOrb = currOrb;
				_dragOrb.zOrder = 10;
				return;
			}
		}
	}
}



- (void)touchEnded:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
    // when touches end, meaning the user releases their finger, release the temp Orb object
    [self removeChild:_dragOrb];
    _realDragOrb.opacity = 255;

    //Clear the pointers
    _realDragOrb = nil;
    _dragOrb = nil;
    _dragOffset = CGPointZero;
    [self turnEnd];
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
        self.userInteractionEnabled = YES;
    }
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
        Orb* swapOrb = nil;
        for (Orb* boardOrb in _gridArray) {
			if (boardOrb != _realDragOrb && boardOrb.numberOfRunningActions == 0 && CGRectContainsPoint(boardOrb.boundingBox, location)) {

//            if (boardOrb != _realDragOrb && boardOrb.numberOfRunningActions == 0 && [_dragOrb isOverlap:boardOrb]) {
                swapOrb = boardOrb;
                break;
            }
        }
        if (swapOrb) {
            int idxA = (int)[_gridArray indexOfObject:swapOrb];
            int idxB = (int)[_gridArray indexOfObject:_realDragOrb];
            [_gridArray replaceObjectAtIndex:idxA withObject:_realDragOrb];
            [_gridArray replaceObjectAtIndex:idxB withObject:swapOrb];
            [self updateOrbPositionsAfterSwap:0.05];
        }
        //Minus 1 life for every drag event fired
        _life--;
    }
}

- (void)touchCancelled:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
    [self touchEnded:touch withEvent:event];
}

@end
