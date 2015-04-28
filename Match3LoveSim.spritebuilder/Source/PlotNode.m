//
//  PlotNode.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlotNode.h"
#import "Plot.h"

@implementation PlotNode {
    int _sceneCount;
    int _currScene;
}

- (void)setVisible:(BOOL)visible
{
    _visible = visible;
    if (_visible) {
        _currScene = 0;
        CCAnimationManager* animationManager = self.animationManager;
        [animationManager runAnimationsForSequenceNamed:[@(_currScene) stringValue]];
    }
}

- (void)next
{
    _currScene++;
    if (_currScene > _sceneCount) {
        [(Plot*)self.parent skip];
    }
    else {
        CCAnimationManager* animationManager = self.animationManager;
        [animationManager runAnimationsForSequenceNamed:[@(_currScene) stringValue]];
    }
}

@end
