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
#import "Resources/MBProgressHUD/MBProgressHUD.h"
#import "QSCPlayer.h"

#define PAGES_TO_PRELOAD 3
#define IMAGE_Y_START 60

//#define IMAGE_H (320/1.62)
#define TIME_TO_SWITCH_IMAGE 5

@interface QSCQuestInfoViewController : UIViewController <UIScrollViewDelegate, QSCpageDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate, UIWebViewDelegate> {
    CLLocationManager *locationManager;
    IBOutlet MKMapView *mapView;
}

@property (nonatomic, strong) UIScrollView *scrollView1;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property IBOutlet QSCQuest *quest;
@property (nonatomic, copy) NSArray *content;
@property (nonatomic, copy) NSArray *linksToOthers;
@property (nonatomic, copy) NSArray *pagesHints;
@property (nonatomic, copy) NSArray *pagesId;
@property (nonatomic, copy) NSArray *pagesQType;
@property NSArray *is_first;
@property MBProgressHUD *hud;
@property BOOL loadedAllImages;
@property NSTimer *timer;
@property NSTimer *imgsTimer;

@property QSCPlayer *player;
@property NSString *codeBought;

@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *goOnQuestButton;

@end
