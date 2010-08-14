//
//  LGPhoto.h
//  LiveGather
//
//  Created by Alexander on 7/23/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGTag.h"
#import "LGUser.h"

@class LGTag;

@interface LGPhoto : UIImage {
	int			photoID;
	NSString	*photoURL;
	NSString	*photoName;
	NSString	*photoLocationLatitude;
	NSString	*photoLocationLongitude;
	NSString	*photoAddress;
	NSString	*photoLocation;
	NSString	*photoCaption;
	NSArray		*photoTags;
	LGUser		*photoUser;
	NSString	*photoDateAdded;
	NSString	*photoUserID;
	NSString	*photoPath;
	int			photoIndex;
}

@property (nonatomic) int photoID;
@property (nonatomic, retain) NSString *photoURL;
@property (nonatomic, retain) NSString *photoName;
@property (nonatomic, retain) NSString *photoLocationLatitude;
@property (nonatomic, retain) NSString *photoLocationLongitude;
@property (nonatomic, retain) NSString *photoAddress;
@property (nonatomic, retain) NSString *photoLocation;
@property (nonatomic, retain) NSString *photoCaption;
@property (nonatomic, retain) NSArray *photoTags;
@property (nonatomic, retain) LGUser *photoUser;
@property (nonatomic, retain) NSString *photoDateAdded;
@property (nonatomic, retain) NSString *photoUserID;
@property (nonatomic, retain) NSString *photoPath;
@property (nonatomic) int photoIndex;

/*Getters and setters

- (int)photoID;
- (void)setID:(int)ID;

- (void)setPhotoIndex:(int)index;
- (int)photoIndex;

- (NSString *)photoURL;
- (void)setPhotoURL:(NSString *)url;

- (NSString *)photoName;
- (void)setPhotoName:(NSString *)name;

- (NSString *)photoLocationLatitude;
- (NSString *)photoLocationLongitude;
- (void)setPhotoLocation:(NSString *)latitude withLong:(NSString *)longitude;
- (NSString *)photoLocation;
- (void)setPhotoLocation:(NSString *)location;

- (NSString *)photoAddress;
- (void)setPhotoAddress:(NSString *)address;

- (NSString *)photoCaption;
- (void)setPhotoCaption:(NSString *)caption;

- (LGUser *)photoUser;
- (void)setPhotoUser:(LGUser *)user;

- (NSArray *)photoTags;
- (void)setPhotoTags:(NSArray *)tags;

- (NSString *)photoDateAdded;
- (void)setPhotoDateAdded:(NSString *)dateAdded;

- (NSString *)photoUserID;
- (void)setPhotoUserID:(NSString *)userid;

- (NSString *)photoPath;
- (void)setPhotoPath:(NSString *)path;*/

@end
