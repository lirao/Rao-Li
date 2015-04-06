//
//  Orb.m
//  Match3LoveSim
//
//  Created by Rao Li on 2/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Orb.h"
#import "Grid.h"
#define SPRITE_CACHE ([CCSpriteFrameCache sharedSpriteFrameCache])

//Stores the _cellHeight and cellWidth
static int MAX_X=64;
static int MAX_Y=64;
static NSString* SPRITE = @"Assets/object_coloful-mushrooms/%@";

@implementation Orb {
}

//Init with random color
- (instancetype)initOrb
{
    MyValue rand = arc4random() % 6;
    printf("Random number: %d", (int)rand);
    return [self initWithColor:rand];
}

- (void)setColor:(MyValue)color
{
	NSString* spritePath;
//	switch (color) {
//		case RED:
//			spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_002.png";
//			break;
//		case ORANGE:
//			spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_003.png";
//			break;
//		case YELLOW:
//			spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_004.png";
//			break;
//		case GREEN:
//			spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_005.png";
//			break;
//		case BLUE:
//			spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_006.png";
//			break;
//		case PURPLE:
//			spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_007.png";
//			break;
//		default:
//			spritePath = @"Assets/object_billiard_balls/Billiard_Balls_01_Black_256x256.png";
//			break;
//	}

	switch (color) {
		case RED:
			spritePath = [NSString stringWithFormat:SPRITE, @"Mushrooms_01_256x256_Alt_00_002.png"];
			break;
		case ORANGE:
			spritePath = [NSString stringWithFormat:SPRITE, @"Mushrooms_01_256x256_Alt_00_003.png"];
			break;
		case YELLOW:
			spritePath = [NSString stringWithFormat:SPRITE, @"Mushrooms_01_256x256_Alt_00_004.png"];
			break;
		case GREEN:
			spritePath = [NSString stringWithFormat:SPRITE, @"Mushrooms_01_256x256_Alt_00_005.png"];
			break;
		case BLUE:
			spritePath = [NSString stringWithFormat:SPRITE, @"Mushrooms_01_256x256_Alt_00_006.png"];
			break;
		case PURPLE:
			spritePath = [NSString stringWithFormat:SPRITE, @"Mushrooms_01_256x256_Alt_00_007.png"];
			break;
		default:
			spritePath = [NSString stringWithFormat:SPRITE, @"Mushrooms_01_256x256_Alt_00_001.png"];
			break;
	}


	// 5) To change image :
	[self setSpriteFrame:[SPRITE_CACHE spriteFrameByName:spritePath]];

	self.orbColor = color;
}

- (instancetype)initWithColor:(MyValue)color
{

	self = [super init];

	if (self) {
		[self setColor:color];
        self.zOrder = 9;
		self.anchorPoint = ccp(0, 0);

		self.scaleX = MAX_X / self.contentSize.width;
		self.scaleY = MAX_Y / self.contentSize.height;

    }

    return self;
}

+ (void) setHeight:(int)value { MAX_Y = value; }

+ (void) setWidth:(int)value { MAX_X = value; }

- (BOOL)isOverlap:(Orb*)anotherOrb
{
//	//Check if they are actually intersecting with standard function
//	if (CGRectIntersectsRect([self.boundingBox.origin],[anotherOrb.boundingbox]) {
//		return YES;
//	}
//		else
//		return NO;
}

@end
