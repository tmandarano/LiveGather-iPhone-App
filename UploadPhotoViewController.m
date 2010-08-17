//
//  UploadPhotoViewController.m
//  LiveGather
//
//  Created by Alexander on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UploadPhotoViewController.h"

#define kPrivacyAlertTag 3


@implementation UploadPhotoViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
	mainViewController = [[MainViewController alloc] init];
	
	[[CLController sharedInstance].locationManager startUpdatingLocation];
	[[CLController sharedInstance].locationManager setDelegate:self];
	[[CLController sharedInstance].locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	
    [super viewDidLoad];
}

- (IBAction)refreshLocation {
	
}

- (IBAction)sendToTwitter {
	
}

- (IBAction)sendToFacebook {
	
}

- (void)showUserImageControlOption {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIActionSheet *userImagePickerType = [[UIActionSheet alloc] initWithTitle:@"Upload Photo From:"
																		 delegate:self
																cancelButtonTitle:@"Cancel"
														   destructiveButtonTitle:nil
																otherButtonTitles:nil];
		[userImagePickerType addButtonWithTitle:@"Photo Library"];
		[userImagePickerType addButtonWithTitle:@"Camera"];
		[userImagePickerType showInView:self.view];
		
		/************************MEMORY FIX HERE***************************/
		[userImagePickerType release];
		/************************MEMORY FIX HERE***************************/
	}
	else {
		UIActionSheet *userImagePickerType = [[UIActionSheet alloc] initWithTitle:@"Upload Photo From:"
																		 delegate:self
																cancelButtonTitle:@"Cancel"
														   destructiveButtonTitle:nil
																otherButtonTitles:nil];
		[userImagePickerType addButtonWithTitle:@"Photo Library"];
		[userImagePickerType showInView:self.view];
		
		/************************MEMORY FIX HERE***************************/
		[userImagePickerType release];
		/************************MEMORY FIX HERE***************************/
	}
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"%d",buttonIndex);
	switch (buttonIndex) {
		case 2:
			imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.delegate = self;
			[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
			[self presentModalViewController:imagePickerController animated:YES];
			break;
		case 1:
			imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.delegate = self;
			[imagePickerController setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
			[self presentModalViewController:imagePickerController animated:YES];
			break;
	}
}
	 
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[chosenPhotoPreviewView setImage:img];
	[NSThread detachNewThreadSelector:@selector(uploadImageToServer:) toTarget:self withObject:img];
}

//Custom Methods

- (IBAction)cancel {	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)uploadImageToServer:(UIImage *)img {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
	NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
	NSURL *url = [NSURL URLWithString:@"http://projc:pr0j(@dev.livegather.com/api/photos/upload"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setDelegate:self];
	[request setData:imageData withFileName:@"userfile.jpg" andContentType:@"image/jpeg" forKey:@"userfile"];
	
	[request startAsynchronous];
	
	[pool release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
	NSLog(@"response: %@", responseString);
	fileResponseFromServer = responseString;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	
}

- (void)resetUploadView {
	
}

- (IBAction)upload {
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Uploading";
	HUD.detailsLabelText = @"Uploading image to server";
    [HUD showWhileExecuting:@selector(doServerUpload) onTarget:self withObject:nil animated:YES];
}

- (void)doServerUpload {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSURL *url = [NSURL URLWithString:@"http://projc:pr0j(@dev.livegather.com/api/photos/create"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setRequestMethod:@"POST"];
	[request setDelegate:self];
	[request setPostValue:[captionTextField text] forKey:@"caption"];
	[request setPostValue:[tagsTextField text] forKey:@"tags"];
	[request setPostValue:fileResponseFromServer forKey:@"response"];
	[request setPostValue:[NSString stringWithFormat:@"%f", [CLController sharedInstance].locationManager.location.coordinate.latitude] forKey:@"latitude"];
	[request setPostValue:[NSString stringWithFormat:@"%f", [CLController sharedInstance].locationManager.location.coordinate.longitude] forKey:@"longitude"];
	
	[request startAsynchronous];
	
	[pool release];
}

- (void)newLocationUpdate:(NSString *)text {
	
}

- (void)newError:(NSString *)text {
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(textField == captionTextField)
	{
		[tagsTextField becomeFirstResponder];
	}
	else {
		[textField resignFirstResponder];
	}
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[captionTextField resignFirstResponder];
	[tagsTextField resignFirstResponder];
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

- (void)hudWasHidden {
	
}


- (void)dealloc {
    [super dealloc];
}


@end
