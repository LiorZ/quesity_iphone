//
//  QSCpage.h
//  try3
//
//  Created by igor on 3/22/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSCQuest.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "buttonView.h"
#import "multiQuestion.h"
#import "IBActionSheet.h"
#import "Resources/MBProgressHUD/MBProgressHUD.h"
#import "QSCStack.h"

#define TIME_SLIDE_DELAY 0.25
#define TIME_CHECKING_ANSWER 1.5

@class QSCpage;
@protocol QSCpageDelegate <NSObject>
- (void)QSCpageDidSave:(QSCpage *)controller;
@end

@interface QSCpage : UIViewController<CLLocationManagerDelegate, UIActionSheetDelegate, UIWebViewDelegate, IBActionSheetDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

typedef NS_ENUM(NSInteger, pageType) {
    page_LOCATION,
    page_OPEN_QUESTION,
    page_QUESTION,
    page_STATIC
};

@property IBOutlet QSCQuest *quest;
@property IBOutlet NSArray *content;
@property IBOutlet NSArray *is_first;
@property IBOutlet NSArray *linksToOthers;
@property IBOutlet NSArray *pagesHints;
@property IBOutlet NSArray *pagesId;
@property IBOutlet NSArray *pagesName;
@property IBOutlet NSArray *pagesQType;
@property BOOL isStartOver;
@property BOOL isOnFirstPage;
@property MBProgressHUD *hud;

@property IBActionSheet *specialMoreMenu;

@property NSTimer *timer;

@property NSUInteger pagesViewed;
@property NSUInteger currPage;
@property pageType currQType; //location, open_question, question (multiple choice), static
@property NSArray *currCorrectAnswers;
@property NSMutableArray *locsCorrect;
@property NSArray *linkBeingProcessed;
@property BOOL displayedNotCorrectMessages;
@property NSUInteger currHintsAvailable;
@property QSCStack *pagesStack;

@property (weak, nonatomic) IBOutlet UIWebView *webStuff2;

@property buttonView *buttonLeft;
@property buttonView *buttonMiddle;
@property buttonView *buttonRight;

//@property multiQuestion *mqv;


//sague back buisness
@property (nonatomic, weak) id <QSCpageDelegate> delegate;
- (IBAction)back:(id)sender;

@property NSString *ans;

@end
