//
//  Orb.h
//  Match3LoveSim
//
//  Created by Rao Li on 2/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"


typedef NS_ENUM(NSInteger, MyValue) {
	RED = 0,
	ORANGE,
	YELLOW,
	GREEN,
	BLUE,
	PURPLE,
	color_count
};

@interface Orb : CCSprite

@property (nonatomic, readwrite) MyValue orbColor;

- (instancetype)initOrb;
- (instancetype)initWithColor:(MyValue)color;

+ (void) setHeight:(int)value;
+ (void) setWidth:(int)value;


@end
