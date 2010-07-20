//
//  CollageItem.m
//  LiveGather
//
//  Created by Alexander on 7/18/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import "CollageItem.h"


@implementation CollageItem

@synthesize liveStreamViewController;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"%d", photoLocationInCollage);
}

- (void)setArrayLocation:(int)num {
	photoLocationInCollage = num;
}

@end
