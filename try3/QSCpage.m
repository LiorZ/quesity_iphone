//
//  QSCpage.m
//  try3
//
//  Created by igor on 3/22/14.
//  Copyright (c) 2014 igor. All rights reserved.
//
#define SITEURL @"http://quesity.herokuapp.com/quest/"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "QSCpage.h"
#import "myUtilities.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "QSCLocation.h"

@implementation QSCpage
@synthesize webStuff2;
@synthesize quest = _quest;
@synthesize content = _content;
@synthesize is_first = _is_first;


- (void) createWebViewWithHTML{
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: @"<html>"];
//    NSMutableString *html = [NSMutableString stringWithString: @"<html><body style=\"background:transparent;\">"];
    
    //continue building the string
    if (self.content == Nil)
        [html appendString:@"first, please log in?"];
    else
        [html appendString:self.content[self.currPage]];

    [html appendString:@"</html>"];
    
    //NSLog(@"%@",html);
    
    //instantiate the web view
    //UIWebView *webView2 = [[UIWebView alloc] initWithFrame:self.view.frame];
    
    //make the background transparent
    [webStuff2 setBackgroundColor:[UIColor clearColor]];
    
    //pass the string to the webview
    [webStuff2 loadHTMLString:[html description] baseURL:nil];
    
    //add it to the subview
    //[self.view addSubview:webView2];
    
}

- (NSUInteger) findFirst {
    return [self.is_first indexOfObjectIdenticalTo:@(YES)];
}

- (NSUInteger) findID: (NSString *)pageId {
    return [self.pagesId indexOfObject:pageId];
}

- (pageType) string2PageType: (NSString *)pageString {
    if ([pageString isEqualToString:@"location"])
        return page_LOCATION;
    if ([pageString isEqualToString:@"open_question"])
        return page_OPEN_QUESTION;
    if ([pageString isEqualToString:@"question"])
        return page_QUESTION;
    if ([pageString isEqualToString:@"static"])
        return page_STATIC;

    return -1;
}


- (void)viewDidLoad
{
    //NSString *fullURL = @"http://quesity.herokuapp.com/home";
    //NSURL *url = [NSURL URLWithString:fullURL];
//    NSURL *questURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/pages", SITEURL, _quest.questId]];
//    
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:questURL];
//    [webStuff2 loadRequest:requestObj];

    self.navigationItem.title = _quest.name;
    
    self.currPage = [self findFirst];
    
    NSString *currQTypeString = [self.pagesQType objectAtIndex:self.currPage];
    self.currQType = [self string2PageType:currQTypeString];
       
    [self createWebViewWithHTML];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;\
    
    [super viewDidLoad];
}


- (NSString *) parseJsonOfLinks:(NSArray *)links {
    return [links valueForKey:@"links_to_page"];
}

- (NSString *) getTypeFromLink:(NSArray *)link {
    return [link valueForKey:@"type"];
}

- (NSString *) getAnswerFromLink:(NSArray *)link {
    return [link valueForKey:@"answer_txt"];
}

- (NSMutableArray *) getLocsFromLinks:(NSArray *)links {
//    NSArray *lats = [links valueForKey:@"lat"];
//    NSArray *lngs = [links valueForKey:@"lng"];
//    NSArray *rads = [links valueForKey:@"radius"];
//    NSArray *streets = [links valueForKey:@"txt_street"];

    NSMutableArray *locs = [[NSMutableArray alloc] init];
    for (int i=0; i<links.count; i++) {
        NSArray *link = [links objectAtIndex:i];
        
        QSCLocation *loc = [[QSCLocation alloc] init];
        loc.lat = [link valueForKey:@"lat"];
        loc.lng = [link valueForKey:@"lng"];
        loc.rad = [link valueForKey:@"radius"];
        loc.street = [link valueForKey:@"txt_street"];

        [locs addObject:loc];
    }
    
    return locs;
}



