//
//  Orb.h
//  Match3LoveSim
//
//  Created by Rao Li on 2/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"


typedef NS_ENUM(NSInteger, MyValue) {
	HEAL = 0,
	PTDOWN,
	PTDOWNSP,
	NEUTRAL,
	PTUP,
	PTUPSP,
	color_count
};

@interface Orb : CCSprite

@property (nonatomic, readwrite) MyValue orbColor;
@property (nonatomic, readwrite) BOOL changed;

- (instancetype)initOrb;
- (instancetype)initWithColor:(MyValue)color;
- (void)setColor:(MyValue)color;
- (BOOL)isOverlap:(Orb*)anotherOrb;

+ (void) setHeight:(int)value;
+ (void) setWidth:(int)value;
//+ (int) getHeight;
//+ (int) getWidth;



@end
