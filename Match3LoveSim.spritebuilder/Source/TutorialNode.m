//
//  TutorialNode.m
//  Match3LoveSim
//
//  Created by Rao Li on 5/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TutorialNode.h"
@import MediaPlayer;

@implementation TutorialNode
{
	CCNode* _videoNode;
	
}
- (void)setVisible:(BOOL)visible
{
	[super setVisible:visible];

	NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"mov"];
	NSURL *streamURL = [NSURL fileURLWithPath:videoPath];
	MPMoviePlayerController *moviplayer =[[MPMoviePlayerController alloc] initWithContentURL:streamURL];
	[moviplayer prepareToPlay];
	[moviplayer.view setFrame: _videoNode.boundingBox];

	[[[CCDirector sharedDirector] view] addSubview:moviplayer.view];

	moviplayer.shouldAutoplay = YES;
	moviplayer.repeatMode = MPMovieRepeatModeOne;
	moviplayer.movieSourceType = MPMovieSourceTypeFile;
	[moviplayer play];



}


@end
