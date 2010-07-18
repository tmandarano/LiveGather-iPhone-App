//
//  LiveStreamViewController.m
//  LiveGather
//
//  Created by Alexander on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LiveStreamViewController.h"


@implementation LiveStreamViewController

#define kLiveStreamPreviewStartPoint_X 5
#define kLiveStreamPreviewStartPoint_Y 5
#define kLiveStreamPreviewMidStartPoint_X 5
#define kLiveStreamPreviewMidStartPoint_Y 142
#define kLiveStreamPreviewBottomStartPoint_X 5
#define kLiveStreamPreviewBottomStartPoint_Y 279
#define kLiveStreamPreviewVerticalPadding 5
#define kLiveStreamPreviewHorizontalPadding 5
#define kLiveStreamPreviewImageWidth 125
#define kLiveStreamPreviewImageHeight 129
#define kLiveStreamPreviewStaticHeight 415

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	applicationAPI = [[LiveGatherAPI alloc] init];
	[self updateLiveStreamPhotos];
    [super viewDidLoad];
}

//Custom Methods

- (void)updateLiveStreamPhotos {
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Algorithm is Sorting ImageViews";
	[HUD showWhileExecuting:@selector(newLiveStreamPhotosDownloaded) onTarget:self withObject:nil animated:YES];
}

- (void)newLiveStreamPhotosDownloaded {
	int numImageViewsToPlace = 1000;
	int numRows = 3;
	int numCols = 0;
	int contentSizeHeight = kLiveStreamPreviewStaticHeight;
	
	for (int i = 0; i < numImageViewsToPlace; i++) {
		int row = i % numRows;
		
		if(row == 0)
		{
			numCols += 1;
		}
	}
	
	int contentSizeWidth = ((kLiveStreamPreviewImageWidth + 5) * numCols);
	
	[liveStreamScrollView setContentSize:CGSizeMake(contentSizeWidth, contentSizeHeight)];
	
	for (int i = 0; i < numImageViewsToPlace; i++) {
		int row = i % numRows;
		int col = i / numRows;
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray.jpg"]];
		
		if(row == 0)
		{
			[imageView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		else if(row == 1) {
			[imageView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewMidStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		else if(row == 2) {
			[imageView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewBottomStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		
		[liveStreamScrollView addSubview:imageView];
		
		NSLog(@"row: %d", row);
		NSLog(@"col: %d", col);
	}
}

- (IBAction)refreshLiveStream {
	
}

- (IBAction)searchLiveSteam {
	
}

- (IBAction)goHome {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)hudWasHidden {
	
}

//<!-- Custom Methods


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
