//
//  TutorialNode.m
//  Match3LoveSim
//
//  Created by Rao Li on 5/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TutorialNode.h"
//@import MediaPlayer;
#import "Utility.h"

@implementation TutorialNode
{
	CCNode* _textNode;
	
}

- (void)setVisible:(BOOL)visible
{
	[super setVisible:visible];

//	if (visible)
//	{
//	NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"Tutorial" ofType:@"mp4"];
//	NSURL *streamURL = [NSURL fileURLWithPath:videoPath];
//	MPMoviePlayerController *moviplayer =[[MPMoviePlayerController alloc] initWithContentURL:streamURL];
//	[moviplayer prepareToPlay];
//	[moviplayer.view setFrame: _videoNode.boundingBox];
//
//	[[[CCDirector sharedDirector] view] addSubview:moviplayer.view];
//
//	UIView* glView = [CCDirector sharedDirector].view; // attention
//	[glView.superview insertSubview:moviplayer.view atIndex:0]; // attention
//	glView.opaque = NO; // attention
//	glClearColor(0.0f, 0.0f, 0.0f, 0.0f); // attention
//
//	moviplayer.shouldAutoplay = YES;
//	moviplayer.repeatMode = MPMovieRepeatModeOne;
//	moviplayer.controlStyle = MPMovieControlStyleNone;
//	moviplayer.movieSourceType = MPMovieSourceTypeFile;
//
//		[moviplayer play];
//	}

}


- (int)next
{
	super.currScene++;
	if (super.currScene > super.sceneCount) {
		return -1;
	}
	else {
		[Utility animate:_textNode name:[@(super.currScene) stringValue]];
	}
	return super.currScene;
}

@end
