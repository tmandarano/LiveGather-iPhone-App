//
//  ResourceManager.h
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserSettingUserUsername @"settings_username_credential"
#define kUserSettingUserPassword @"settings_password_credential"
#define kUserSettingUserFirstName @"settings_user_firstname"
#define kUserSettingUserLastName @"settings_user_lastname"

@interface ResourceManager : NSObject {

}

- (void)playSoundWithFileName:(NSString *)filename;
- (UIImage *)getImageFromBundleWithName:(NSString *)imageName;
- (void)saveImageToDocuments:(UIImage *)image withFilename:(NSString *)filename andFileType:(NSString *)filetype;
- (UIImage *)downloadImageFromURL:(NSString *)url;
- (BOOL)doesFileExistInBundle:(NSString *)filename;


@end
