//
//  QSCpage.m
//  try3
//
//  Created by igor on 3/22/14.
//  Copyright (c) 2014 igor. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "QSCpage.h"
#import "myUtilities.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "QSCLocation.h"
#import "myGlobalData.h"
#import "buttonView.h"
#import "QSCFinishPageVC.h"
#import "QSCmapViewController.h"

@implementation QSCpage
@synthesize webStuff2;
@synthesize quest = _quest;
@synthesize content = _content;
@synthesize is_first = _is_first;

- (void) updateButtonMiddleImage {
    if (self.currQType==page_STATIC) {
        [self.buttonMiddle.img setImage:[UIImage imageNamed:@"continue.png"]];
    } else if (self.currQType==page_LOCATION) {
        [self.buttonMiddle.img setImage:[UIImage imageNamed:@"arrived.png"]];
    } else if (self.currQType==page_OPEN_QUESTION) {
        [self.buttonMiddle.img setImage:[UIImage imageNamed:@"enter-text.png"]];
    } else if (self.currQType==page_QUESTION) {
        [self.buttonMiddle.img setImage:[UIImage imageNamed:@"options.png"]];
    }
}

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
    [webStuff2 setBackgroundColor:QUESITY_COLOR_BG];
    
    //pass the string to the webview
    [webStuff2 loadHTMLString:[html description] baseURL:nil];
    
    [self updateButtonMiddleImage];

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
    NSLog(@"hints num on page: %d (hints left: %d)",[self.pagesHints[self.currPage] count],self.currHintsAvailable);
    if ([self.pagesHints[self.currPage] count]==0 || self.currHintsAvailable<1)
        [self.buttonRight.buttonText setEnabled:FALSE];
    else
        [self.buttonRight.buttonText setEnabled:TRUE];
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

- (void) createButtons {
    
    // left button:
    self.buttonLeft = [[buttonView buttonView] initWithBorders:FALSE];
    self.buttonLeft.frame = CGRectMake(0.f, 508.f, 106.66f, 60.f);
    self.buttonLeft.buttonText.text = @"תפריט";
    [self.buttonLeft.img setImage:[UIImage imageNamed:@"menu.png"]];
    
    UITapGestureRecognizer *singleFingerTapLeft =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didPressButtonMore:)];
    [self.buttonLeft addGestureRecognizer:singleFingerTapLeft];
    
    [self.view addSubview:self.buttonLeft];
    
    // got it button:
    self.buttonMiddle = [[buttonView buttonView] initWithBorders:TRUE];
    self.buttonMiddle.frame = CGRectMake(106.66f, 508.f, 106.66f, 60.f);
    self.buttonMiddle.buttonText.text = @"המשך";
    [self.buttonMiddle.img setImage:[UIImage imageNamed:@"continue.png"]];
    
    UITapGestureRecognizer *singleFingerTapMiddle =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didPressButton2:)];
    [self.buttonMiddle addGestureRecognizer:singleFingerTapMiddle];
    
    [self.view addSubview:self.buttonMiddle];
    
    // right button
    self.buttonRight = [[buttonView buttonView] initWithBorders:FALSE];
    self.buttonRight.frame = CGRectMake(213.33f, 508.f, 106.66f, 60.f);
    self.buttonRight.buttonText.text = @"גלגל הצלה";
    [self.buttonRight.img setImage:[UIImage imageNamed:@"tactics.png"]];
    
    UITapGestureRecognizer *singleFingerTapRight =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didPressButtonHint:)];
    [self.buttonRight addGestureRecognizer:singleFingerTapRight];
    
    [self.view addSubview:self.buttonRight];
    
}

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    
    self.questTitle.text = _quest.name;
    //self. = _quest.name;
    [self.questTitle setTextColor:QUESITY_COLOR_FONT];
    [self.questTitleImg setBackgroundColor:QUESITY_COLOR_BG];

    self.view.backgroundColor = QUESITY_COLOR_BG;

    self.currPage = [self findFirst];

    [self createButtons];
    
    ////// maybe there is a saved state:
    //path of quest state:
    NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",_quest.questId];
    
    //loading quest state:
    NSDictionary* stateDict = [[NSUserDefaults standardUserDefaults] objectForKey: questStatePath];
    NSLog(@"loaded state dict: %@",stateDict);
    
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

