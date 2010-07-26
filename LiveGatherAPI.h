//
//  LiveGatherAPI.h
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "JRAuthenticate.h"
#import "LGPhoto.h"
#import "LGTag.h"

@interface LiveGatherAPI : NSObject {
    
}

//Handling APIs on the server
- (NSArray *)getLiveFeed:(int)numPhotos;
- (NSArray *)getPhotosNearCurrentLocationWithRadius:(float)radius orUseDefaultRadius:(BOOL)defaultRadius;
- (NSArray *)getPhotosNearLocationWithLatitude:(float)latitude andLongitude:(float)longitude usingDefaultRadius:(BOOL)defaultRadius orUsingRadius:(float)radius;
- (NSArray *)getTrendingTagsWithLimit:(int)limit;
- (NSArray *)getRecentTagsWithLimit:(int)limit;
- (NSArray *)getPhotosByTagID:(int)id;

@end
