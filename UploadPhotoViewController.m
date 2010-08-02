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
	}
	else {
		UIActionSheet *userImagePickerType = [[UIActionSheet alloc] initWithTitle:@"Upload Photo From:"
																		 delegate:self
																cancelButtonTitle:@"Cancel"
														   destructiveButtonTitle:nil
																otherButtonTitles:nil];
		[userImagePickerType addButtonWithTitle:@"Photo Library"];
		[userImagePickerType showInView:self.view];
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
	//Begin uploading the photo itself to the service
	
	NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
	NSString *urlString = @"http://projc:pr0j(@dev.livegather.com/api/photos/create";
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"userfile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:body];
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	
	[self performSelectorOnMainThread:@selector(imageFinishedUploadingToServer:) withObject:returnString waitUntilDone:NO];
	
	[pool release];
}

- (void)imageFinishedUploadingToServer:(NSString *)serverResponse {
	NSLog(@"%@", serverResponse);
}

- (IBAction)upload {
	
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
