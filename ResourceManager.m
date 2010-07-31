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
	UIImage *image;
	return image;
}

- (void)saveImageToDocuments:(UIImage *)image withFilename:(NSString *)filename andFileType:(NSString *)filetype {
	NSLog(@"TEST");
	if(filetype == @"PNG")
	{
		NSLog(@"TESTPNG");
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png", documentsDirectory, filename];
		NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
		[imageData writeToFile:imagePath atomically:YES];
	}
	else if(filetype == @"JPEG")
	{
		NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *imagePath = [NSString stringWithFormat:@"%@/%@.jpeg",documentsDirectory, filename];
		NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
		[imageData writeToFile:imagePath atomically:YES];
	}
}

- (UIImage *)downloadImageFromURL:(NSString *)url {
	UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", url]]]];
	return image;
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
