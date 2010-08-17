//
//  ResourceManager.m
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResourceManager.h"


@implementation ResourceManager

- (void)playSoundWithFileName:(NSString *)filename {
	
}

- (UIImage *)getImageFromBundleWithName:(NSString *)imageName {
	//UIImage *image;
	return nil;
}

- (UIImage *)downloadImageFromURL:(NSString *)url {
	//UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", url]]]];
	return nil;
}

- (BOOL)doesFileExistInBundle:(NSString *)filename {
	//NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	//return [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",documentsDirectory, filename]];
	if([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",filename]]])
	{
		return YES;
	}
	else {
		return NO;
	}
}

@end
