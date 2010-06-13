//
//  MapViewController.h
//  LiveGather
//
//  Created by Alexander on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FlipsideViewController.h"
#import "UploadPhotoViewController.h"
#import "LiveStreamViewController.h"
#import "AccountLoginViewController.h"
#import "ResourceManager.h"
#import "MBProgressHUD.h"

@interface MapViewController : UIViewController {
	MKMapView			*mapView;
}

@end
