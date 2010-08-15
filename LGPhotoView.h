//
//  LGPhotoView.h
//  LiveGather
//
//  Created by Alexander on 7/30/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGPhoto.h"

@class LGPhotoView;
@protocol LGPhotoDelegate <NSObject>
@optional
- (void)photoViewWasTouchedWithID:(int)imgID andIndex:(int)imgIndex;
- (void)photoLocationLabelWasTouchedWithID:(int)imgID andIndex:(int)imgIndex;
@end


@interface LGPhotoView : UIImageView {
	LGPhoto		*photo;
	int			index;
	id <LGPhotoDelegate> delegate;
}

@property (nonatomic, assign) id <LGPhotoDelegate> delegate;
@property (nonatomic, retain) LGPhoto *photo;
@property (nonatomic) int index;

- (void)setDelegate:(id <LGPhotoDelegate>)dlg;

@end
