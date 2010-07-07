//
//  LiveGatherAPI.h
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface LiveGatherAPI : NSObject {
	NSArray *photosFeed;
}

- (BOOL)loginUser:(NSString *)usernameCredential withPassword:(NSString *)passwordCredential;
- (NSArray *)getLiveFeed:(int)numPhotos;
- (NSArray *)getPhotosNear:(float)longitude andLatitude:(float)latitude;
- (NSArray *)getUserInformation;
- (void)editUser;
- (UIImage *)getUserProfilePhoto:(NSString *)userID;
- (NSArray *)getPhotoInformation:(NSString *)photoID;
- (NSArray *)fetchMorePhotos:(int)howManyWeHave andWith:(int)howManyWeWant;

@end
