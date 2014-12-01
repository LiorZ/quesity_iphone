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
#import "multiQuestion.h"
#import "IBActionSheet.h"
#import <QuartzCore/QuartzCore.h>

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
    
    myUtilities *myUtils = [[myUtilities alloc] init];
    [myUtils sendPageChangeToGA:_quest.name
                withPagesViewed:[NSNumber numberWithUnsignedInteger:_pagesViewed]
                   withPageName:_pagesName[_currPage]];
    //NSLog(@"sent GA with: name: %@, pagesViewed %d, and pageName: %@",_quest.name, _pagesViewed, _pagesName[_currPage]);
    
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
    
//    UITapGestureRecognizer *singleFingerTap4Camera = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                             action:@selector(didTapOnWebView:)];
//    
//    [self.webStuff2 addGestureRecognizer:singleFingerTap4Camera];
    
    //save progress:
    NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",_quest.questId];
    [self saveDict:questStatePath];

    [self slideWebView:webStuff2 withSlideIN:NO];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIME_SLIDE_DELAY * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    });
}

//the following methid is needed in order to get gestures in web view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (IBAction)didTapOnWebView:(id)sender {
    _buttonCamera.hidden = NO;
//    [self.view bringSubviewToFront:_buttonCamera];

    _timerCameraBtn = [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_FOR_CAMERA_BUTTON
                                                       target:self
                                                     selector:@selector(hideCameraBtn)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void) hideCameraBtn {
    _buttonCamera.hidden = YES;
    [_timerCameraBtn invalidate];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    if (!self.isOnFirstPage) //no need to slide in on first page
        [self slideWebView:theWebView withSlideIN:YES];
    //    NSLog(@"5. contentSize: %f",webStuff2.scrollView.contentSize.height);
}

- (void) slideWebView: (UIWebView *)theWebView withSlideIN:(BOOL)isSlideIn
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    int w = screenBounds.size.width;
    
    CGRect frameInside = CGRectMake(0, 20, w, theWebView.frame.size.height);
    CGRect frameOutsideLeft = CGRectMake(-w, 20, w, theWebView.frame.size.height);
    CGRect frameOutsideRight = CGRectMake(w, 20, w, theWebView.frame.size.height);
    
    if (isSlideIn) {
        theWebView.frame = frameOutsideLeft;
        [UIView animateWithDuration:TIME_SLIDE_DELAY
                         animations:^{
                             theWebView.frame = frameInside;
                         }];
    } else {
        theWebView.frame = frameInside;
        [UIView animateWithDuration:TIME_SLIDE_DELAY
                         animations:^{
                             theWebView.frame = frameOutsideRight;
                         }];
    }
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
    NSArray *ph = self.pagesHints[self.currPage];
    if ([ph count]==0 || self.currHintsAvailable<1) {
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
        NSDictionary *aDict = @{@"continueOnPage" : self.pagesId[self.currPage],
                                @"pagesViewed" : [NSNumber numberWithInt:(int)0],
                                @"hintsLeft" : _quest.allowedHints};
        //saving stuff:
        [[NSUserDefaults standardUserDefaults] setObject:aDict forKey:questStatePath];
        
        self.currHintsAvailable = [_quest.allowedHints integerValue];
    }
}

- (void) saveDict: (NSString *)questStatePath {
    //only if logged in, got pagesId
    if (self.pagesId!= nil && _quest!=nil) {
        NSDictionary *aDict = @{@"continueOnPage" : self.pagesId[self.currPage],
                                @"pagesViewed" : [NSNumber numberWithInt:(int)self.pagesViewed],
                                @"hintsLeft" : [NSNumber numberWithInt:(int)self.currHintsAvailable]};
        //saving stuff:
        [[NSUserDefaults standardUserDefaults] setObject:aDict forKey:questStatePath];
    }
}


//-(void)buttonNormal:(id)sender {
//    switch([sender tag]) {
//        case 1000:
//            self.buttonLeft.backgroundColor = QUESITY_COLOR_BG;
//            break;
//        case 1001:
//            self.buttonMiddle.backgroundColor = QUESITY_COLOR_BG;
//            break;
//        default:
//            break;
//    }
//}
//
//-(void)buttonHighlight:(id)sender {
//    switch([sender tag]) {
//        case 1000:
//            self.buttonLeft.backgroundColor = [UIColor whiteColor];
//            break;
//        case 1001:
//            self.buttonMiddle.backgroundColor = [UIColor whiteColor];
//            break;
//        default:
//            break;
//    }
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
    
