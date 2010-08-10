//
//  LiveGatherAPI.m
//  LiveGather
// 
//  Created by Alexander on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LiveGatherAPI.h"

@interface LiveGatherAPI()
//Internal private methods
- (NSArray *)parseJSONPhotoResponse:(NSString *)response;
- (NSArray *)parseTagsResponse:(NSString *)response;

@end

@implementation LiveGatherAPI

#define kAppUserAgent "LiveGather-for-iPhone-V0.1"

- (NSArray *)getLiveFeed:(int)numPhotos {
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
		
	NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[self parseJSONPhotoResponse:response]];
		
	NSArray *arr = [[NSArray alloc] initWithArray:returnArray];
	
	return arr;
}

- (NSArray *)getPhotosNearCurrentLocationWithRadius:(float)radius orUseDefaultRadius:(BOOL)defaultRadius {
    NSArray *arr;
    return arr;
}

- (NSArray *)getPhotosNearLocationWithLatitude:(float)latitude andLongitude:(float)longitude usingDefaultRadius:(BOOL)defaultRadius orUsingRadius:(float)radius {
    NSArray *arr;
    return arr;
}

- (NSArray *)getTrendingTagsWithLimit:(int)limit {
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/tags/trending/%d", limit]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:nil forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"LivGather-for-iPhone-V0.1" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:nil];
    NSError *err;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
    NSLog(@"%@", response);
	
	NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[self parseTagsResponse:response]];
	
	NSArray *arr = [[NSArray alloc] initWithArray:returnArray];
	
	return arr;
}

- (NSArray *)getRecentTagsWithLimit:(int)limit {
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/tags/recent/%d", limit]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:nil forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"LivGather-for-iPhone-V0.1" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:nil];
    NSError *err;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
    NSLog(@"%@", response);
    
    NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[self parseTagsResponse:response]];
	
	NSArray *arr = [[NSArray alloc] initWithArray:returnArray];
	
	return arr;
}

- (LGPhoto *)getPhotoForID:(int)photoID {
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/%d", photoID]]];
	[request setHTTPMethod:@"GET"];
	[request setValue:nil forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"LiveGather-for-iPhone-V0.1" forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:nil];
	NSError *err;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
	NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
	NSLog(@"%@", response);
	
	NSDictionary *dict = [response JSONValue];
	
	LGPhoto *photo = [[LGPhoto alloc] init];
	
	NSString *name = (NSString *) [dict objectForKey:@"name"];
	NSString *userID = (NSString *) [dict objectForKey:@"user_id"];
	NSString *latitude = (NSString *) [dict objectForKey:@"latitude"];
	NSString *longitude = (NSString *) [dict objectForKey:@"longitude"];
	NSString *caption = (NSString *) [dict objectForKey:@"caption"];
	NSString *dateAdded = (NSString *) [dict objectForKey:@"date_added"];
	NSMutableArray *photoTags = [NSMutableArray new];
	NSArray *tags = (NSArray *) [dict objectForKey:@"tags"];
	
	for (NSDictionary *tag in tags) {
		LGTag *photoTag = [[LGTag alloc] init];
		NSString *tag_id = (NSString *) [tag objectForKey:@"id"];
		NSString *tagName = (NSString *) [tag objectForKey:@"tag"];
		[photoTag setTag:tagName];
		[photoTag setTagID:tag_id];
		[photoTags addObject:photoTag];
	}
	
	[photo setPhotoName:name];
	[photo setPhotoUserID:userID];
	[photo setPhotoLocation:latitude withLong:longitude];
	[photo setPhotoCaption:caption];
	[photo setPhotoDateAdded:dateAdded];
	[photo setPhotoTags:[NSArray arrayWithArray:photoTags]];
	
	return photo;
	
	[photo release];
}

- (LGUser *)getUserForID:(int)userID {
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/users/%d", userID]]];
	[request setHTTPMethod:@"GET"];
	[request setValue:nil forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"LiveGather-for-iPhone-V0.1" forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:nil];
	NSError *err;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
	NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
	NSLog(@"%@", response);
	
	NSDictionary *dict = [response JSONValue];
	
	LGUser *user = [[LGUser alloc] init];
	
	NSString *ID = (NSString *) [dict objectForKey:@"id"];
	NSString *username = (NSString *) [dict objectForKey:@"username"];
	NSString *emailAddress = (NSString *) [dict objectForKey:@"email"];
	NSString *imageURL = (NSString *) [dict objectForKey:@"photo_url"];
	
	[user setUserID:ID];
	[user setUsername:username];
	[user setEmailAddress:emailAddress];
	[user setImageURL:imageURL];
	
	return user;
	
	[user release];
}

- (NSArray *)getPhotosByTagID:(int)tagID {
    NSArray *arr;
    return arr;
}

- (NSString *)reverseGeocodeCoordinatesWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude {
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@,%@&output=json&sensor=true_or_false", latitude, longitude]]];
	[request setHTTPMethod:@"GET"];
	[request setValue:nil forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"LiveGather-for-iPhone-V0.1" forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:nil];
	NSError *err;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
	NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
	NSLog(@"%@", response);
		
	return @"";
}

- (NSArray *)parseJSONPhotoResponse:(NSString *)response {
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
		NSMutableArray *photoTags = [NSMutableArray new];
		NSArray *tags = (NSArray *) [dict objectForKey:@"tags"];
		
		for (NSDictionary *tag in tags) {
			LGTag *photoTag = [[LGTag alloc] init];
			NSString *tag_id = (NSString *) [tag objectForKey:@"id"];
			NSString *tagName = (NSString *) [tag objectForKey:@"tag"];
			[photoTag setTag:tagName];
			[photoTag setTagID:tag_id];
			[photoTags addObject:photoTag];
		}
		
		NSLog(@"Processing Photo: %@", ID);
		
		[photo setID:[ID intValue]];
		[photo setPhotoName:name];
		[photo setPhotoURL:URL];
		[photo setPhotoUserID:userID];
		[photo setPhotoLocation:latitude withLong:longitude];
		[photo setPhotoCaption:caption];
		[photo setPhotoDateAdded:dateAdded];
		[photo setPhotoTags:[NSArray arrayWithArray:photoTags]];
		
		[returnArray addObject:photo];
        
        [photo release];
		
	}
	
	NSArray *arr = [[NSArray alloc] initWithArray:returnArray];
	
    [returnArray release];
    
	return arr;
}

- (NSArray *)parseTagsResponse:(NSString *)response {
	NSMutableArray *returnArray = [NSMutableArray new];
    
    NSArray *objects = (NSArray*)[response JSONValue];
    
    for(NSDictionary *dict in objects) {
		LGTag *tag = [[LGTag alloc] init];
		
        NSString *tagID = (NSString *) [dict objectForKey:@"id"];
        NSString *tagName = (NSString *) [dict objectForKey:@"tag"];
        NSString *dateAdded = (NSString *) [dict objectForKey:@"date_added"];
		
		NSLog(@"Processing Tag: %@", tagName);
		
		[tag setTag:tagName];
		[tag setTagID:tagID];
		[tag setDateAdded:dateAdded];
		
		[returnArray addObject:tag];
    }
    
    NSArray *arr = [[NSArray alloc] initWithArray:returnArray];
    return arr;
}

@end
