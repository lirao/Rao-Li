//
//  Orb.m
//  Match3LoveSim
//
//  Created by Rao Li on 2/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Orb.h"
#import "Grid.h"

//Stores the _cellHeight and cellWidth
static int MAX_X=64;
static int MAX_Y=64;

@implementation Orb {
}

//Init with random color
- (instancetype)initOrb
{
    MyValue rand = arc4random() % 6;
    printf("Random number: %d", (int)rand);
    return [self initWithColor:rand];
}

- (instancetype)initWithColor:(MyValue)color
{
    NSString* spritePath;
    switch (color) {
    case RED:
        spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_002.png";
        break;
    case ORANGE:
        spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_003.png";
        break;
    case YELLOW:
        spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_004.png";
        break;
    case GREEN:
        spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_005.png";
        break;
    case BLUE:
        spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_006.png";
        break;
    case PURPLE:
        spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_007.png";
        break;
    default:
        spritePath = @"Assets/object_billiard_balls/Billiard_Balls_01_Black_256x256.png";
        break;
    }

    self = [super initWithImageNamed:spritePath];

    if (self) {
        self.orbColor = color;
        self.zOrder = 9;
		self.anchorPoint = ccp(0, 0);

		self.scaleX = MAX_X / self.contentSize.width;
		self.scaleY = MAX_Y / self.contentSize.height;

    }

    return self;
}

+ (void) setHeight:(int)value { MAX_Y = value; }

+ (void) setWidth:(int)value { MAX_X = value; }



@end
