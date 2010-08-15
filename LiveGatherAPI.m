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
- (NSString *)getCachedJSONForPhotoWithID:(int)photoID;

@end

@implementation LiveGatherAPI

#define kAppUserAgent "LiveGather-for-iPhone-V0.1"

- (id)init {
	
	if(self = [super init])
	{
		
	}
	
	return self;
}

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
	
	/************************MEMORY FIX HERE***************************/
	[response release];
	/************************MEMORY FIX HERE***************************/
	
	LGPhoto *photo = [[LGPhoto alloc] init];
	
	NSString *name = (NSString *) [dict objectForKey:@"name"];
	NSString *userID = (NSString *) [dict objectForKey:@"user_id"];
	NSString *latitude = (NSString *) [dict objectForKey:@"latitude"];
	NSString *longitude = (NSString *) [dict objectForKey:@"longitude"];
	NSString *caption = (NSString *) [dict objectForKey:@"caption"];
	NSString *dateAdded = (NSString *) [dict objectForKey:@"date_added"];
	NSMutableArray *photoTags = [NSMutableArray new];
	NSArray *tags = (NSArray *) [dict objectForKey:@"tags"];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	for (NSDictionary *tag in tags) {
		LGTag *photoTag = [[LGTag alloc] init];
		NSString *tag_id = (NSString *) [tag objectForKey:@"id"];
		NSString *tagName = (NSString *) [tag objectForKey:@"tag"];
		[photoTag setTag:tagName];
		[photoTag setID:tag_id];
		[photoTags addObject:photoTag];
		
		/************************MEMORY FIX HERE***************************/
		[photoTag release];
		/************************MEMORY FIX HERE***************************/
	}
	
	[pool release];
	
	LGUser *user = [self getUserForID:[userID intValue]];
	
	[photo setPhotoName:name];
	[photo setPhotoUserID:userID];
	[photo setPhotoUser:user];
	[photo setPhotoLocationLatitude:latitude];
	[photo setPhotoLocationLongitude:longitude];
	[photo setPhotoLocation:[NSString stringWithFormat:@"%@, %@", latitude, longitude]];
	[photo setPhotoCaption:caption];
	[photo setPhotoDateAdded:dateAdded];
	[photo setPhotoTags:[NSArray arrayWithArray:photoTags]];
	
	/************************MEMORY FIX HERE***************************/
	[photoTags release];
	/************************MEMORY FIX HERE***************************/
	
	return photo;
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
	
	/************************MEMORY FIX HERE***************************/
	[response release];
	/************************MEMORY FIX HERE***************************/
	
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

- (NSString *)getTimeSinceMySQLDate:(NSString *)sqlDate {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *convertedDate = [dateFormatter dateFromString:sqlDate];
    [dateFormatter release];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
    } else      if (ti < 60) {
        return @"Moments ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
		if (diff == 1) {
			return [NSString stringWithFormat:@"%d minute ago", diff];
		}
		else {
			return [NSString stringWithFormat:@"%d minutes ago", diff];
		}
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"never";
    }
}

- (NSString *)reverseGeocodeCoordinatesWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude {
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
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		for (NSDictionary *tag in tags) {
			LGTag *photoTag = [[LGTag alloc] init];
			NSString *tag_id = (NSString *) [tag objectForKey:@"id"];
			NSString *tagName = (NSString *) [tag objectForKey:@"tag"];
			[photoTag setTag:tagName];
			[photoTag setID:tag_id];
			[photoTags addObject:photoTag];
			
			/************************MEMORY FIX HERE***************************/
			[photoTag release];
			/************************MEMORY FIX HERE***************************/
		}
		
		[pool release];
		
		NSLog(@"Processing Photo: %@", ID);
		
		[photo setPhotoID:[ID intValue]];
		[photo setPhotoName:name];
		[photo setPhotoURL:URL];
		[photo setPhotoUserID:userID];
		//[photo setPhotoUser:[self getUserForID:[userID intValue]]];
		[photo setPhotoLocationLatitude:latitude];
		[photo setPhotoLocationLongitude:longitude];
		[photo setPhotoLocation:[NSString stringWithFormat:@"%@, %@", latitude, longitude]];
		[photo setPhotoCaption:caption];
		[photo setPhotoDateAdded:dateAdded];
		[photo setPhotoTags:[NSArray arrayWithArray:photoTags]];
		
		/************************MEMORY FIX HERE***************************/
		[photoTags release];
		/************************MEMORY FIX HERE***************************/
		
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
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    for(NSDictionary *dict in objects) {
		LGTag *tag = [[LGTag alloc] init];
		
        NSString *tagID = (NSString *) [dict objectForKey:@"id"];
        NSString *tagName = (NSString *) [dict objectForKey:@"tag"];
        NSString *dateAdded = (NSString *) [dict objectForKey:@"date_added"];
		
		NSLog(@"Processing Tag: %@", tagName);
		
		[tag setTag:tagName];
		[tag setID:tagID];
		[tag setDateAdded:dateAdded];
		
		[returnArray addObject:tag];
		
		/************************MEMORY FIX HERE***************************/
		[tag release];
		/************************MEMORY FIX HERE***************************/
    }
	
	[pool release];
    
    NSArray *arr = [[NSArray alloc] initWithArray:returnArray];
    return arr;
}

- (NSString *)getCachedJSONForPhotoWithID:(int)photoID {
	
}

@end
