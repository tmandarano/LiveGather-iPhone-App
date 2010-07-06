//
//  MainViewController.m
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

@synthesize appResourceManager;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
	imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.allowsImageEditing = NO;
	imagePickerController.delegate = self;
	if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		capturePhotoButton.enabled = NO;
	}
	appResourceManager = [[ResourceManager alloc] init];
	uploadViewController = [[UploadPhotoViewController alloc] init];
	liveStreamView = [[LiveStreamViewController alloc] init];
	networkQueue = [[ASINetworkQueue alloc] init];
	applicationAPI = [[LiveGatherAPI alloc] init];
	
	//Livestream Icons handling
	
	[super viewDidLoad];
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}

//Custom Methods for this Class

- (IBAction)takePhoto {
	imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:imagePickerController animated:YES];
}

- (IBAction)choosePhoto {
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:imagePickerController animated:YES];
}

- (IBAction)viewLiveStream {
	[self presentModalViewController:liveStreamView animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	[[picker parentViewController] dismissModalViewControllerAnimated:NO];
	[uploadViewController getPhotoForUpload:img];
	[appResourceManager saveImageToDocuments:img withFilename:@"image_to_upload" andFileType:@"PNG"];
	[self presentModalViewController:uploadViewController animated:YES];
}

- (void)updateLiveStreamPhotos {
	
}

- (void)newLiveStreamPhotosDownloaded {
	
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
