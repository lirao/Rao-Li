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

	// initialize Orbs
    for (int i = 0; i < GRID_ROWS; i++) {
        // this is how you create two dimensional arrays in Objective-C. You put
        // arrays into arrays.
        _gridArray[i] = [NSMutableArray array];
        x = 0;

        for (int j = 0; j < GRID_COLUMNS; j++) {
            Orb* creature = [[Orb alloc] initOrb];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];

            // this is shorthand to access an array inside an array
            _gridArray[i][j] = creature;

            // make creatures visible to test this method, remove this once we know we
            // have filled the grid properly
            // creature.isAlive = YES;

            x += _cellWidth;
        }
        y += _cellHeight;
    }
}

- (void)touchBegan:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
    //get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];

    //get the Creature at that location
    Orb* orb = [self orbForTouchPosition:touchLocation];
}

- (Orb*)orbForTouchPosition:(CGPoint)touchPosition
{
    //get the row and column that was touched, return the Creature inside the corresponding cell
    int row = touchPosition.y / _cellHeight;
    int column = touchPosition.x / _cellWidth;
    return _gridArray[row][column];
}


/**
	Settling up phase after each round
	These 4 methods find a continous stretch of same color orbs
 */

- (void)findMatchesAboveOrb:(Orb*)orb x:(int)x y:(int)y
{
	if (y == 0)
		return;
	else {
		[_clearStrip addObject:orb];
		Orb* nextOrb = _gridArray[x][y-1];
		if (nextOrb.orbColor == orb.orbColor) {
			[_clearStrip addObject:nextOrb];
			NSLog(@"match above, color = %d, newColor = %d, x = %d, y = %d", (int)orb.orbColor, (int)nextOrb.orbColor, x, y);
			[self findMatchesAboveOrb:nextOrb x:x y:y-1];
		}
	}
}

- (void)findMatchesBelowOrb:(Orb*)orb x:(int)x y:(int)y
{
	if (y == 5)
		return;
	else {
		[_clearStrip addObject:orb];
		Orb* nextOrb = _gridArray[x][y-1];
		if (nextOrb.orbColor == orb.orbColor) {
			[_clearStrip addObject:nextOrb];
			NSLog(@"match below, color = %d, newColor = %d, x = %d, y = %d", (int)orb.orbColor, (int)nextOrb.orbColor, x, y);
			[self findMatchesBelowOrb:nextOrb x:x y:y-1];
		}
	}
}

- (void)findMatchesLeftOrb:(Orb*)orb x:(int)x y:(int)y
{
	if (x == 0)
		return;
	else {
		[_clearStrip addObject:orb];
		Orb* nextOrb = _gridArray[x-1][y];
		if (nextOrb.orbColor == orb.orbColor) {
			[_clearStrip addObject:nextOrb];
			NSLog(@"match left, color = %d, newColor = %d, x = %d, y = %d", (int)orb.orbColor, (int)nextOrb.orbColor, x, y);
			[self findMatchesLeftOrb:nextOrb x:x-1 y:y];
		}
	}
}

- (void)findMatchesRightOrb:(Orb*)orb x:(int)x y:(int)y
{
	if (x == 6)
		return;
	else {
		[_clearStrip addObject:orb];
		Orb* nextOrb = _gridArray[x+1][y];
		if (nextOrb.orbColor == orb.orbColor) {
			[_clearStrip addObject:nextOrb];
			NSLog(@"match right, color = %d, newColor = %d, x = %d, y = %d", (int)orb.orbColor, (int)nextOrb.orbColor, x, y);
			[self findMatchesRightOrb:nextOrb x:x+1 y:y];
		}
	}
}

- (void)addRun:(NSMutableSet*)newRun
{
	[_clearBlk addObjectsFromArray:newRun.allObjects];
}

- (void)findBlockFromOrb:(Orb*)orb x:(int)x y:(int)y
{
	[_clearStrip removeAllObjects];
	[self findMatchesAboveOrb:orb x:x y:y];
	if (_clearStrip.count > 2)
		[self addRun:_clearStrip];

	[_clearStrip removeAllObjects];
	[self findMatchesBelowOrb:orb x:x y:y];
	if (_clearStrip.count > 2)
		[self addRun:_clearStrip];

	[_clearStrip removeAllObjects];
	[self findMatchesLeftOrb:orb x:x y:y];
	if (_clearStrip.count > 2)
		[self addRun:_clearStrip];

	[_clearStrip removeAllObjects];
	[self findMatchesRightOrb:orb x:x y:y];
	if (_clearStrip.count > 2)
		[self addRun:_clearStrip];
}

- (void)clearAndFillBoard
{
	// slide down
	NSMutableSet* used = [NSMutableSet set];
	for (int column = 0; column < 6; column++) {
		for (int row = 0; row < 5; row++) {
			int thisIndex = (row * 6) + column;
			Orb* thisOrb = _gridArray[thisIndex];
			//if (![_run containsObject:thisOrb]) continue;
			//NSLog(@"testing this %d, %d, %d", thisIndex, row, column);
			for (int newRow = row; newRow < 5; newRow++) {
				int newIndex = (newRow * 6) + column;
				Orb* newOrb = _gridArray[newIndex];
				if (![_clearBlk containsObject:newOrb] && ![used containsObject:newOrb]) {
					//NSLog(@"replace %d with %d", thisIndex, newIndex);
					[used addObject:newOrb];
					[_gridArray replaceObjectAtIndex:thisIndex withObject:newOrb];
					[_gridArray replaceObjectAtIndex:newIndex withObject:thisOrb];
					break;
				}
			}
		}
	}
	// fill spaces
	for (Orb* orb in _clearBlk) {
		int index = [_gridArray indexOfObject:orb];
		int x = index % 6;
		Orb* newOrb = [[Orb alloc] initOrb];
		newOrb.sprite.position = CGPointMake(27.5 + (x * 53), 290.5);
		[self addChild:newOrb.sprite];
		[_gridArray replaceObjectAtIndex:index withObject:newOrb];
		[self removeChild:orb.sprite];
	}
	[self updateOrbPositionsAfterSwap:0.5];
}

- (void)processBatches:(NSMutableArray*)batches
{
	if (batches.count == 0)
		return;
	NSMutableArray* batch = [batches lastObject];

	for (Orb* orb in batch) {
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
		[orb.sprite runAction:sequence];
	}
	[batches removeObject:batch];
	float delayInSeconds = 0.5;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
		[self processBatches:batches];
	});
}

- (void)touchEnded:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
	// when touches end, meaning the user releases their finger, release the temp Orb object
	[self removeChild:_dragOrb.sprite];
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
	for (int i = 29; i >= 0; i--) {
		[self findRunFromOrb:_gridArray[i] index:i];
	}
	if (_clearBlk.count > 0) {
		_howManyToProcess = _clearBlk.count;

		NSMutableArray* batches = [NSMutableArray array];
		for (int i = 1; i < 7; i++) {
			NSMutableArray* batch = [NSMutableArray array];
			for (Orb* orb in _clearBlk) {
				if (orb.color == i) {
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


@end
