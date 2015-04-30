//
//  Utility.h
//  Match3LoveSim
//
//  Created by Rao Li on 4/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Utility : CCNode

//@property (nonatomic, readwrite) double affection;
//@property (nonatomic, readwrite) double ;
//@property (nonatomic, readwrite) double score;
//@property (nonatomic, readwrite) double score;

+(void) animate:(CCNode*)node name:(NSString*)name;
+(void) switchScene:(NSString*)sceneName;
@end
