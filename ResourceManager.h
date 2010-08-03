//
//  ResourceManager.h
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceManager : NSObject {

}

- (void)playSoundWithFileName:(NSString *)filename;
- (UIImage *)getImageFromBundleWithName:(NSString *)imageName;
- (UIImage *)downloadImageFromURL:(NSString *)url;
- (BOOL)doesFileExistInBundle:(NSString *)filename;


@end
