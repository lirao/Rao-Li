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
            orb.anchorPoint = ccp(0, 0);
            orb.position = ccp(x, y);
            [self addChild:orb];

            // this is shorthand to access an array inside an array
            int index = [self resolveIndexOfX:j AndY:i];
            _gridArray[index] = orb;

            // make creatures visible to test this method, remove this once we know we
            // have filled the grid properly
            // creature.isAlive = YES;

            x += _cellWidth;
        }
        y += _cellHeight;
    }
}

- (int)resolveIndexOfX:(int)x AndY:(int)y
{
	// x is horizontal axis (column
	// y is vertical axis (row

    return (x * GRID_COLUMNS + y);
}

- (void)touchBegan:(CCTouch*)touch withEvent:(CCTouchEvent*)event
{
	if (self.userInteractionEnabled)

	{
    //get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];

    //get the Creature at that location
   // Orb* orb = [self orbForTouchPosition:touchLocation];

	//NSLog(@"%@", _gems);

	for (Orb * container in _gridArray)
	{
		if (!_dragOrb && CGRectContainsPoint(container.boundingBox, touchLocation))
		{
			//Clone the starting orb to create a ghost orb dragged
			_dragOrb = [[Orb alloc] initWithColor:container.orbColor];
			_dragOrb.color = container.color;
			[_dragOrb setPosition:container.position];

			[self addChild:_dragOrb];
			_realDragOrb = container;
			container.opacity = 128;
			_dragOffset = CGPointMake(touchLocation.x-container.boundingBox.origin.x-26.5, touchLocation.y-container.boundingBox.origin.y-26.5);
			_dragOrb.zOrder = 10;
			return ;
		}
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
        if (newOrb.color == orb.color) {
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
        if (newOrb.color == orb.color) {
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
        if (newOrb.color == orb.color) {
            [_clearStrip addObject:orb];
            NSLog(@"match above, color = %d, newColor = %d, index = %d", (int)orb.orbColor, (int)newOrb.orbColor, index);
            [self findMatchesLeftOrb:newOrb index:newIndex];
        }
    }
}

- (void)findMatchesRightOrb:(Orb*)orb index:(int)index
{
    int x = index % GRID_COLUMNS;
    if (x == GRID_COLUMNS)
        return;
    else {
        [_clearStrip addObject:orb];
        int newIndex = index + 1; //x+1
        Orb* newOrb = _gridArray[newIndex];
        if (newOrb.color == orb.color) {
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
    for (int column = 0; column < GRID_COLUMNS; column++) {
        for (int row = 0; row < GRID_ROWS; row++) {
            int thisIndex = (row * GRID_COLUMNS) + column;
            Orb* thisOrb = _gridArray[thisIndex];

            //NSLog(@"testing this %d, %d, %d", thisIndex, row, column);
            for (int newRow = row; newRow < GRID_ROWS; newRow++) {
                int newIndex = [self resolveIndexOfX:column AndY:newRow];
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
        int index = (int)[_gridArray indexOfObject:orb];
        int x = index % GRID_COLUMNS;
        Orb* newOrb = [[Orb alloc] initOrb];
        newOrb.position = CGPointMake(27.5 + (x * 53), 290.5);
        [self addChild:newOrb];
        [_gridArray replaceObjectAtIndex:index withObject:newOrb];
        [self removeChild:orb];
    }
    [self updateOrbPositionsAfterSwap:0.5];
}

- (void)updateOrbPositionsAfterSwap:(float)duration
{
	float startY = 0;
	float startX = 0;

    for (int y = 0; y < GRID_ROWS; y++) {
		startX = 0;
        for (int x = 0; x < GRID_COLUMNS; x++) {
            int idx = x + (y * GRID_COLUMNS);
            Orb* container = _gridArray[idx];
            if (container.position.x != startX || container.position.y != startY) {
                CCActionMoveTo* moveTo = [[CCActionMoveTo alloc] initWithDuration:duration position:ccp(startX, startY)];
                [container runAction:moveTo];
            }
            startX += _cellWidth;
        }
        startY += _cellHeight;
    }
}

- (void)processBatches:(NSMutableArray*)batches
{
    if (batches.count == 0)
        return;
    NSMutableArray* batch = [batches lastObject];

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
    for (int i = 29; i >= 0; i--) {
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

@end
