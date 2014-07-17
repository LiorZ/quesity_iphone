//
//  QSCmapViewController.h
//  Quesity
//
//  Created by igor on 5/17/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSCpage.h"
#import <MapKit/MapKit.h>

@interface QSCmapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *myMAp;

@end
