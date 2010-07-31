//
//  LiveStreamViewController.m
//  LiveGather
//
//  Created by Alexander on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LiveStreamViewController.h"


@implementation LiveStreamViewController

@synthesize liveStreamScrollView;

#define kLiveStreamPreviewStartPoint_X 5
#define kLiveStreamPreviewStartPoint_Y 5
#define kLiveStreamPreviewMidStartPoint_X 5
#define kLiveStreamPreviewMidStartPoint_Y 142
#define kLiveStreamPreviewBottomStartPoint_X 5
#define kLiveStreamPreviewBottomStartPoint_Y 279
#define kLiveStreamPreviewVerticalPadding 2
#define kLiveStreamPreviewHorizontalPadding 2
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
	//streamArray = [NSMutableArray new];
	//streamContainersArray = [NSMutableArray new];
	liveStreamScrollView = [[CollageView alloc] initWithFrame:CGRectMake(0, 45, 320, 415)];
	[liveStreamScrollView setBackgroundColor:[UIColor blackColor]];
	[self.view addSubview:liveStreamScrollView];
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
	/*int numImageViewsToPlace = 100;
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
		
		UIView *containerView = [[UIView alloc] init];
		CollageItem *collageItem = [[CollageItem alloc] initWithImage:[UIImage imageNamed:@"gray.jpg"]];
		collageItem.userInteractionEnabled = YES;
		[collageItem setArrayLocation:i];
		
		if(row == 0)
		{
			[containerView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
			[collageItem setFrame:CGRectMake(0, 0, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		else if(row == 1) {
			[containerView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewMidStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
			[collageItem setFrame:CGRectMake(0, 0, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		else if(row == 2) {
			[containerView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewBottomStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
			[collageItem setFrame:CGRectMake(0, 0, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		
		[streamArray addObject:collageItem];
		[streamContainersArray addObject:containerView];
		[liveStreamScrollView addSubview:containerView];
		[containerView addSubview:collageItem];
		
		NSLog(@"row: %d", row);
		NSLog(@"col: %d", col);
	}*/
}

- (IBAction)refreshLiveStream {
	int numToAdd = 9;
	int numCols = 0;
	int numRows = 3;
	
	for (int i = 0; i < numToAdd; i++) {
		int row = i % numRows;
		
		if(row == 0)
		{
			numCols += 1;
		}
	}
	
	int contentSizeAddition = ((kLiveStreamPreviewImageWidth + 5) * numCols);
	
	[liveStreamScrollView setContentSize:CGSizeMake((liveStreamScrollView.contentSize.width + contentSizeAddition), (liveStreamScrollView.contentSize.height))];
	
	/*for (int i = 0; i < [streamArray count]; i++) {
		CollageItem *item = [streamArray objectAtIndex:i];
		[item setFrame:CGRectMake((item.frame.origin.x + contentSizeAddition), item.frame.origin.y, item.frame.size.width, item.frame.size.height)];
	}
	
	for (int i = 0; i < numToAdd; i++) {
		int row = i % numRows;
		int col = i / numRows;
		
		UIView *containerView = [[UIView alloc] init];
		CollageItem *collageItem = [[CollageItem alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
		collageItem.userInteractionEnabled = YES;
		[collageItem setArrayLocation:i];
		
		if(row == 0)
		{
			[containerView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
			[collageItem setFrame:CGRectMake(0, 0, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		else if(row == 1) {
			[containerView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewMidStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
			[collageItem setFrame:CGRectMake(0, 0, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		else if(row == 2) {
			[containerView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewBottomStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
			[collageItem setFrame:CGRectMake(0, 0, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		
		[streamArray addObject:collageItem];
		[streamContainersArray addObject:containerView];
		[liveStreamScrollView addSubview:containerView];
		[containerView addSubview:collageItem];
		
		NSLog(@"row: %d", row);
		NSLog(@"col: %d", col);
	}*/
	
	[liveStreamScrollView setContentOffset:CGPointMake((contentSizeAddition - 15), 0.0) animated:NO];
	
	/*UIImageView *imageView = [streamArray objectAtIndex:3];
	UIView *containerView = [streamContainersArray objectAtIndex:3];
	MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height)];
	[mapView setShowsUserLocation:YES];
	NSLog(@"%f", imageView.frame.origin.x);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];
	[imageView removeFromSuperview];
	[containerView addSubview:mapView];
	[UIView commitAnimations];*/
}

- (void)userTouchedLiveStreamView:(float)x_coord andYCoord:(float)y_coord {
	NSLog(@"%f %f", x_coord, y_coord);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"Touuuuuucccchhhhhhh");
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
