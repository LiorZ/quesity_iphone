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
#import "multiQuestion.h"
#import "IBActionSheet.h"

@implementation QSCpage
@synthesize webStuff2;
@synthesize quest = _quest;
@synthesize content = _content;
@synthesize is_first = _is_first;

- (void) updateButtonMiddleImage {

    if (self.currQType==page_STATIC) {
        [self.buttonMiddle.img setImage:[UIImage imageNamed:@"continue.png"]];        
        self.buttonMiddle.buttonText.text = NSLocalizedString(@"Continue", nil);
        //[self.buttonMiddle.img setImage:[UIImage imageNamed:@"continue_img_pressed.png"]];
        
    } else if (self.currQType==page_LOCATION) {
        [self.buttonMiddle.img setImage:[UIImage imageNamed:@"arrived.png"]];
        self.buttonMiddle.buttonText.text = NSLocalizedString(@"Arrived", nil);
        
    } else if (self.currQType==page_OPEN_QUESTION) {
        [self.buttonMiddle.img setImage:[UIImage imageNamed:@"enter-text.png"]];
        self.buttonMiddle.buttonText.text = NSLocalizedString(@"Enter Text", nil);
        
       
    } else if (self.currQType==page_QUESTION) {
        [self.buttonMiddle.img setImage:[UIImage imageNamed:@"options.png"]];
        self.buttonMiddle.buttonText.text = NSLocalizedString(@"Choose", nil);
        
    }
}

- (void) createWebViewWithHTML{
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: @"<html><body style='padding:0; margin:0'>"];

    //    NSMutableString *html = [NSMutableString stringWithString: @"<html><body style=\"background:transparent;\">"];
    
    //continue building the string
    if (self.content == Nil)
        [html appendString:@"first, please log in?"];
    else
        [html appendString:self.content[self.currPage]];

    [html appendString:@"</body></html>"];
    
    html = [NSMutableString stringWithString:[html stringByReplacingOccurrencesOfString:@"<p>" withString:@""]];
    html = [NSMutableString stringWithString:[html stringByReplacingOccurrencesOfString:@"</p>" withString:@""]];
   
    //make the background transparent
    [webStuff2 setBackgroundColor:QUESITY_COLOR_BG];
    
    webStuff2.delegate = self;
    
    //pass the string to the webview
    [webStuff2 loadHTMLString:[html description] baseURL:nil];

    [self updateButtonMiddleImage];
    
    //save progress:
    NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",_quest.questId];
    [self saveDict:questStatePath];
}


- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
//    NSLog(@"5. contentSize: %f",webStuff2.scrollView.contentSize.height);
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
//    NSLog(@"hints num on page: %d (hints left: %d)",[self.pagesHints[self.currPage] count],self.currHintsAvailable);
    if ([self.pagesHints[self.currPage] count]==0 || self.currHintsAvailable<1) {
        [self.buttonRight.buttonText setEnabled:FALSE];
        [self.buttonRight setUserInteractionEnabled:NO];
    } else {
        [self.buttonRight.buttonText setEnabled:TRUE];
        [self.buttonRight setUserInteractionEnabled:YES];
    }
}

- (void) saveDefaultDict: (NSString *)questStatePath {
    //only if logged in, got pagesId
    if (self.pagesId!= nil && _quest!=nil) {
        NSDictionary *aDict = @{@"continueOnPage" : self.pagesId[self.currPage], @"hintsLeft" : _quest.allowedHints};
        //saving stuff:
        [[NSUserDefaults standardUserDefaults] setObject:aDict forKey:questStatePath];
        
        self.currHintsAvailable = [_quest.allowedHints integerValue];
    }
}

- (void) saveDict: (NSString *)questStatePath {
    //only if logged in, got pagesId
    if (self.pagesId!= nil && _quest!=nil) {
        NSDictionary *aDict = @{@"continueOnPage" : self.pagesId[self.currPage], @"hintsLeft" : [NSNumber numberWithInt:(int)self.currHintsAvailable]};
        //saving stuff:
        [[NSUserDefaults standardUserDefaults] setObject:aDict forKey:questStatePath];
    }
}

