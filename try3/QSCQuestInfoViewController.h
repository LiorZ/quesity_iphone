//
//  QSCQuestInfoViewController.h
//  try3
//
//  Created by igor on 2/16/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSCQuest.h"
#import "QSCpage.h"
#import "HMSegmentedControl/HMSegmentedControl.h"
#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>
#import "POHorizontalList.h"


@interface QSCQuestInfoViewController : UIViewController <UIScrollViewDelegate, QSCpageDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    IBOutlet MKMapView *mapView;
    NSMutableArray *picsList;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property IBOutlet UIPageControl *pageControl;
@property IBOutlet QSCQuest *quest;
@property (nonatomic, copy) NSArray *content;
@property NSArray *is_first;

@property (nonatomic,retain) IBOutlet MKMapView *mapView;


@end
