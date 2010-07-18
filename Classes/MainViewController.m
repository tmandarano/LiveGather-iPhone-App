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
#define kLiveStreamPreviewStartPoint_Y 12
#define kLiveStreamPreviewLowerStartPoint_X 10
#define kLiveStreamPreviewLowerStartPoint_Y 81
#define kLiveStreamPreviewVerticalPadding 69
#define kLiveStreamPreviewHorizontalPadding 69
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
	
	[self updateLiveStreamPhotos];
	
	[super viewDidLoad];
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

//Custom Methods for this Class

- (IBAction)viewLiveStream {
	[self presentModalViewController:liveStreamView animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	[[picker parentViewController] dismissModalViewControllerAnimated:NO];
	//[appResourceManager saveImageToDocuments:img withFilename:@"image_to_upload" andFileType:@"PNG"];
	[self presentModalViewController:uploadViewController animated:YES];
}

- (void)updateLiveStreamPhotos {
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Algorithm is Sorting ImageViews";
	[HUD showWhileExecuting:@selector(newLiveStreamPhotosDownloaded) onTarget:self withObject:nil animated:YES];
}

- (void)newLiveStreamPhotosDownloaded {
	int numImageViewsToPlace = 50;
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
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray.jpg"]];
		
		if(row == 1)
		{
			[imageView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + 5) * col), kLiveStreamPreviewLowerStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		else {
			[imageView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + 5) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageHeight, kLiveStreamPreviewImageHeight)];
		}
		
		[liveStreamPreviewScrollView addSubview:imageView];
		
		NSLog(@"row: %d", row);
		NSLog(@"col: %d", col);
	}
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