//- (void) initMultiQuestionView: (NSArray *)links {
//
////    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//
//    self.mqv = [[multiQuestion multiQuestionView] initWithlinks:links];
//    self.mqv.center = self.view.center;
//    
////    UITapGestureRecognizer *singleFingerTapLeft =
////    [[UITapGestureRecognizer alloc] initWithTarget:self
////                                            action:@selector(didPressButtonMore:)];
////    [self.buttonLeft addGestureRecognizer:singleFingerTapLeft];
//    
//    [self.view addSubview:self.mqv];
//}

- (void) createButtons {
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    if (screenBounds.size.height == 568) {
//        // code for 4-inch screen
//    } else {
//        // code for 3.5-inch screen
//    }
    
    // left button:
    self.buttonLeft = [[buttonView buttonView] initWithBorders:FALSE];
    self.buttonLeft.frame = CGRectMake(0.f, screenBounds.size.height - 60, 106.66f, 60.f);

    self.buttonLeft.buttonText.text = NSLocalizedString(@"Menu", nil);
    self.buttonLeft.buttonText.font = [UIFont fontWithName:NSLocalizedString(@"Andada-Regular",nil) size:18];

    [self.buttonLeft.img setImage:[UIImage imageNamed:@"menu.png"]];
    
    UITapGestureRecognizer *singleFingerTapLeft =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didPressButtonMore:)];
    [self.buttonLeft addGestureRecognizer:singleFingerTapLeft];
    
    [self.view addSubview:self.buttonLeft];
    
    // got it button:
    self.buttonMiddle = [[buttonView buttonView] initWithBorders:TRUE];
    self.buttonMiddle.frame = CGRectMake(106.66f, screenBounds.size.height - 60, 106.66f, 60.f);
    self.buttonMiddle.buttonText.text = NSLocalizedString(@"Continue", nil);
    self.buttonMiddle.buttonText.font = [UIFont fontWithName:NSLocalizedString(@"Andada-Regular",nil) size:18];
         
    [self.buttonMiddle.img setImage:[UIImage imageNamed:@"continue.png"]];
    
    UITapGestureRecognizer *singleFingerTapMiddle =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didPressButton2:)];
    [self.buttonMiddle addGestureRecognizer:singleFingerTapMiddle];
    
    [self.view addSubview:self.buttonMiddle];
    
    // right button
    self.buttonRight = [[buttonView buttonView] initWithBorders:FALSE];
    self.buttonRight.frame = CGRectMake(213.33f, screenBounds.size.height - 60, 106.66f, 60.f);
    self.buttonRight.buttonText.text = NSLocalizedString(@"Tactics", nil);

    self.buttonRight.buttonText.font = [UIFont fontWithName:NSLocalizedString(@"Andada-Regular",nil) size:18];
    
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
    
    //remove margin at bottom
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    //self.questTitle.text = _quest.name;
    //self. = _quest.name;
    //[self.questTitle setTextColor:QUESITY_COLOR_FONT];
    //[self.questTitleImg setBackgroundColor:QUESITY_COLOR_BG];

    self.view.backgroundColor = QUESITY_COLOR_BG;

    self.currPage = [self findFirst];

    [self createButtons];
    
    ////// maybe there is a saved state:
    //path of quest state:
    NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",_quest.questId];

    if (!self.isStartOver) {
        //loading quest state:
        NSDictionary* stateDict = [[NSUserDefaults standardUserDefaults] objectForKey: questStatePath];
//        NSLog(@"loaded state dict: %@",stateDict);
        
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
            }
        } else {
            if (self.pagesId!=nil) {
                [self saveDefaultDict:questStatePath];
            }
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
    NSString *ans = [link valueForKey:@"answer_txt"];
    if (ans==nil)
        return [link valueForKey:@"txt_street"];
    return ans;
}

- (NSMutableArray *) getLocsFromLinks:(NSArray *)links {

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
//    NSLog(@"%@, which is on index: %d",[self parseJsonOfLinks:self.linkBeingProcessed], nextPage);
    
    [self createWebViewWithHTML];
    [self updateHintButtonStatus];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 0) {
        NSString *ans1 = [[alertView textFieldAtIndex:0] text];
//        NSLog(@"Entered: %@",ans1);
        
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Wrong answer",nil)
                                                            message:NSLocalizedString(@"Wrong answer! :( try again.", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } else if (alertView.tag == 1) {

    }
}

