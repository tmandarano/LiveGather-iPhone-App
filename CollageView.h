//
//  CollageView.h
//  LiveGather
//
//  Created by Alexander on 7/18/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveStreamViewController.h"

@class LiveStreamViewController;

@interface CollageView : UIScrollView {
	LiveStreamViewController *liveStreamViewController;
}

@property(nonatomic, retain) LiveStreamViewController *liveStreamViewController;

@end
