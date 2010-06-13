//
//  LiveGatherAPI.h
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveGatherAPI : NSObject {

}

- (BOOL)loginUser:(NSString *)usernameCredential withPassword:(NSString *)passwordCredential;
- (void)getImageInfo:(NSString *)imageID;
- (NSArray *)getLiveFeed:(int)numPhotos;
- (NSArray *)getUserInformation;
- (void)registerUser:(NSString *)desiredUsername withPassword:(NSString *)password andEmail:(NSString *)emailAddr andDateOfBirth:(NSString *)dob;
- (void)editUser;
- (UIImage *)getUserProfilePhoto:(NSString *)userID;
- (NSArray *)getPhotoInformation:(NSString *)photoID;
- (NSArray *)fetchMorePhotos:(int)howManyWeHave andWith:(int)howManyWeWant;

@end
