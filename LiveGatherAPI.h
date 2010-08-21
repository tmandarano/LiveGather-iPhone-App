//
//  LiveGatherAPI.h
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "JSON.h"
#import "JRAuthenticate.h"
#import "LGPhoto.h"
#import "LGTag.h"
#import "LGUser.h"
#import "sqlite3.h"

@interface LiveGatherAPI : NSObject {
	
}

//Handling APIs on the server
- (NSArray *)getLiveFeed:(int)numPhotos;
- (NSArray *)getPhotosNearCurrentLocationWithRadius:(float)radius orUseDefaultRadius:(BOOL)defaultRadius;
- (NSArray *)getPhotosNearLocationWithLatitude:(float)latitude andLongitude:(float)longitude usingDefaultRadius:(BOOL)defaultRadius orUsingRadius:(float)radius;
- (NSArray *)getTrendingTagsWithLimit:(int)limit;
- (NSArray *)getRecentTagsWithLimit:(int)limit;
- (NSArray *)getPhotosByTagID:(int)tagID;
- (LGPhoto *)getPhotoForID:(int)photoID;
- (LGUser *)getUserForID:(int)userID;
- (LGPhoto *)returnPhotoObjectFromJSON:(NSString *)json;
- (NSString *)reverseGeocodeCoordinatesWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude;
- (NSString *)getTimeSinceMySQLDate:(NSString *)sqlDate;
- (BOOL)deviceRequiresHighResPhotos;
- (void)addImageFileToCacheWithID:(int)imgID andFilePath:(NSString *)imgPath andImageSize:(NSString *)imgSize;
- (NSString *)getFilePathForCachedImageWithID:(int)imgID andSize:(NSString *)size;
- (BOOL)imageFileCacheExistsInSQLWithID:(int)imgID forSize:(NSString *)imgSize;

@end
