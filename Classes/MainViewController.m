//
//  MainViewController.m
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

#define kLiveStreamPreviewStartPoint_X 10
#define kLiveStreamPreviewStartPoint_Y 5
#define kLiveStreamPreviewLowerStartPoint_X 10
#define kLiveStreamPreviewLowerStartPoint_Y 70
#define kLiveStreamPreviewVerticalPadding 2
#define kLiveStreamPreviewHorizontalPadding 2
#define kLiveStreamPreviewImageWidth 61
#define kLiveStreamPreviewImageHeight 61
#define kLiveStreamPreviewStaticHeight 149

@synthesize appResourceManager;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
	appResourceManager = [[ResourceManager alloc] init];
	uploadViewController = [[UploadPhotoViewController alloc] init];
	liveStreamView = [[LiveStreamViewController alloc] init];
	applicationAPI = [[LiveGatherAPI alloc] init];
	
	if(!liveStreamObjects) liveStreamObjects = [NSMutableArray new];
	
	[self updateLiveStreamPhotos];
	[self updateTags];
	
	[refreshLiveStreamMiniViewButton setFrame:CGRectMake(277, 419, 35, 32)];
	
	[super viewDidLoad];
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

//Custom Methods for this Class

- (IBAction)uploadPhoto {
	NSLog(@"%d", [liveStreamObjects count]);
	//[uploadViewController showUserImageControlOption];
	//[self presentModalViewController:uploadViewController animated:YES];
}

- (IBAction)viewLiveStream {
	//[applicationAPI getRecentTagsWithLimit:5];
	[self presentModalViewController:liveStreamView animated:YES];
}

- (void)updateTags {
	NSMutableArray *tagsArray = [[NSMutableArray alloc] initWithArray:[applicationAPI getRecentTagsWithLimit:5]];
	
	int numTagsToPlace = [tagsArray count];
	float currentPointInScrollView = 0;
	
	for (int i = 0; i < numTagsToPlace; i++) {
		LGTag *tag = [tagsArray objectAtIndex:i];
		UILabel *label = [[UILabel alloc] init];
		[label setTextColor:[UIColor blueColor]];
		[label setText:[NSString stringWithFormat:@"#%@",[tag tag]]];
		[tagsScrollView addSubview:label];
		currentPointInScrollView += label.frame.size.width;
	}
}

- (IBAction)refreshStream {
	NSLog(@"Drawing objects to stream view");
	
	int numImageViewsToPlace = [liveStreamObjects count];
	
	NSLog(@"%d", numImageViewsToPlace);
	
	int numRows = 2;
	int numCols = 0;
	int contentSizeHeight = kLiveStreamPreviewImageHeight + kLiveStreamPreviewVerticalPadding;
	
	for (int i = 0; i < numImageViewsToPlace; i++) {
		int row = i % numRows;
		
		if(row == 0)
		{
			numCols += 1;
		}
	}
	
	int contentSizeWidth = ((kLiveStreamPreviewImageWidth + 5) * numCols);
	
	[liveStreamPreviewScrollView setContentSize:CGSizeMake(contentSizeWidth, contentSizeHeight)];
	
	for (int i = 0; i < numImageViewsToPlace; i++) {
		int row = i % numRows;
		int col = i / numRows;
		
		LGPhoto *photo = [liveStreamObjects objectAtIndex:i];
		
		//UIImageView *imageView = [[UIImageView alloc] initWithImage:photo.photoImage];
		
		if(row == 1)
		{
			[photo setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewLowerStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
			//[imageView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewLowerStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		else {
			[photo setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageHeight, kLiveStreamPreviewImageHeight)];
			//[imageView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageHeight, kLiveStreamPreviewImageHeight)];
		}
		
		//[liveStreamPreviewScrollView addSubview:imageView];
		[liveStreamPreviewScrollView addSubview:photo];
		
		NSLog(@"row: %d", row);
		NSLog(@"col: %d", col);
	}
}

- (IBAction)updateLiveStreamPhotos {	
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Algorithm is working";
    [HUD showWhileExecuting:@selector(downloadNewLiveStreamPhotos) onTarget:self withObject:nil animated:YES];
}

- (void)downloadNewLiveStreamPhotos {
	NSMutableArray *liveStreamArray = [NSMutableArray arrayWithArray:[applicationAPI getLiveFeed:10]];
	
	if(!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];
	}
	[networkQueue reset];
	//[networkQueue setDownloadProgressDelegate:progressIndicator];
	[networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
	//[networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
	[networkQueue setShowAccurateProgress:YES];
	[networkQueue setDelegate:self];
	
	for (int i = 0; i < [liveStreamArray count]; i++) {
		LGPhoto *photo = [liveStreamArray objectAtIndex:i];
		
		ASIHTTPRequest *request;
		request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/%@/3", photo.photoID]]];
		[request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", photo.photoName]]];
		//[request setDownloadProgressDelegate:imageProgressIndicator1];
		[networkQueue addOperation:request];
	}
	[networkQueue go];
}

- (void)imageFetchComplete:(ASIHTTPRequest *)request {
	if(networkQueue.requestsCount == 0)
	{
		NSLog(@"Drawing objects to stream view");
		
		int numImageViewsToPlace = [liveStreamObjects count];
		
		NSLog(@"%d", numImageViewsToPlace);
		
		int numRows = 2;
		int numCols = 0;
		int contentSizeHeight = kLiveStreamPreviewImageHeight + kLiveStreamPreviewVerticalPadding;
		
		for (int i = 0; i < numImageViewsToPlace; i++) {
			int row = i % numRows;
			
			if(row == 0)
			{
				numCols += 1;
			}
		}
		
		int contentSizeWidth = ((kLiveStreamPreviewImageWidth + 5) * numCols);
		
		[liveStreamPreviewScrollView setContentSize:CGSizeMake(contentSizeWidth, contentSizeHeight)];
		
		for (int i = 0; i < numImageViewsToPlace; i++) {
			int row = i % numRows;
			int col = i / numRows;
			
			LGPhoto *photo = [liveStreamObjects objectAtIndex:i];
			
			//UIImageView *imageView = [[UIImageView alloc] initWithImage:photo.photoImage];
			//UIButton *button = [[UIButton alloc] init];
			//[button setBackgroundImage:photo.photoImage forState:UIControlStateNormal]
			
			if(row == 1)
			{
				[photo setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewLowerStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
				//[imageView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewLowerStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
			}
			else {
				[photo setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageHeight, kLiveStreamPreviewImageHeight)];
				//[imageView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageHeight, kLiveStreamPreviewImageHeight)];
			}
			
			//[liveStreamPreviewScrollView addSubview:imageView];
			[liveStreamPreviewScrollView addSubview:photo];
			
			NSLog(@"row: %d", row);
			NSLog(@"col: %d", col);
		}
	}
	else {
		NSLog(@"Adding Object for Stream");
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:[request downloadDestinationPath]];
		LGPhoto *photo = [[LGPhoto alloc] init];
		[photo setImage:img];
		[liveStreamObjects addObject:photo];
	}
}

- (void)imageDownloadingFinished {
	
}

- (void)hudWasHidden {
	
}

//<!--End Custom Methods for this Class

- (IBAction)showInfo {
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}


@end
