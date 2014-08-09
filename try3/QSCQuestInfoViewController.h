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
#import <MapKit/MapKit.h>
#import "HMSegmentedControl.h"
//#import <CoreLocation/CoreLocation.h>
#import "POHorizontalList.h"
#import "Resources/MBProgressHUD/MBProgressHUD.h"


@interface QSCQuestInfoViewController : UIViewController <UIScrollViewDelegate, QSCpageDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate, UIWebViewDelegate> {
    CLLocationManager *locationManager;
    IBOutlet MKMapView *mapView;
    NSMutableArray *picsList;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property IBOutlet UIPageControl *pageControl;
@property IBOutlet QSCQuest *quest;
//@property IBOutlet NSString *GoStraightToQuest;
@property (nonatomic, copy) NSArray *content;
@property (nonatomic, copy) NSArray *linksToOthers;
@property (nonatomic, copy) NSArray *pagesHints;
@property (nonatomic, copy) NSArray *pagesId;
@property (nonatomic, copy) NSArray *pagesQType;
@property NSArray *is_first;
@property MBProgressHUD *hud;
@property BOOL loadedAllImages;
@property NSTimer *timer;

@property (nonatomic,retain) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *goOnQuestButton;

@end
