//
//  LiveStreamViewController.h
//  LiveGather
//
//  Created by Alexander on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveGatherAPI.h"
#import "MBProgressHUD.h"

@interface LiveStreamViewController : UIViewController <MBProgressHUDDelegate> {
	IBOutlet UIButton			*backButton;
	IBOutlet UILabel			*userNameLabel;
	IBOutlet UIScrollView		*liveStreamScrollView;
	IBOutlet UIButton			*searchButton;
	IBOutlet UIButton			*refreshButton;
	NSMutableArray				*streamArray;
	LiveGatherAPI				*applicationAPI;
	MBProgressHUD				*HUD;
}

- (IBAction)goHome;
- (void)updateLiveStreamPhotos;
- (void)newLiveStreamPhotosDownloaded;
- (IBAction)refreshLiveStream;
- (IBAction)searchLiveSteam;

@end
