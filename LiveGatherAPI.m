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

- (NSString *)getCachedImageJSONFromSQL:(int)imgID;
- (NSString *)getCachedUserJSONFromSQL:(int)userID;

- (BOOL)addJSONCacheForImageID:(int)imgID andData:(NSString *)json;
- (BOOL)addJSONCacheForUserID:(int)userID andData:(NSString *)json;

- (void)createEditableJSONSQLCacheIfNeeded;
- (void)createEditableImageFilesSQLCacheIfNeeded;

@end

@implementation LiveGatherAPI

#define kAppUserAgent @"LiveGather-for-iPhone-V0.1"

- (id)init {
	if(self = [super init])
	{
		[self createEditableJSONSQLCacheIfNeeded];
		[self createEditableImageFilesSQLCacheIfNeeded];
	}
	
	return self;
}

- (NSArray *)getLiveFeed:(int)numPhotos {
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/recent/%d", numPhotos]]];
	[request setHTTPMethod:@"GET"];
	[request setValue:nil forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:kAppUserAgent forHTTPHeaderField:@"User-Agent"];
	[request setHTTPBody:nil];
	NSError *err;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
	NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
	
	NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[self parseJSONPhotoResponse:response]];
		
	NSArray *arr = [[NSArray alloc] initWithArray:returnArray];
			
	return [arr autorelease];
}

- (NSArray *)getPhotosNearCurrentLocationWithRadius:(float)radius orUseDefaultRadius:(BOOL)defaultRadius {
    //NSArray *arr;
    return nil;
}

- (NSArray *)getPhotosNearLocationWithLatitude:(float)latitude andLongitude:(float)longitude usingDefaultRadius:(BOOL)defaultRadius orUsingRadius:(float)radius {
    //NSArray *arr;
    return nil;
}

- (NSArray *)getTrendingTagsWithLimit:(int)limit {
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/tags/trending/%d", limit]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:nil forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:kAppUserAgent forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:nil];
    NSError *err;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
	
	NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[self parseTagsResponse:response]];
	
	NSArray *arr = [[NSArray alloc] initWithArray:returnArray];
	
	return [arr autorelease];
}

- (NSArray *)getRecentTagsWithLimit:(int)limit {
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/tags/recent/%d", limit]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:nil forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:kAppUserAgent forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:nil];
    NSError *err;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
    
    NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[self parseTagsResponse:response]];
	
	NSArray *arr = [[NSArray alloc] initWithArray:returnArray];
	
	return [arr autorelease];
}

