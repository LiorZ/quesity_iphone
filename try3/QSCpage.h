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

@class QSCpage;
@protocol QSCpageDelegate <NSObject>
- (void)QSCpageDidSave:(QSCpage *)controller;
@end

@interface QSCpage : UIViewController<CLLocationManagerDelegate, UIActionSheetDelegate>
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
@property IBOutlet NSArray *pagesId;
@property IBOutlet NSArray *pagesQType;

@property NSUInteger currPage;
@property pageType currQType; //location, open_question, question (multiple choice), static
//@property NSString *currAType; //regular, answer, location, answer_txt
@property NSArray *currCorrectAnswers;
//@property QSCLocation *locCorrect;
@property NSMutableArray *locsCorrect;
@property NSArray *linkBeingProcessed;
@property BOOL displayedNotCorrectMessages;


@property (weak, nonatomic) IBOutlet UIButton *didPressButton2;

@property (weak, nonatomic) IBOutlet UIWebView *webStuff2;

//sague back buisness
@property (nonatomic, weak) id <QSCpageDelegate> delegate;
- (IBAction)back:(id)sender;

@property NSString *ans;

@end
