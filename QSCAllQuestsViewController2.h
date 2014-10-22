//
//  QSCAllQuestsViewController2.h
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Resources/MBProgressHUD/MBProgressHUD.h"


#define CELLS_2_DUPLICATE_4_DEBUG 5

@interface QSCAllQuestsViewController2 : UITableViewController <UISearchBarDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *userPosition;
}

//@property (weak, nonatomic) IBOutlet UIImageView *imgOfCell;

//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray* filteredTableData;

@property NSTimer *timer;
//@property UIRefreshControl *rc;

@property UISearchBar *mySearchBar;

@property MBProgressHUD *hud;

@end
