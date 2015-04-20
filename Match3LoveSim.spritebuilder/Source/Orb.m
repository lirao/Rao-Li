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
static int MAX_X = 64;
static int MAX_Y = 64;
//static NSString* SPRITE = @"Assets/object_coloful-mushrooms/%@";
static NSString* SPRITE = @"Assets/object_game-power-ups/%@";

@implementation Orb {
}

//Init with random color
- (instancetype)initOrb
{
    MyValue rand = arc4random() % color_count;
    return [self initWithColor:rand];
}

- (void)setColor:(MyValue)color
{
    NSString* spritePath;

    switch (color) {
    case HEAL:
        spritePath = [NSString stringWithFormat:SPRITE, @"Heart.png"];
        break;
    case PTDOWN:
        spritePath = [NSString stringWithFormat:SPRITE, @"Potion-Purple.png"];
        break;
    case PTDOWNSP:
        spritePath = [NSString stringWithFormat:SPRITE, @"Shield.png"];
        break;
    case NEUTRAL:
        spritePath = [NSString stringWithFormat:SPRITE, @"Ice.png"];
        break;
    case PTUP:
        spritePath = [NSString stringWithFormat:SPRITE, @"Blast.png"];
        break;
    case PTUPSP:
        spritePath = [NSString stringWithFormat:SPRITE, @"Star.png"];
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

        self.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:self.contentSize.width * 0.25 andCenter:ccp(1, 0.5)];
//        NSLog(@"%@", NSStringFromCGPoint(self.anchorPoint));
        self.physicsBody.collisionType = @"orb";
        self.physicsBody.affectedByGravity = NO;
    }

    return self;
}

//- (void)didLoadFromCCB
//{
//
//
//	self.physicsBody.collisionType = @"orb";
//
//	NSLog(@"%@", self.physicsBody);
//}

+ (void)setHeight:(int)value { MAX_Y = value; }

+ (void)setWidth:(int)value { MAX_X = value; }

- (BOOL)isOverlap:(Orb*)anotherOrb
{
    if (CGRectIntersectsRect([self boundingBox], [anotherOrb boundingBox])) {

        // Handle detailed overlap
        float distanceForCollision = (self.contentSize.width * 0.7) + (anotherOrb.contentSize.width * 0.7);
        float actualDistance = ccpDistance(self.position, anotherOrb.position);
        if (actualDistance <= distanceForCollision) {
            return YES;
        }
    }
    return NO;
}

@end
