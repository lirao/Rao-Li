//
//  Orb.m
//  Match3LoveSim
//
//  Created by Rao Li on 2/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Orb.h"

static int MAX_COLOR = 6;

@implementation Orb {
}

//Init with random color
- (instancetype)initOrb
{
	MyValue rand = arc4random() % 6;
	printf("Random number: %d", (int)rand);

	NSString* spritePath;
	switch (rand) {
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
		default:
			spritePath = @"Assets/object_coloful-mushrooms/Mushrooms_01_256x256_Alt_00_007.png";
			break;
	}

	self = [super initWithImageNamed:spritePath];

    if (self) {
		self.orbColor = rand;
		self.zOrder=9;
    }

    return self;
}

@end
