//
//  Utility.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Utility.h"

@implementation Utility {
}

+ (void)animate:(CCNode*)node name:(NSString*)name
{
    CCAnimationManager* animationManager = node.animationManager;
    [animationManager runAnimationsForSequenceNamed:name];
}

+ (void)switchScene:(NSString*)sceneName
{
    // Replaces scene with game scene called sceneName
    CCScene* scene = [CCBReader loadAsScene:sceneName];
    [[CCDirector sharedDirector] replaceScene:scene];
}

+ (double)pHighScore
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"HighScore"];
}
+ (void)setPHighScore:(double)val
{
    [[NSUserDefaults standardUserDefaults] setDouble:val forKey:@"HighScore"];
}

+ (long)pMaxCombo
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"MaxCombo"];
}
+ (void)setPMaxCombo:(long)val
{
    [[NSUserDefaults standardUserDefaults] setInteger:val forKey:@"MaxCombo"];
}

+ (long)pDayCounter
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"DayCounter"];
}

+ (void)setPDayCounter:(long)val
{
    [[NSUserDefaults standardUserDefaults] setInteger:val forKey:@"DayCounter"];
}

+ (double)pAffection
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"Affection"];
}

+ (void)setPAffection:(double)val
{
    [[NSUserDefaults standardUserDefaults] setDouble:val forKey:@"Affection"];
}

+ (double) pEnergy
{
	return [[NSUserDefaults standardUserDefaults] doubleForKey:@"Energy"];
}

+ (void) setPEnergy:(double)val
{
	[[NSUserDefaults standardUserDefaults] setDouble:val forKey:@"Energy"];
}


+ (BOOL)pHighlightPlot
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"HighlightPlot"];
}

+ (void)setPHighlightPlot:(BOOL)val
{
	[[NSUserDefaults standardUserDefaults] setBool:val forKey:@"HighlightPlot"];
}

+ (BOOL)pTutorialPlayed
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"TutorialPlayed"];
}

+ (void)setPTutorialPlayed:(BOOL)val
{
    [[NSUserDefaults standardUserDefaults] setBool:val forKey:@"TutorialPlayed"];
}

+ (long)pUnlockedSceneCount
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"UnlockedSceneCount"];
}
+ (void) setPUnlockedSceneCount:(long)val;
{
	[[NSUserDefaults standardUserDefaults] setInteger:val forKey:@"UnlockedSceneCount"];
}

@end
