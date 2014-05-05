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

- (void) updateHintButtonStatus {
    NSLog(@"hints num: %d",[self.pagesHints[self.currPage] count]);
    if ([self.pagesHints[self.currPage] count]==0 || self.currHintsAvailable<1)
        [self.hintButton setEnabled:FALSE];
    else
        [self.hintButton setEnabled:TRUE];
}

- (void) saveDefaultDict: (NSString *)questStatePath {
    //only if logged in, got pagesId
    if (self.pagesId!= nil && _quest!=nil) {
        NSDictionary *aDict = @{@"continueOnPage" : self.pagesId[self.currPage], @"hintsLeft" : _quest.allowedHints};
        //saving stuff:
        [[NSUserDefaults standardUserDefaults] setObject:aDict forKey:questStatePath];
    }
}

- (void) saveDict: (NSString *)questStatePath {
    //only if logged in, got pagesId
    if (self.pagesId!= nil && _quest!=nil) {
        NSDictionary *aDict = @{@"continueOnPage" : self.pagesId[self.currPage], @"hintsLeft" : [NSNumber numberWithInt:self.currHintsAvailable]};
        //saving stuff:
        [[NSUserDefaults standardUserDefaults] setObject:aDict forKey:questStatePath];
    }
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

    ////// maybe there is a saved state:
    //path of quest state:
    NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",_quest.questId];
    
    //loading quest state:
    NSDictionary* stateDict = [[NSUserDefaults standardUserDefaults] objectForKey: questStatePath];
    NSLog(@"loaded dict: %@",stateDict);
    
    //check whether exists
    if (stateDict!=nil) {
        NSString *continueOnPage = [stateDict objectForKey:@"continueOnPage"];
        NSString *hintsLeft = [stateDict objectForKey:@"hintsLeft"];

        //check that the questState is "takin"
        if (continueOnPage==nil || hintsLeft==nil) {
            [self saveDefaultDict:questStatePath];
            //reload:
            stateDict = [[NSUserDefaults standardUserDefaults] objectForKey: questStatePath];
        }
        
        self.currHintsAvailable = [[stateDict objectForKey:@"hintsLeft"] integerValue];
        
        if (![self.pagesId[self.currPage] isEqualToString:continueOnPage]) {
            self.currPage = [self findID:continueOnPage];
            NSLog(@"what to do? resume. restart possible from more option or get from github a blocking alert view");
        }
    } else {
        if (self.pagesId!=nil) {
            [self saveDefaultDict:questStatePath];
        }
    }

    //pageType:
    NSString *currQTypeString = [self.pagesQType objectAtIndex:self.currPage];
    self.currQType = [self string2PageType:currQTypeString];
       
    [self createWebViewWithHTML];
    
    //if there's no hint on the page, or no hints left, it should be disabled.
    [self updateHintButtonStatus];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
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
    [self updateHintButtonStatus];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 0) {
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
    } else if (alertView.tag == 1) {

    }
}

- (void) askOpenQuestionAndCheckAnswer {
    //ask question (and check):
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!"
                                                     message:@"Please enter the answer:"
                                                    delegate:self
                                           cancelButtonTitle:@"Continue"
                                           otherButtonTitles:nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"answer";
    alert.tag = 0;
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
    if (popup.tag==1) {
        if (buttonIndex>0) {
            NSLog(@"Chose: %@",self.currCorrectAnswers[buttonIndex-1]);
            NSArray *links = self.linksToOthers[self.currPage];
            self.linkBeingProcessed = links[buttonIndex-1];
            [self goToNextPage];
        }
    } else if (popup.tag==2) {
        if (buttonIndex==0) {
            NSLog(@"Restart quest!");

            self.currPage = [self findFirst];
            self.currHintsAvailable = [_quest.allowedHints integerValue];

            NSString *currQTypeString = [self.pagesQType objectAtIndex:self.currPage];
            self.currQType = [self string2PageType:currQTypeString];
            
            [self createWebViewWithHTML];
            [self updateHintButtonStatus];
        }
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
    //saving quest state:
    if (self.pagesId!=nil) {
        //path of quest state:
        NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",_quest.questId];

        [self saveDict:questStatePath];
    }

    [self.delegate QSCpageDidSave:self];
}

- (IBAction)didPressButtonMore:(id)sender {

    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle: nil
                                                       delegate: self
                                              cancelButtonTitle: @"Cancel"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: @"Restart Quest", nil];
    
    //[popup addButtonWithTitle:@"Restart quest"];
    popup.tag = 2;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)didPressButtonHint:(id)sender {
    NSLog(@"here is a hint.");
    NSLog(@"%@",self.pagesHints[self.currPage]);
    NSArray *hintsForThisPage = self.pagesHints[self.currPage];

    NSArray *hintsTitles = [hintsForThisPage valueForKey:@"hint_title"];
    NSArray *hintsContents = [hintsForThisPage valueForKey:@"hint_txt"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:hintsTitles[0]
                                                    message:hintsContents[0]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    self.currHintsAvailable = self.currHintsAvailable - 1;
    [self updateHintButtonStatus];
}

@end
