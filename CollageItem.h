//
//  CollageItem.h
//  LiveGather
//
//  Created by Alexander on 7/18/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LiveStreamViewController.h"

@class LiveStreamViewController;

@interface CollageItem : UIImageView {
	int			photoID;
	int			photoLocationInCollage;
	NSArray		*photoTags;
	NSString	*photoLocation;
	NSString	*photoName;
	NSString	*photoInfo;
	LiveStreamViewController *liveStreamViewController;
}

@property(nonatomic, retain) LiveStreamViewController *liveStreamViewController;

- (void)setArrayLocation:(int)num;

@end