//    [locationManager startUpdatingLocation];
//    [self->locationManager startUpdatingLocation];

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
                                              cancelButtonTitle: nil
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    
    for (NSString * title in self.currCorrectAnswers) {
        [popup addButtonWithTitle:title];
    }
    
    [popup addButtonWithTitle:@"Cancel"];
    popup.cancelButtonIndex = self.currCorrectAnswers.count;
    
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (popup.tag==1) {
        if (buttonIndex!=self.linksToOthers.count) {
            NSLog(@"Chose: %@",self.currCorrectAnswers[buttonIndex]);
            NSArray *links = self.linksToOthers[self.currPage];
            self.linkBeingProcessed = links[buttonIndex];
            [self goToNextPage];
        }
    } else if (popup.tag==2) {
//        NSString *opt1 =  @"הצג מפה";
//        NSString *opt2 =  @"התחל מחדש";
//        NSString *opt3 =  @"צא מהקווסט";

        if (buttonIndex==0) {
            NSLog(@"Show map!");
            [self segueToMap:nil];
        } else if (buttonIndex==1) {
            NSLog(@"Restart quest!");

            self.currPage = [self findFirst];
            self.currHintsAvailable = [_quest.allowedHints integerValue];
            NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",_quest.questId];
            [self saveDict:questStatePath];
            
            NSString *currQTypeString = [self.pagesQType objectAtIndex:self.currPage];
            self.currQType = [self string2PageType:currQTypeString];
            
            [self createWebViewWithHTML];
            [self updateHintButtonStatus];
        } else if (buttonIndex==2){
            NSLog(@"Exit quest!");
            
            [self back:nil];
        }
    } else if (popup.tag==3) {
        NSArray *hintsForThisPage = self.pagesHints[self.currPage];
        
        NSArray *hintsTitles = [hintsForThisPage valueForKey:@"hint_title"];
        NSArray *hintsContents = [hintsForThisPage valueForKey:@"hint_txt"];
        
        if (buttonIndex!=hintsTitles.count) { //not "Cancel"
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:hintsTitles[buttonIndex]
                                                            message:hintsContents[buttonIndex]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            self.currHintsAvailable = self.currHintsAvailable - 1;
            [self updateHintButtonStatus];
        }

    }
}

- (IBAction)segueToMap: (id)sender
{
    [self performSegueWithIdentifier:@"showMapSegue" sender:self];
}

- (IBAction)returnToStepOne:(UIStoryboardSegue *)segue {
    NSLog(@"And now we are back.");
}

- (IBAction)segueToFinish
{
    QSCFinishPageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FinishPage"];
    vc.quest = self.quest;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showMapSegue"]) {
        QSCFinishPageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mapView"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)didPressButton2:(id)sender {
    
    NSArray *links = self.linksToOthers[self.currPage];
    NSLog(@"there are %d links from here",links.count);
    NSLog(@"yo! %@",links);
    
    if (self.currQType==page_STATIC /*|| self.currQType==page_LOCATION || self.currQType==page_OPEN_QUESTION*/) {
        if ([links count]==0) {
            [self segueToFinish];
        } else {
            self.linkBeingProcessed = links[0];
            [self goToNextPage];
        }
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

    NSString *opt1 =  @"הצג מפה";
    NSString *opt2 =  @"התחל מחדש";
    NSString *opt3 =  @"צא מהקווסט";
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle: nil
                                                       delegate: self
                                              cancelButtonTitle: @"Cancel"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: opt1, opt2, opt3, nil];
    
    popup.tag = 2;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)didPressButtonHint:(id)sender {
    NSLog(@"here is a hint.");
    NSLog(@"%@",self.pagesHints[self.currPage]);
    NSArray *hintsForThisPage = self.pagesHints[self.currPage];
    NSArray *hintsTitles = [hintsForThisPage valueForKey:@"hint_title"];

    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle: @"Choose a hint:"
                                                       delegate: self
                                              cancelButtonTitle: nil
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    
    for (NSString * title in hintsTitles) {
        [popup addButtonWithTitle:title];
    }
    
    [popup addButtonWithTitle:@"Cancel"];
    popup.cancelButtonIndex = [hintsTitles count];
    
    popup.tag = 3;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
}

@end
