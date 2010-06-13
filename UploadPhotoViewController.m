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

//Custom Methods

- (void)getPhotoForUpload:(UIImage *)image {
	[imagePreview setImage:image];
}

- (IBAction)cancel {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)upload {
	NSData *imageData = UIImageJPEGRepresentation(imagePreview.image, 90);
	
	NSString *urlString = @"http://dev.livegather.com/photos/create";
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 */
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
}

- (IBAction)privacySelectionButtonPressed {
	UIAlertView *privacySelectorAlert = [[UIAlertView alloc] initWithTitle:@"Who can see this?"
																   message:@"Who is this photo viewable by?"
																  delegate:self
														 cancelButtonTitle:@"Cancel"
														 otherButtonTitles:nil];
	[privacySelectorAlert addButtonWithTitle:@"Everyone"];
	[privacySelectorAlert addButtonWithTitle:@"Only Friends"];
	[privacySelectorAlert addButtonWithTitle:@"Only People Watching Me"];
	privacySelectorAlert.tag = kPrivacyAlertTag;
	[privacySelectorAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == kPrivacyAlertTag)
	{
		switch (buttonIndex) {
			case 1:
				[privacySelectionLabel setText:@"Everyone"];
				break;
			case 2:
				[privacySelectionLabel setText:@"Only Friends"];
				break;
			case 3:
				[privacySelectionLabel setText:@"Only People Watching Me"];
				break;
			default:
				break;
		}
		
	}
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
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 100, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 100, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if([captionTextField isFirstResponder] || [tagsTextField isFirstResponder])
	{
		[captionTextField resignFirstResponder];
		[tagsTextField resignFirstResponder];
	}
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