- (void) askOpenQuestionAndCheckAnswer {
    //ask question (and check):
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Answer",nil)
                                                     message:NSLocalizedString(@"Enter the answer:", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Continue",nil)
                                           otherButtonTitles:nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = NSLocalizedString(@"answer",nil);
    alert.tag = 0;
    [alert show];
}

- (void) chooseMultChoice {

//    [self initMultiQuestionView: self.currCorrectAnswers];
    
    IBActionSheet *popup = [[IBActionSheet alloc] initWithTitle: NSLocalizedString(@"Choose:", nil)
                                                       delegate: self
                                              cancelButtonTitle: NSLocalizedString(@"Cancel",nil)
                                         destructiveButtonTitle: nil
                                        otherButtonTitlesArray: self.currCorrectAnswers];
    
    for (int i=0; i<self.currCorrectAnswers.count; i++) {
        if ([self.currCorrectAnswers[i] length]>40)
            [popup setFont:[UIFont boldSystemFontOfSize:14] forButtonAtIndex:i];
    }

    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];

}

- (void) popToCheat {
    NSArray *links = self.linksToOthers[self.currPage];
//    NSLog(@"%@",links);

    UIActionSheet *newPopup = [[UIActionSheet alloc] initWithTitle: @"Here are some links:"
                                                          delegate: self
                                                 cancelButtonTitle: nil
                                            destructiveButtonTitle: nil
                                                 otherButtonTitles: nil];
    
    for (NSArray * link in links) {
        [newPopup addButtonWithTitle:[self getAnswerFromLink:link]];
    }
    
    [newPopup addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    newPopup.cancelButtonIndex = links.count;
    
    newPopup.tag = 4;
    [newPopup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (popup.tag==1) {
        if (buttonIndex!=[self.linksToOthers[self.currPage] count]) {
//            NSLog(@"Chose: %@",self.currCorrectAnswers[buttonIndex]);
            NSArray *links = self.linksToOthers[self.currPage];
            self.linkBeingProcessed = links[buttonIndex];
            [self goToNextPage];
        }
    } else if (popup.tag==2) {
//        NSString *opt1 =  @"הצג מפה";
//        NSString *opt3 =  @"צא מהקווסט";
//        NSString *opt4 =  @"cheat and skip page. ha!";
//        NSString *opt5 =  @"cheat and go to the end. ha ha!";

        if (buttonIndex==0) {
//            NSLog(@"Show map!");
            [self segueToMap:nil];
//        } else if (buttonIndex==1) {
//            NSLog(@"Restart quest!");
//
//            self.currPage = [self findFirst];
//            self.currHintsAvailable = [_quest.allowedHints integerValue];
//            NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",_quest.questId];
//            [self saveDict:questStatePath];
//            
//            NSString *currQTypeString = [self.pagesQType objectAtIndex:self.currPage];
//            self.currQType = [self string2PageType:currQTypeString];
//            
//            [self createWebViewWithHTML];
//            [self updateHintButtonStatus];
        } else if (buttonIndex==1){
//            NSLog(@"Exit quest!");
            
            [self back:nil];
        }  else if ((buttonIndex==2) && isDbgMode) {
//            NSLog(@"go to next page!");

            //there might be more than one link...
            NSArray *links = self.linksToOthers[self.currPage];
            
            if (self.currQType==page_STATIC /*|| self.currQType==page_LOCATION || self.currQType==page_OPEN_QUESTION*/) {
                if ([links count]==0) {
                    [self segueToFinish];
                }
            }
            
            if (links.count==1) {
                self.linkBeingProcessed = links[0];
                [self goToNextPage];
            } else if (links.count!=0){
                [self popToCheat];
            }
            
        } else if ((buttonIndex==3) && isDbgMode) {
//            NSLog(@"Finish quest!");
            
            [self segueToFinish];
        }
    } else if (popup.tag==3) {
        NSArray *hintsForThisPage = self.pagesHints[self.currPage];
        
        NSArray *hintsTitles = [hintsForThisPage valueForKey:@"hint_title"];
        NSArray *hintsContents = [hintsForThisPage valueForKey:@"hint_txt"];
        
        if (buttonIndex!=hintsTitles.count) { //not "Cancel"
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:hintsTitles[buttonIndex]
                                                            message:hintsContents[buttonIndex]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
            
            self.currHintsAvailable = self.currHintsAvailable - 1;
            [self updateHintButtonStatus];

            //save progress (hints taken):
            NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",_quest.questId];
            [self saveDict:questStatePath];
        }
    } else if (popup.tag==4) {
        NSArray *links = self.linksToOthers[self.currPage];
        if (buttonIndex!=links.count) {
//            NSLog(@"Chose: %@",links[buttonIndex]);
            self.linkBeingProcessed = links[buttonIndex];
            [self goToNextPage];
        }
    }
}

- (IBAction)segueToMap: (id)sender
{
    [self performSegueWithIdentifier:@"showMapSegue" sender:self];
}

- (IBAction)returnToStepOne:(UIStoryboardSegue *)segue {
//    NSLog(@"And now we are back.");
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
//    NSLog(@"there are %d links from here",links.count);
//    NSLog(@"yo! %@",links);
    
    if (self.currQType==page_STATIC /*|| self.currQType==page_LOCATION || self.currQType==page_OPEN_QUESTION*/) {
        if ([links count]==0) {
            [self segueToFinish];
        } else {
            self.linkBeingProcessed = links[0];
            [self goToNextPage];
        }
    } else {
        //get (and print, ha ha ha) correct answers
//        for (int i=0; i<links.count; i++) {
//            NSString *ansType = [self getTypeFromLink:links[i]];
//            NSLog(@"type (curr. page): %@",ansType);
//            if ([ansType isEqualToString:@"answer"]) {
//                NSString *correctAnswers = [self getAnswerFromLink:links[i]];
//                NSLog(@"(Correct Answer is:%@)",correctAnswers);
//            }
//        }
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
    
//    NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);

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
//        NSLog(@"distance: %.2f [m]", distance);

        if (distance<minDistance) {
            minDistance = distance;
            if (distance<radCorrect) {
                ans = i;
            }
        }
    }
    
    if (ans<0) {
        if (!self.displayedNotCorrectMessages) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Wrong answer", nil)
                                                            message:NSLocalizedString(@"You are not at the right location... Try again.",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
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
//    NSLog(@"didUpdateToLocation: %@", newLocation);
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
    
    NSString *opt1 = NSLocalizedString(@"Show Map",nil);
//    NSString *opt2 = NSLocalizedString(@"Start Over", nil);
    NSString *opt3 = NSLocalizedString(@"Leave Quest",nil);
    NSString *opt4 = NSLocalizedString(@"Skip to the next page. Ha!",nil);
    NSString *opt5 = NSLocalizedString(@"Skip to the the end. Ha Ha!",nil);
    
    UIActionSheet *popup;
    if (isDbgMode) {
        popup = [[UIActionSheet alloc] initWithTitle: nil
                                            delegate: self
                                   cancelButtonTitle: NSLocalizedString(@"Cancel", nil)
                              destructiveButtonTitle: nil
                                   otherButtonTitles: opt1, opt3, opt4, opt5, nil];
    } else {
        popup = [[UIActionSheet alloc] initWithTitle: nil
                                            delegate: self
                                   cancelButtonTitle: NSLocalizedString(@"Cancel", nil)
                              destructiveButtonTitle: nil
                                   otherButtonTitles: opt1, opt3, nil];
    }
    
    popup.tag = 2;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)didPressButtonHint:(id)sender {
//    NSLog(@"here is a hint.");
//    NSLog(@"%@",self.pagesHints[self.currPage]);
    NSArray *hintsForThisPage = self.pagesHints[self.currPage];
    NSArray *hintsTitles = [hintsForThisPage valueForKey:@"hint_title"];

    NSMutableString *hintsTitle = [NSMutableString stringWithFormat:@"You have %d hints left", (int)self.currHintsAvailable];

    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"he"]) {
        hintsTitle = [NSMutableString stringWithFormat:@"נותרו עוד %d רמזים", (int)self.currHintsAvailable];
    }
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle: hintsTitle
                                                       delegate: self
                                              cancelButtonTitle: nil
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: nil];
    
    for (NSString * title in hintsTitles) {
        [popup addButtonWithTitle:title];
    }
    
    [popup addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    popup.cancelButtonIndex = [hintsTitles count];
    
    popup.tag = 3;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
}

@end