- (void) goToNextPage {
    NSUInteger nextPage = [self findID:[self parseJsonOfLinks:self.linkBeingProcessed]];
    self.currPage = nextPage;

    NSString *currQTypeString = [self.pagesQType objectAtIndex:self.currPage];
    self.currQType = [self string2PageType:currQTypeString];
    
    //NSLog(@"link to next page %@",self.linkBeingProcessed);
    NSLog(@"%@, which is on index: %d",[self parseJsonOfLinks:self.linkBeingProcessed], nextPage);
    
    [self createWebViewWithHTML];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *ans1 = [[alertView textFieldAtIndex:0] text];
    NSLog(@"Entered: %@",ans1);
    
    NSInteger ans = -1;
    for (int i=0; i<self.currCorrectAnswers.count; i++) {
        NSString *possibleAnswer = [self.currCorrectAnswers objectAtIndex:i];
        if ([possibleAnswer isEqualToString:ans1]) {
            ans = i;
        }
    }
    
    if (ans>-1) {
        NSArray *links = self.linksToOthers[self.currPage];
        self.linkBeingProcessed = links[ans];
        
        [self goToNextPage];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nope, sorry"
                                                        message:@"That's not a correct answer."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) askOpenQuestionAndCheckAnswer {
    //ask question (and check):
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter the answer:" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"answer";
    [alert show];
}

- (void) chooseMultChoice {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle: @"Here are some options:"
                                                       delegate: self
                                              cancelButtonTitle: @"Cancel"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    
    for (NSString * title in self.currCorrectAnswers) {
        [popup addButtonWithTitle:title];
    }
    
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex>0) {
        NSLog(@"Chose: %@",self.currCorrectAnswers[buttonIndex-1]);
        NSArray *links = self.linksToOthers[self.currPage];
        self.linkBeingProcessed = links[buttonIndex-1];
        [self goToNextPage];
    }

}




- (IBAction)didPressButton2:(id)sender {
    
    NSArray *links = self.linksToOthers[self.currPage];
    NSLog(@"there are %d links from here",links.count);
    NSLog(@"yo! %@",links);
    
    if (self.currQType==page_STATIC /*|| self.currQType==page_LOCATION || self.currQType==page_OPEN_QUESTION*/) {
        self.linkBeingProcessed = links[0];
        [self goToNextPage];
    } else {
        //get (and print, ha ha ha) correct answers
        for (int i=0; i<links.count; i++) {
            NSString *ansType = [self getTypeFromLink:links[i]];
            NSLog(@"type (curr. page): %@",ansType);
            if ([ansType isEqualToString:@"answer"]) {
                NSString *correctAnswers = [self getAnswerFromLink:links[i]];
                NSLog(@"(Correct Answer is:%@)",correctAnswers);
            }
        }
        switch (self.currQType) {
            case page_OPEN_QUESTION:
                self.currCorrectAnswers = [links valueForKey:@"answer_txt"];
                [self askOpenQuestionAndCheckAnswer];
                break;
            case page_QUESTION:
                self.currCorrectAnswers = [links valueForKey:@"answer_txt"];
                [self chooseMultChoice];
                break;
            case page_LOCATION:
                self.locsCorrect = [self getLocsFromLinks:links];
                //Lunz: 32.069888, 34.779802
                
                self.displayedNotCorrectMessages = FALSE;
                
                [locationManager startUpdatingLocation];
                [self->locationManager startUpdatingLocation];
                
                //                CLLocation *location = [locationManager location];
                //                CLLocationCoordinate2D coordinate = [location coordinate];
                //                NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
                //                NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
                //                NSLog(@"lat :%@, long:%@", latitude, longitude);
                
                break;
                
            default:
                break;
        }
        
        //    self.linkBeingProcessed = links[0];
        //    NSLog(@"yo! %@",links[0]);
    }
}

#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    [locationManager stopUpdatingLocation];
    
    [self->locationManager stopUpdatingLocation];
    
    NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);

    float minDistance = 10000;
    NSInteger ans = -1;
    for (int i=0; i<self.locsCorrect.count; i++) {
        QSCLocation *loc = self.locsCorrect[i];

        //comparing location:
        double latCorrect = [loc.lat doubleValue];
        double lngCorrect = [loc.lng doubleValue];
        double radCorrect = [loc.rad doubleValue];
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:latCorrect longitude:lngCorrect];
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        CLLocationDistance distance = [locA distanceFromLocation:locB];
        NSLog(@"distance: %.2f [m]", distance);

        if (distance<minDistance) {
            minDistance = distance;
            if (distance<radCorrect) {
                ans = i;
            }
        }
    }
    
    if (ans<0) {
        if (!self.displayedNotCorrectMessages) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nope, sorry"
                                                            message:@"You're not in the correct location."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            self.displayedNotCorrectMessages = TRUE;
        }
        
    } else {
        NSArray *links = self.linksToOthers[self.currPage];
        self.linkBeingProcessed = links[ans];
        
        [self goToNextPage];
    }

}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
}

- (IBAction)back:(id)sender
{
    [self.delegate QSCpageDidSave:self];
}


@end
