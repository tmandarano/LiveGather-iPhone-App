//
//  LiveStreamViewController.h
//  LiveGather
//
//  Created by Alexander on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveGatherAPI.h"
#import "EGORefreshTableHeaderView.h"

@class EGORefreshTableHeaderView;

@interface LiveStreamViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UIBarButtonItem	*homeBarButton;
	IBOutlet UITableView		*streamTableView;
	IBOutlet UILabel			*userNameLabel;
	NSMutableArray				*streamArray;
	EGORefreshTableHeaderView	*refreshHeaderView;
	BOOL	_reloading;
	UIImage *testImage;
	LiveGatherAPI				*applicationAPI;
}

- (IBAction)goHome;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)dataSourceDidFinishLoadingNewData;

@end