//    [self.buttonLeft addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
//    [self.buttonLeft addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonLeft.tag = 1000;

    UITapGestureRecognizer *singleFingerTapLeft =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(didPressButtonMore2:)];
    
    [self.buttonLeft addGestureRecognizer:singleFingerTapLeft];
    
    [self.view addSubview:self.buttonLeft];
    
    // got it button:
    self.buttonMiddle = [[buttonView buttonView] initWithBorders:TRUE];
    self.buttonMiddle.frame = CGRectMake(106.66f, screenBounds.size.height - 60, 106.66f, 60.f);
    self.buttonMiddle.buttonText.text = NSLocalizedString(@"Continue", nil);
    self.buttonMiddle.buttonText.font = [UIFont fontWithName:NSLocalizedString(@"Andada-Regular",nil) size:18];
         
    [self.buttonMiddle.img setImage:[UIImage imageNamed:@"continue.png"]];
    self.buttonMiddle.tag = 1001;
//    [self.buttonMiddle addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
//    [self.buttonMiddle addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];

//    [self.buttonMiddle addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
//    [self.buttonMiddle addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    myUtilities *myUtils = [[myUtilities alloc] init];
    [myUtils sendScreenToGA:[@"Quest Page View " stringByAppendingString: _quest.name]];
    [myUtils sendEventToGA: @"Quest event" withAction: @"Quest started" withLabel:_quest.name];
    
    self.isOnFirstPage = YES;
    
    _pagesStack = [[QSCStack alloc] init];
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
            NSString *pagesViewed = [stateDict objectForKey:@"pagesViewed"];

            //check that the questState is "takin"
            if (continueOnPage==nil || hintsLeft==nil) {
                [self saveDefaultDict:questStatePath];
                //reload:
                stateDict = [[NSUserDefaults standardUserDefaults] objectForKey: questStatePath];
            }
            
            self.currHintsAvailable = [[stateDict objectForKey:@"hintsLeft"] integerValue];
            
            if (pagesViewed == nil) {
                self.pagesViewed = 0;
            } else {
                self.pagesViewed = [pagesViewed integerValue];
            }
                
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

    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
//    [locationManager startUpdatingLocation];
//    [self->locationManager startUpdatingLocation];
    
//    // Create the overlay view just like you have it...
//    UIView *overlay = [[UIView alloc] initWithFrame:parentView.frame];
//    overlay.backgroundColor = [UIColor blackColor];
//    overlay.alpha = 0.6;
//    
//    // Continue adding this to the parent view
//    [parentView addSubview:overlay];
    
    [super viewDidLoad];
    
    // Create the button
    _buttonCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    [_buttonCamera setFrame:CGRectMake(screenBounds.size.width-55, 100, 45.0, 45.0)];
    [_buttonCamera setImage:[UIImage imageNamed:@"camera-icon.png"] forState:UIControlStateNormal];
    //[_buttonCamera setBackgroundColor:[UIColor clearColor]];
    [_buttonCamera setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:CAMERA_BTN_BG_ALPHA]];
    _buttonCamera.alpha = CAMERA_BTN_ALPHA;
    _buttonCamera.layer.cornerRadius = 10;
    _buttonCamera.clipsToBounds = YES;

    _buttonCamera.hidden = YES;
    [_buttonCamera addTarget:self action:@selector(takeAPicture) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *singleFingerTap4Camera = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(didTapOnWebView:)];
    singleFingerTap4Camera.delegate = self;
    [self.webStuff2 addGestureRecognizer:singleFingerTap4Camera];
    
    [self.view addSubview:_buttonCamera];
    
    [self didTapOnWebView:self];
}

- (void) takeAPicture {
    // Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        imagePicker.showsCameraControls = YES;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }

    // Delegate is self
    imagePicker.delegate = self;
    
    //imagePicker.allowsEditing = YES;
    
    // Show image picker
    [self presentViewController:imagePicker animated:YES completion:NULL];
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

    if (self.currQType==page_STATIC) {
        [_pagesStack push:[NSNumber numberWithInteger:self.currPage]];
        //NSLog(@"pushed.");
    } else {
        [_pagesStack clear];
        //NSLog(@"cleared.");
    }
    
    self.isOnFirstPage = NO;
    NSUInteger nextPage = [self findID:[self parseJsonOfLinks:self.linkBeingProcessed]];
    self.currPage = nextPage;

    NSString *currQTypeString = [self.pagesQType objectAtIndex:self.currPage];
    self.currQType = [self string2PageType:currQTypeString];
    
    self.pagesViewed++;
    
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
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = NSLocalizedString(@"Checking Answer...",nil);

        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIME_CHECKING_ANSWER * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
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
        });
        
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
    //[alertTextField setReturnKeyType:UIReturnKeyDone];
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
        if ([self.currCorrectAnswers[i] length]>33)
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

- (void) skipAPage {
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
}

