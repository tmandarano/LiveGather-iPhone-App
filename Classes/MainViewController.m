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
	
	//Livestream Icons handling
	
	if([appResourceManager doesFileExistInBundle:@"LiveStreamIcon0.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[mainLiveStreamIcon setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/LiveStreamIcon0.png",documentsDirectory]]];
	}
	else {
		[mainLiveStreamIcon setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon1.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconOne setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon1.png",documentsDirectory]]];
	}
	else {
		[liveStreamIconOne setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon2.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconTwo setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon2.png",documentsDirectory]]];
	}
	else {
		[liveStreamIconTwo setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon3.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconThree setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon3.png",documentsDirectory]]];
	}
	else {
		[liveStreamIconThree setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon4.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconFour setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon4.png",documentsDirectory]]];
	}
	else {
		[liveStreamIconFour setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon5.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconFive setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon5.png",documentsDirectory]]];
	}
	else {
		[liveStreamIconFive setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon6.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconSix setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon6.png",documentsDirectory]]];
	}
	else {
		[liveStreamIconSix setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon7.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconSeven setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon7.png",documentsDirectory]]];
	}
	else {
		[liveStreamIconSeven setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon8.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconEight setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon8.png",documentsDirectory]]];
	}
	else {
		[liveStreamIconEight setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon9.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconNine setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon9.png",documentsDirectory]]];
	}
	else {
		[liveStreamIconNine setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon10.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconTen setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon10.png",documentsDirectory]]];
	}
	else {
		[liveStreamIconTen setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeDeterminate;
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading...";
    [HUD showWhileExecuting:@selector(updateLiveStreamPhotos) onTarget:self withObject:nil animated:YES];
	
	//
	
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
	[liveStreamIconOneLoadingIndicator startAnimating];
	[liveStreamIconTwoLoadingIndicator startAnimating];
	[liveStreamIconThreeLoadingIndicator startAnimating];
	[liveStreamIconFourLoadingIndicator startAnimating];
	[liveStreamIconFiveLoadingIndicator startAnimating];
	[liveStreamIconSixLoadingIndicator startAnimating];
	[liveStreamIconSevenLoadingIndicator startAnimating];
	[liveStreamIconEightLoadingIndicator startAnimating];
	[liveStreamIconNineLoadingIndicator startAnimating];
	[liveStreamIconTenLoadingIndicator startAnimating];
	[mainLiveStreamIconLoadingIndicator startAnimating];
	
	[networkQueue cancelAllOperations];
	[networkQueue setDownloadProgressDelegate:progressView];
	[networkQueue setRequestDidFinishSelector:@selector(newLiveStreamPhotosDownloaded)];
	[networkQueue setShowAccurateProgress:YES];
	[networkQueue setDelegate:self];
	
	ASIHTTPRequest *request;
	
	int x = random() % 50;
	NSString *URLString;
	if((x & 1) == 0) {
		URLString = @"";
	}
	else {
		URLString = @"";
	}
		
	for(int i = 0; i < 11; i++)
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager removeItemAtPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"LiveStreamIcon%d.png",i]] error:NULL];
		request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:URLString]] autorelease];
		[request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"LiveStreamIcon%d.png",i]]];
		[networkQueue addOperation:request];
	}
	
	[networkQueue go];
	
	while (progressView.progress < 1.0f) {
		HUD.progress = progressView.progress;
        usleep(50000);
	}
}

- (void)newLiveStreamPhotosDownloaded {
	if([networkQueue requestsCount] == 0)
	{
		[liveStreamIconOneLoadingIndicator stopAnimating];
		[liveStreamIconTwoLoadingIndicator stopAnimating];
		[liveStreamIconThreeLoadingIndicator stopAnimating];
		[liveStreamIconFourLoadingIndicator stopAnimating];
		[liveStreamIconFiveLoadingIndicator stopAnimating];
		[liveStreamIconSixLoadingIndicator stopAnimating];
		[liveStreamIconSevenLoadingIndicator stopAnimating];
		[liveStreamIconEightLoadingIndicator stopAnimating];
		[liveStreamIconNineLoadingIndicator stopAnimating];
		[liveStreamIconTenLoadingIndicator stopAnimating];
		[mainLiveStreamIconLoadingIndicator stopAnimating];
	}
	if([appResourceManager doesFileExistInBundle:@"LiveStreamIcon0.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[mainLiveStreamIcon setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/LiveStreamIcon0.png",documentsDirectory]]];
		[mainLiveStreamIconLoadingIndicator stopAnimating];
	}
	else {
		[mainLiveStreamIcon setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon1.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconOne setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon1.png",documentsDirectory]]];
		[liveStreamIconOneLoadingIndicator stopAnimating];
	}
	else {
		[liveStreamIconOne setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon2.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconTwo setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon2.png",documentsDirectory]]];
		[liveStreamIconTwoLoadingIndicator stopAnimating];
	}
	else {
		[liveStreamIconTwo setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon3.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconThree setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon3.png",documentsDirectory]]];
		[liveStreamIconThreeLoadingIndicator stopAnimating];
	}
	else {
		[liveStreamIconThree setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon4.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconFour setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon4.png",documentsDirectory]]];
		[liveStreamIconFourLoadingIndicator stopAnimating];
	}
	else {
		[liveStreamIconFour setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon5.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconFive setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon5.png",documentsDirectory]]];
		[liveStreamIconFiveLoadingIndicator stopAnimating];
	}
	else {
		[liveStreamIconFive setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon6.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconSix setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon6.png",documentsDirectory]]];
		[liveStreamIconSixLoadingIndicator stopAnimating];
	}
	else {
		[liveStreamIconSix setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon7.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconSeven setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon7.png",documentsDirectory]]];
		[liveStreamIconSevenLoadingIndicator stopAnimating];
	}
	else {
		[liveStreamIconSeven setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon8.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconEight setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon8.png",documentsDirectory]]];
		[liveStreamIconEightLoadingIndicator stopAnimating];
	}
	else {
		[liveStreamIconEight setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon9.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconNine setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon9.png",documentsDirectory]]];
		[liveStreamIconNineLoadingIndicator stopAnimating];
	}
	else {
		[liveStreamIconNine setImage:[UIImage imageNamed:@"gray.jpg"]];
	}
	
	if([appResourceManager doesFileExistInBundle:@"liveStreamIcon10.png"])
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		[liveStreamIconTen setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/liveStreamIcon10.png",documentsDirectory]]];
		[liveStreamIconTenLoadingIndicator stopAnimating];
	}
	else {
		[liveStreamIconTen setImage:[UIImage imageNamed:@"gray.jpg"]];
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
