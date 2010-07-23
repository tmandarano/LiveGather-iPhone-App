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


- (NSArray *)getLiveFeed:(int)numPhotos {
	NSLog(@"GETTING");
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/recent/%d", numPhotos]]];
	[request setHTTPMethod:@"GET"];
	[request setValue:nil forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"LiveGather-for-iPhone-V0.1" forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:nil];
	NSError *err;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
	NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
	NSLog(@"%@", response);
		
	NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[self parseJSONResponse:response]];
		
	NSArray *arr = [[NSArray alloc] initWithArray:returnArray];
	
	return arr;
}

- (NSArray *)getPhotosNear:(float)longitude andLatitude:(float)latitude {
	/*NSLog(@"GETTING");
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/recent/%d", numPhotos]]];
	[request setHTTPMethod:@"GET"];
	[request setValue:nil forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"LiveGather-for-iPhone-V0.1" forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:nil];
	NSError *err;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
	NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
	NSLog(@"%@", response);
	
	NSDictionary *dictionary = [response JSONValue];
	
	//po*/
	NSArray *array;
	return array;
}

- (NSArray *)getUserInformation {
	NSArray *array;
	return array;
}

- (void)editUser {
	
}

- (UIImage *)getUserProfilePhoto:(NSString *)userID {
	UIImage *image;
	return image;
}

- (NSArray *)getPhotoInformation:(NSString *)photoID {
	NSLog(@"GETTING");
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/%@", photoID]]];
	[request setHTTPMethod:@"GET"];
	[request setValue:nil forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"LiveGather-for-iPhone-V0.1" forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:nil];
	NSError *err;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
	NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
	NSLog(@"%@", response);
	
	//NSDictionary *dictionary = [response JSONValue];
	
	NSArray *array;
	return array;
}

- (NSArray *)fetchMorePhotos:(int)howManyWeHave andWith:(int)howManyWeWant {
	NSArray *array;
	return array;
}

- (void)sendPostDataToServer:(NSData *)data toServer:(NSString *)server {
	
}

- (NSArray *)parseJSONResponse:(NSString *)response {
	NSMutableArray *returnArray = [NSMutableArray new];
	
	NSArray *objects = (NSArray*)[response JSONValue];
	
	for(NSDictionary *dict in objects) {
		LGPhoto *photo = [[LGPhoto alloc] init];
		
		NSString *ID = (NSString *) [dict objectForKey:@"id"];
		NSString *name = (NSString *) [dict objectForKey:@"name"];
		NSString *URL = (NSString *) [dict objectForKey:@"url"];
		NSString *userID = (NSString *) [dict objectForKey:@"userid"];
		NSString *latitude = (NSString *) [dict objectForKey:@"latitude"];
		NSString *longitude = (NSString *) [dict objectForKey:@"longitude"];
		NSString *caption = (NSString *) [dict objectForKey:@"caption"];
		NSString *dateAdded = (NSString *) [dict objectForKey:@"date_added"];
		NSArray *tags = (NSArray *) [dict objectForKey: @"tags"];
		
		[photo setID:ID];
		[photo setPhotoName:name];
		[photo setPhotoURL:URL];
		[photo setPhotoUserID:userID];
		[photo setPhotoLocation:latitude withLong:longitude];
		[photo setPhotoCaption:caption];
		[photo setPhotoDateAdded:dateAdded];
		[photo setPhotoTags:tags];
		
		[returnArray addObject:photo];
		
		for(NSDictionary *tag in tags) {
			//NSString *tag_id = (NSString *) [tag objectForKey:@"id"];
			//NSString *tag_name = (NSString *) [tag objectForKey:@"tag"];
		}
		
	}
	
	NSArray *arr = [[NSArray alloc] initWithArray:returnArray];
	
	return arr;
}

- (BOOL)loginUser:(NSString *)usernameCredential withPassword:(NSString *)passwordCredential {
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
