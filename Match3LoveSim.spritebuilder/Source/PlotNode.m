//
//  PlotNode.m
//  Match3LoveSim
//
//  Created by Rao Li on 4/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "PlotNode.h"
#import "Plot.h"
#import "Utility.h"
@implementation PlotNode {

}

//Replay init scene when set to visible
- (void)setVisible:(BOOL)visible
{
    _visible = visible;
    if (_visible) {
        _currScene = 0;
		[Utility animate:self name:[@(_currScene) stringValue]];
	}


}

- (int)next
{
    _currScene++;
    if (_currScene > _sceneCount) {
		return -1;
    }
    else {
		[Utility animate:self name:[@(_currScene) stringValue]];
    }
	return _currScene;
}

@end
