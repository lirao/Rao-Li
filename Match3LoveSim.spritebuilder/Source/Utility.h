//
//  Utility.h
//  Match3LoveSim
//
//  Created by Rao Li on 4/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Utility : CCNode

+ (double) pHighScore;
+ (void) setPHighScore:(double)val;

+ (long) pMaxCombo;
+ (void) setPMaxCombo:(long)val;

+ (long) pDayCounter;
+ (void) setPDayCounter:(long)val;

+ (double) pAffection;
+ (void) setPAffection:(double)val;

+ (BOOL) pTutorialPlayed;
+ (void) setPTutorialPlayed:(BOOL)val;


+(void) animate:(CCNode*)node name:(NSString*)name;
+(void) switchScene:(NSString*)sceneName;
@end
