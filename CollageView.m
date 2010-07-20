//
//  CollageView.m
//  LiveGather
//
//  Created by Alexander on 7/18/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import "CollageView.h"


@implementation CollageView

@synthesize liveStreamViewController;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint coord = [[touches anyObject] locationInView:self];
	float xCoord = coord.x;
	float yCoord = coord.y;
	liveStreamViewController = [[LiveStreamViewController alloc] init];
	[liveStreamViewController userTouchedLiveStreamView:xCoord andYCoord:yCoord];
}

@end