- (void) goOnePageBack {
    self.currPage = [[_pagesStack pop] integerValue];
    //NSLog(@"popped.");

    NSString *currQTypeString = [self.pagesQType objectAtIndex:self.currPage];
    self.currQType = [self string2PageType:currQTypeString];
    
    self.pagesViewed--;
    
    [self createWebViewWithHTML];
    [self updateHintButtonStatus];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (popup.tag==1) {
        NSArray *lto = self.linksToOthers[self.currPage];
        if (buttonIndex!=[lto count]) {
//            NSLog(@"Chose: %@",self.currCorrectAnswers[buttonIndex]);
            NSArray *links = self.linksToOthers[self.currPage];
            self.linkBeingProcessed = links[buttonIndex];
            [self goToNextPage];
        }
    } else if (popup.tag==2) {
//        NSString *opt2 =  @"back to previous page";
//        NSString *opt3 =  @"צא מהקווסט";
//        NSString *opt4 =  @"cheat and skip page. ha!";
//        NSString *opt5 =  @"cheat and go to the end. ha ha!";

        if (isDbgMode) {
            if (_pagesStack.count>0) {
                //opt2, opt3, opt4, opt5, nil
                if (buttonIndex==0) {
                    //NSLog(@"one page back!");
                    [self goOnePageBack];

                } else if (buttonIndex==1) {
                    //NSLog(@"Exit quest!");
                    [self back:nil];
                
                } else if (buttonIndex==2) {
                    //NSLog(@"go to next page!");
                    [self skipAPage];
                
                } else if (buttonIndex==3) {
                    //NSLog(@"Finish quest!");
                    [self segueToFinish];
                }
            } else {
                //opt3, opt4, opt5, nil
                if (buttonIndex==1) {
                    //NSLog(@"Exit quest!");
                    [self back:nil];
                
                } else if (buttonIndex==2) {
                    //NSLog(@"go to next page!");
                    [self skipAPage];
                    
                } else if (buttonIndex==3) {
                    //NSLog(@"Finish quest!");
                    [self segueToFinish];
                }
            }
        } else {
            if (_pagesStack.count>0) {
                //opt2, opt3, nil
                if (buttonIndex==0) {
                    //NSLog(@"one page back!");
                    [self goOnePageBack];
                    
                } else if (buttonIndex==1) {
                    //NSLog(@"Exit quest!");
                    [self back:nil];
                }
            } else {
                //opt3, nil
                if (buttonIndex==1) {
                    //NSLog(@"Exit quest!");
                    [self back:nil];
                }
            }
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


- (IBAction)returnToStepOne:(UIStoryboardSegue *)segue {
//    NSLog(@"And now we are back.");
}

- (IBAction)segueToFinish
{
    QSCFinishPageVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FinishPage"];
    vc.quest = self.quest;
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)didPressButton2:(id)sender {
    NSArray *links = self.linksToOthers[self.currPage];
//    NSLog(@"there are %d links from here",links.count);
//    NSLog(@"yo! %@",links);
    
    if (self.currQType==page_STATIC /*|| self.currQType==page_LOCATION || self.currQType==page_OPEN_QUESTION*/) {
        if ([links count]==0) {
            [self segueToFinish];
            NSLog(@"Should hide button back?"); //TODO
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

- (IBAction)didPressButtonMore2:(id)sender {
    NSString *opt2 = NSLocalizedString(@"Back to previous page",nil);
    NSString *opt3 = NSLocalizedString(@"Leave Quest",nil);
    NSString *opt4 = NSLocalizedString(@"Skip to the next page. Ha!",nil);
    NSString *opt5 = NSLocalizedString(@"Skip to the the end. Ha Ha!",nil);

    IBActionSheet *popup;
    if (isDbgMode) {
        popup = [[IBActionSheet alloc] initWithTitle: nil
                                            delegate: self
                                   cancelButtonTitle: NSLocalizedString(@"Cancel", nil)
                              destructiveButtonTitle: nil
                                   otherButtonTitles: opt2, opt3, opt4, opt5, nil];

        if (_pagesStack.count==0) {
            [popup setButtonTextColor:[UIColor grayColor] forButtonAtIndex:0];
        }
    } else {

        popup = [[IBActionSheet alloc] initWithTitle: nil
                                            delegate: self
                                   cancelButtonTitle: NSLocalizedString(@"Cancel", nil)
                              destructiveButtonTitle: nil
                                   otherButtonTitles: opt2, opt3, nil];

        if (_pagesStack.count==0) {
            [popup setButtonTextColor:[UIColor grayColor] forButtonAtIndex:0];
        }
    }
    
    //[popup showInView:self.view];
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

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    } else { // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
//        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Wrong answer",nil)
//                                           message:NSLocalizedString(@"Wrong answer! :( try again.", nil)
//                                          delegate:nil
//                                 cancelButtonTitle:NSLocalizedString(@"OK",nil)
//                                 otherButtonTitles:nil];
    }
    [alert show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"imageInfo: %@",info);
    //took a picture
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save image
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
