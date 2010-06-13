//
//  LiveGatherAPI.m
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LiveGatherAPI.h"

@interface LiveGatherAPI()

- (void)sendPostDataToServer:(NSData *)data toServer:(NSString *)server;

@end

@implementation LiveGatherAPI


- (void)getImageInfo:(NSString *)imageID {
	
}

- (NSArray *)getLiveFeed:(int)numPhotos {
	/*RestConnection *getLiveStreamRestConnection;
	getLiveStreamRestConnection = [RestConnection new];
	getLiveStreamRestConnection.baseURLString = @"http://dev.livegather.com/photos/recent";
	getLiveStreamRestConnection.delegate = self;
	
	NSString *urlScheme = [NSString stringWithFormat:@"number=%d", numPhotos];
	urlScheme = [urlScheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[getLiveStreamRestConnection performRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlScheme]]];*/
	
	NSArray *array;
	return array;
}

- (NSArray *)getUserInformation {
	NSArray *array;
	return array;
}

- (void)registerUser:(NSString *)desiredUsername withPassword:(NSString *)password andEmail:(NSString *)emailAddr andDateOfBirth:(NSString *)dob {
	/*RestConnection *registerUserRestConnection;
	registerUserRestConnection = [RestConnection new];
	registerUserRestConnection.baseURLString = @"http://dev.livegather.com/users/create";
	registerUserRestConnection.delegate = self;
	
	NSString *usernameStringForServer = [desiredUsername stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *passwordStringForServer = [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *emailStringforServer = [emailAddr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *dateOfBirthStringForServer = [dob stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSString *urlScheme = [NSString stringWithFormat:@"username=%@&password=%@&email=%@&date_of_birth=%@",usernameStringForServer, passwordStringForServer, emailStringforServer, dateOfBirthStringForServer];
	
	[registerUserRestConnection performRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlScheme]]];*/
}

- (void)editUser {
	
}

- (UIImage *)getUserProfilePhoto:(NSString *)userID {
	UIImage *image;
	return image;
}

- (NSArray *)getPhotoInformation:(NSString *)photoID {
	NSArray *array;
	return array;
}

- (NSArray *)fetchMorePhotos:(int)howManyWeHave andWith:(int)howManyWeWant {
	NSArray *array;
	return array;
}

- (void)sendPostDataToServer:(NSData *)data toServer:(NSString *)server {
	
}

- (BOOL)loginUser:(NSString *)usernameCredential withPassword:(NSString *)passwordCredential {
	/*RestConnection *loginUserRestConnection;
	loginUserRestConnection = [RestConnection new];
	loginUserRestConnection.baseURLString = @"http://dev.livegather.com/sessions/create";
	loginUserRestConnection.delegate = self;
	
	NSString *usernameStringForServer = [usernameCredential stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *passwordStringForServer = [passwordCredential stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSString *urlScheme = [NSString stringWithFormat:@"username=%@&password=%@",usernameStringForServer, passwordStringForServer];
	
	[loginUserRestConnection performRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlScheme]]];
	
	//BOOL success;	
	return YES;*/
	
	NSMutableData *postData = [NSMutableData data];
	NSString *email = @"alexander@xandernet.net";
	NSString *location = @"";
	[postData appendData:[[NSString stringWithFormat:@"username=%@&email=%@&password=%@&location=%@", 
						   [usernameCredential stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
						   [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
						   [passwordCredential stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
						   [location stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] 
						  dataUsingEncoding:NSUTF8StringEncoding]];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:@"http://dev.livegather.com/users/create"]];
	[request setHTTPMethod:@"GET"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"LiveGather-for-iPhone-V0.1" forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:postData];
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
	NSLog(@"%@", response);
}

@end