- (LGPhoto *)getPhotoForID:(int)photoID {
	if ([self getCachedImageJSONFromSQL:photoID] == nil) {
		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
		[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/%d", photoID]]];
		[request setHTTPMethod:@"GET"];
		[request setValue:nil forHTTPHeaderField:@"Content-Length"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[request setValue:kAppUserAgent forHTTPHeaderField:@"User-Agent"];
		[request setHTTPBody:nil];
		NSError *err;
		NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
		NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
		
		NSDictionary *dict = [response JSONValue];
		
		LGPhoto *photo = [[LGPhoto alloc] init];
		
		NSString *name = (NSString *) [dict objectForKey:@"name"];
		NSString *userID = (NSString *) [dict objectForKey:@"user_id"];
		NSString *latitude = (NSString *) [dict objectForKey:@"latitude"];
		NSString *longitude = (NSString *) [dict objectForKey:@"longitude"];
		NSString *caption = (NSString *) [dict objectForKey:@"caption"];
		NSString *dateAdded = (NSString *) [dict objectForKey:@"date_added"];
		NSString *photoURL = (NSString *) [dict objectForKey:@"url"];
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
		
		[photo setPhotoJSON:response];
		[photo setPhotoName:name];
		[photo setPhotoUserID:userID];
		[photo setPhotoUser:user];
		[photo setPhotoFileID:[photoURL stringByReplacingOccurrencesOfString:@"/photos/" withString:@""]];
		[photo setPhotoLocationLatitude:latitude];
		[photo setPhotoLocationLongitude:longitude];
		[photo setPhotoLocation:[NSString stringWithFormat:@"%@, %@", latitude, longitude]];
		[photo setPhotoCaption:caption];
		[photo setPhotoDateAdded:dateAdded];
		[photo setPhotoTags:[NSArray arrayWithArray:photoTags]];
		
		/************************INSERT CACHE TO SQL***********************/
		[self addJSONCacheForImageID:photoID andData:response];
		/************************INSERT CACHE TO SQL***********************/
		
		
		/************************MEMORY FIX HERE***************************/
		[photoTags release];
		[response release];
		/************************MEMORY FIX HERE***************************/
		
		return [photo autorelease];		
	}
	else {
		NSString *imageJSON = [self getCachedImageJSONFromSQL:photoID];
		
		NSDictionary *dict = [imageJSON JSONValue];
		
		LGPhoto *photo = [[LGPhoto alloc] init];
		
		NSString *name = (NSString *) [dict objectForKey:@"name"];
		NSString *userID = (NSString *) [dict objectForKey:@"user_id"];
		NSString *latitude = (NSString *) [dict objectForKey:@"latitude"];
		NSString *longitude = (NSString *) [dict objectForKey:@"longitude"];
		NSString *caption = (NSString *) [dict objectForKey:@"caption"];
		NSString *dateAdded = (NSString *) [dict objectForKey:@"date_added"];
		NSString *photoURL = (NSString *) [dict objectForKey:@"url"];
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
		
		[photo setPhotoJSON:imageJSON];
		[photo setPhotoName:name];
		[photo setPhotoUserID:userID];
		[photo setPhotoUser:user];
		[photo setPhotoFileID:[photoURL stringByReplacingOccurrencesOfString:@"/photos/" withString:@""]];
		[photo setPhotoLocationLatitude:latitude];
		[photo setPhotoLocationLongitude:longitude];
		[photo setPhotoLocation:[NSString stringWithFormat:@"%@, %@", latitude, longitude]];
		[photo setPhotoCaption:caption];
		[photo setPhotoDateAdded:dateAdded];
		[photo setPhotoTags:[NSArray arrayWithArray:photoTags]];
		
		/************************MEMORY FIX HERE***************************/
		[photoTags release];
		/************************MEMORY FIX HERE***************************/
		
		return [photo autorelease];
	}

}

- (LGUser *)getUserForID:(int)userID {
	
	if ([self getCachedUserJSONFromSQL:userID] == nil) {
		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
		[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/users/%d", userID]]];
		[request setHTTPMethod:@"GET"];
		[request setValue:nil forHTTPHeaderField:@"Content-Length"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[request setValue:kAppUserAgent forHTTPHeaderField:@"User-Agent"];
		[request setHTTPBody:nil];
		NSError *err;
		NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
		NSString *response = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
		
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
		
		return [user autorelease];
	}
	else {
		NSString *userJSON = [self getCachedUserJSONFromSQL:userID];
		
		NSDictionary *dict = [userJSON JSONValue];
		
		LGUser *user = [[LGUser alloc] init];
		
		NSString *ID = (NSString *) [dict objectForKey:@"id"];
		NSString *username = (NSString *) [dict objectForKey:@"username"];
		NSString *emailAddress = (NSString *) [dict objectForKey:@"email"];
		NSString *imageURL = (NSString *) [dict objectForKey:@"photo_url"];
		
		[user setUserID:ID];
		[user setUsername:username];
		[user setEmailAddress:emailAddress];
		[user setImageURL:imageURL];
		
		return [user autorelease];
	}

}

- (LGPhoto *)returnPhotoObjectFromJSON:(NSString *)json {	
	NSDictionary *dict = [json JSONValue];
	
	LGPhoto *photo = [[LGPhoto alloc] init];
	
	NSString *name = (NSString *) [dict objectForKey:@"name"];
	NSString *userID = (NSString *) [dict objectForKey:@"user_id"];
	NSString *latitude = (NSString *) [dict objectForKey:@"latitude"];
	NSString *longitude = (NSString *) [dict objectForKey:@"longitude"];
	NSString *caption = (NSString *) [dict objectForKey:@"caption"];
	NSString *dateAdded = (NSString *) [dict objectForKey:@"date_added"];
	NSString *photoURL = (NSString *) [dict objectForKey:@"url"];
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
	
	[photo setPhotoJSON:json];
	[photo setPhotoName:name];
	[photo setPhotoUserID:userID];
	[photo setPhotoUser:user];
	[photo setPhotoFileID:[photoURL stringByReplacingOccurrencesOfString:@"/photos/" withString:@""]];
	[photo setPhotoLocationLatitude:latitude];
	[photo setPhotoLocationLongitude:longitude];
	[photo setPhotoLocation:[NSString stringWithFormat:@"%@, %@", latitude, longitude]];
	[photo setPhotoCaption:caption];
	[photo setPhotoDateAdded:dateAdded];
	[photo setPhotoTags:[NSArray arrayWithArray:photoTags]];
	
	/************************MEMORY FIX HERE***************************/
	[photoTags release];
	/************************MEMORY FIX HERE***************************/
	
	return [photo autorelease];
}

- (NSArray *)getPhotosByTagID:(int)tagID {
    //NSArray *arr;
    return nil;
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
		NSString *photoURL = (NSString *) [dict objectForKey:@"url"];
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
				
		[photo setPhotoJSON:response];
		[photo setPhotoID:[ID intValue]];
		[photo setPhotoName:name];
		[photo setPhotoFileID:[photoURL stringByReplacingOccurrencesOfString:@"/photos/" withString:@""]];
		[photo setPhotoUserID:userID];
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
    
	return [arr autorelease];
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
	[returnArray release];
    return [arr autorelease];
}

- (BOOL)deviceRequiresHighResPhotos {
	if ([[UIScreen mainScreen] scale] == 2.0) {
		return YES;
	}
	else {
		return NO;
	}

}

/* SQL Cache Access */

/* Files */
- (void)addImageFileToCacheWithID:(int)imgID andFilePath:(NSString *)imgPath andImageSize:(NSString *)imgSize {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imagesSQLCache = [documentsDirectory stringByAppendingPathComponent:@"image_files_cache.sqlite"];
	
	imagesSQLCacheDB = NULL;
	
	if(sqlite3_open([imagesSQLCache UTF8String], &imagesSQLCacheDB) == SQLITE_OK) {
		NSString *timestamp = [NSString stringWithFormat:@"%d", (long)[[NSDate date] timeIntervalSince1970]];
		const char* sql;
		
		if ([self imageFileCacheExistsInSQLWithID:imgID forSize:imgSize]) {
			if ([imgSize isEqualToString:@"s"]) {
				sql = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO small_preview_file(image_id, image_file_path, last_access_date) VALUES('%d', '%@', '%d');", imgID, imgPath, [timestamp intValue]] cStringUsingEncoding:NSUTF8StringEncoding];
			}
			else if([imgSize isEqualToString:@"m"]) {
				sql = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO medium_preview_file(image_id, image_file_path, last_access_date) VALUES('%d', '%@', '%d');", imgID, imgPath, [timestamp intValue]] cStringUsingEncoding:NSUTF8StringEncoding];
			}
			else if([imgSize isEqualToString:@"f"]) {
				sql = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO full_resolution_file(image_id, image_file_path, last_access_date) VALUES('%d', '%@', '%d');", imgID, imgPath, [timestamp intValue]] cStringUsingEncoding:NSUTF8StringEncoding];
			}
			else {
				return;
			}
		}
		else {
			if ([imgSize isEqualToString:@"s"]) {
				sql = [[NSString stringWithFormat:@"UPDATE small_preview_file SET last_access_date = '%d' WHERE image_id = '%d'", imgID, [timestamp intValue]] cStringUsingEncoding:NSUTF8StringEncoding];
			}
			else if([imgSize isEqualToString:@"m"]) {
				sql = [[NSString stringWithFormat:@"UPDATE medium_preview_file SET last_access_date = '%d' WHERE image_id = '%d'", imgID, [timestamp intValue]] cStringUsingEncoding:NSUTF8StringEncoding];
			}
			else if([imgSize isEqualToString:@"f"]) {
				sql = [[NSString stringWithFormat:@"UPDATE full_resolution_file SET last_access_date = '%d' WHERE image_id = '%d'", imgID, [timestamp intValue]] cStringUsingEncoding:NSUTF8StringEncoding];
			}
			else {
				return;
			}
		}
				
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(imagesSQLCacheDB, sql, -1, &statement, NULL) == SQLITE_OK)
		{
			NSLog(@"OK SQL");
			int result = sqlite3_step(statement);
			sqlite3_reset(statement);
			NSLog(@"result %d", result);
			
			if(result != SQLITE_ERROR) {
				int lastInsertId =  sqlite3_last_insert_rowid(imagesSQLCacheDB);
				NSLog(@"x %d", lastInsertId);
			}
		}

	}
	sqlite3_close(imagesSQLCacheDB);
}

- (BOOL)imageFileCacheExistsInSQLWithID:(int)imgID forSize:(NSString *)imgSize {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imagesSQLCache = [documentsDirectory stringByAppendingPathComponent:@"image_files_cache.sqlite"];
	NSMutableArray *arrayForReturn = [NSMutableArray new];
	
	imagesSQLCacheDB = NULL;
	
	if (sqlite3_open([imagesSQLCache UTF8String], &imagesSQLCacheDB) == SQLITE_OK) {
		NSString *queryString;
		
		if ([imgSize isEqualToString:@"s"]) {
			queryString = [NSString stringWithFormat:@"select image_id from small_preview_file where image_id = %d", imgID];
		}
		else if([imgSize isEqualToString:@"m"]) {
			queryString = [NSString stringWithFormat:@"select image_id from medium_preview_file where image_id = %d", imgID];
		}
		else if([imgSize isEqualToString:@"f"]) {
			queryString = [NSString stringWithFormat:@"select image_id from full_resolution_file where image_id = %d", imgID];
		}
		
		const char *sqlStatement = [queryString UTF8String];
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare(imagesSQLCacheDB, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			NSLog(@"OK SQL");
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				NSString *image_data = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				[arrayForReturn addObject:image_data];
			}
		}
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(imagesSQLCacheDB);
	
	if ([arrayForReturn count] > 0) {
		NSLog(@"YEP");
		[arrayForReturn release];
		return YES;
	}
	else {
		NSLog(@"NOPE");
		[arrayForReturn release];
		return NO;
	}
}

- (NSString *)getFilePathForCachedImageWithID:(int)imgID andSize:(NSString *)imgSize {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imagesSQLCache = [documentsDirectory stringByAppendingPathComponent:@"image_files_cache.sqlite"];
	NSMutableArray *arrayForReturn = [NSMutableArray new];
	
	imagesSQLCacheDB = NULL;
	
	if (sqlite3_open([imagesSQLCache UTF8String], &imagesSQLCacheDB) == SQLITE_OK) {
		NSString *queryString;
		
		if ([imgSize isEqualToString:@"s"]) {
			queryString = [NSString stringWithFormat:@"select image_file_path from small_preview_file where image_id = %d", imgID];
		}
		else if([imgSize isEqualToString:@"m"]) {
			queryString = [NSString stringWithFormat:@"select image_file_path from medium_preview_file where image_id = %d", imgID];
		}
		else if([imgSize isEqualToString:@"f"]) {
			queryString = [NSString stringWithFormat:@"select image_file_path from full_resolution_file where image_id = %d", imgID];
		}
				
		const char *sqlStatement = [queryString UTF8String];
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare(imagesSQLCacheDB, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				NSString *image_path = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				[arrayForReturn addObject:image_path];
			}
		}
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(imagesSQLCacheDB);
	
	if ([arrayForReturn count] == 1) {
		return [arrayForReturn objectAtIndex:0];
	}
	else {
		[arrayForReturn release];
		return nil;
	}
}

/* JSON */
- (NSString *)getCachedImageJSONFromSQL:(int)imgID {	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imagesSQLCache = [documentsDirectory stringByAppendingPathComponent:@"json_cache.sqlite"];
	NSMutableArray *arrayForReturn = [NSMutableArray new];
	
	imagesSQLCacheDB = NULL;
	
	if (sqlite3_open([imagesSQLCache UTF8String], &imagesSQLCacheDB) == SQLITE_OK) {
		NSString *queryString = [NSString stringWithFormat:@"select image_data from image_cache where image_id = %d", imgID];
		const char *sqlStatement = [queryString UTF8String];
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare(imagesSQLCacheDB, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				NSString *image_data = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				[arrayForReturn addObject:image_data];
			}
		}
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(imagesSQLCacheDB);
	
	if ([arrayForReturn count] == 1) {
		return [arrayForReturn objectAtIndex:0];
	}
	else {
		[arrayForReturn release];
		return nil;
	}
}

- (NSString *)getCachedUserJSONFromSQL:(int)userID {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *usersSQLCache = [documentsDirectory stringByAppendingPathComponent:@"json_cache.sqlite"];
	NSMutableArray *arrayForReturn = [NSMutableArray new];
	
	usersSQLCacheDB = NULL;

	if (sqlite3_open([usersSQLCache UTF8String], &usersSQLCacheDB) == SQLITE_OK) {
		NSString *queryString = [NSString stringWithFormat:@"select user_data from user_cache where user_id = %d", userID	];
		const char *sqlStatement = [queryString UTF8String];
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare(imagesSQLCacheDB, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
				NSString *user_data = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				[arrayForReturn addObject:user_data];
			}
		}
		
		sqlite3_finalize(compiledStatement);
	}
	
	sqlite3_close(usersSQLCacheDB);
	
	if ([arrayForReturn count] == 1) {
		return [arrayForReturn objectAtIndex:0];
	}
	else {
		[arrayForReturn release];
		return nil;
	}
}

- (BOOL)addJSONCacheForImageID:(int)imgID andData:(NSString *)json {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imagesSQLCache = [documentsDirectory stringByAppendingPathComponent:@"json_cache.sqlite"];
	
	imagesSQLCacheDB = NULL;
	
	if(sqlite3_open([imagesSQLCache UTF8String], &imagesSQLCacheDB) == SQLITE_OK) {
		
		const char* sql = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO image_cache(image_id, image_data) VALUES('%d', '%@');", imgID, json] cStringUsingEncoding:NSUTF8StringEncoding];
		
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(imagesSQLCacheDB, sql, -1, &statement, NULL) == SQLITE_OK)
		{
			int result = sqlite3_step(statement);
			sqlite3_reset(statement);
			//NSLog(@"result %d", result);
			
			if(result != SQLITE_ERROR) {
				//int lastInsertId =  sqlite3_last_insert_rowid(imagesSQLCacheDB);
				//NSLog(@"x %d", lastInsertId);
			}
			
		}
	}
	sqlite3_close(imagesSQLCacheDB);
	
	return YES;
}

- (BOOL)addJSONCacheForUserID:(int)userID andData:(NSString *)json {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *usersSQLCache = [documentsDirectory stringByAppendingPathComponent:@"json_cache.sqlite"];
	
	usersSQLCacheDB = NULL;
	
	if(sqlite3_open([usersSQLCache UTF8String], &usersSQLCacheDB) == SQLITE_OK) {
		
		const char* sql = [[NSString stringWithFormat:@"INSERT OR REPLACE INTO user_cache(user_id, user_data) VALUES('%d', '%@');", userID, json] cStringUsingEncoding:NSUTF8StringEncoding];
		
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(usersSQLCacheDB, sql, -1, &statement, NULL) == SQLITE_OK)
		{
			int result = sqlite3_step(statement);
			sqlite3_reset(statement);
			//NSLog(@"result %d", result);
			
			if(result != SQLITE_ERROR) {
				//int lastInsertId =  sqlite3_last_insert_rowid(usersSQLCacheDB);
				//NSLog(@"x %d", lastInsertId);
			}
			
		}
	}
	sqlite3_close(usersSQLCacheDB);
	
	return YES;
}

- (void)createEditableJSONSQLCacheIfNeeded {
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"json_cache.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if(success) return;
	
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"json_cache.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (success) {
		
	}
}

- (void)createEditableImageFilesSQLCacheIfNeeded {
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"image_files_cache.sqlite"];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if(success) return;
	
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"image_files_cache.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (success) {
		
	}
}

- (void)dealloc {
	sqlite3_close(usersSQLCacheDB);
	sqlite3_close(imagesSQLCacheDB);
	[super dealloc];
}

@end
