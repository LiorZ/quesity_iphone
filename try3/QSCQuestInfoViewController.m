//
//  QSCQuestInfoViewController.m
//  try3
//
//  Created by igor on 2/16/14.
//  Copyright (c) 2014 igor. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "QSCQuestInfoViewController.h"
#import "QSCpage.h"
#import "HMSegmentedControl.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "myGlobalData.h"
#import "myUtilities.h"
#import "TPFloatRatingView.h"
#import "QSCPlayer.h"

@interface QSCQuestInfoViewController ()
@property (nonatomic, strong) HMSegmentedControl *segmentedControl1;
@property NSMutableArray *imgs;
@property UIActivityIndicatorView *indicator;
@property QSCQuest *questToShow;
@property BOOL gotJsonSuccefully;
@property BOOL isStartOver;
@property BOOL stopLoading;
@property NSInteger pageNum;
@property NSInteger pageNums;
@property NSInteger pagesLoaded;
@property UIWebView *wv;
@property NSInteger picsAdded;

@property float imageH;
//@property float imagesH;
@end

@implementation QSCQuestInfoViewController
@synthesize imageArray;
@synthesize quest = _quest;
@synthesize content;
@synthesize is_first;
@synthesize mapView = _mapView;


- (void)getJson
{
    NSURL *questURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/pages", SITEURL_QUEST, _quest.questId]];

    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:questURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void) parseJson2Quest:(NSArray *)json {
    NSArray* contentFromJson = [json valueForKey:@"page_content"];
    NSArray* isFirstFromJson = [json valueForKey:@"is_first"];
    NSArray* linksToOthersFromJson = [json valueForKey:@"links"];
    NSArray* pagesHintsFromJson = [json valueForKey:@"hints"];
    NSArray* pagesIdFromJson = [json valueForKey:@"_id"];
    NSArray* pagesQTypeFromJson = [json valueForKey:@"page_type"];
    
    self.content = [[NSArray alloc] init];
    self.content = contentFromJson;

    self.is_first = [[NSArray alloc] init];
    self.is_first = isFirstFromJson;
    
    self.linksToOthers = [[NSArray alloc] init];
    self.linksToOthers = linksToOthersFromJson;
    
    self.pagesHints = [[NSArray alloc] init];
    self.pagesHints = pagesHintsFromJson;
    
    self.pagesId = [[NSArray alloc] init];
    self.pagesId = pagesIdFromJson;

    self.pagesQType = [[NSArray alloc] init];
    self.pagesQType = pagesQTypeFromJson;
    
    if (self.content!=nil) {
        self.gotJsonSuccefully = YES;
//        NSLog(@"got json succefully: %d",self.gotJsonSuccefully);
        self.goOnQuestButton.enabled = YES;

        if (self.loadedAllImages) {
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.timer invalidate];
        }
    }
}

- (void)fetchedData:(NSData *)responseData {
    if (responseData!=nil) {
        //parse out the json data
        NSError* error;
        NSArray* json = [NSJSONSerialization
                         JSONObjectWithData:responseData
                         options:kNilOptions
                         error:&error];
        
        //if (error==nil)
        [self parseJson2Quest:json];
    }
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
//	NSLog(@"yo");
}

- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
//	NSLog(@"yo yo");
}


- (void)viewDidAppear:(BOOL)animated {
    if (self.pagesLoaded == self.pageNums)
        self.pageNum = 0;
    
    //user wasn't signed in. he logged in and got back to the view. need to retrive json.
    if (!self.gotJsonSuccefully) {
        [self getJson];
    } else {
        [self getJson];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        //NSLog(@"No patiance. navigating away.");
        self.stopLoading = YES;
        
        //stop stuff that might be running
        [self.timer invalidate];
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}


- (void)addImgToSubview: (NSArray *)inputArray {
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    int w = screenBounds.size.width;
    
    UIImage *img = [inputArray objectAtIndex:0];
    int idx = [[inputArray objectAtIndex:1] intValue]-1;

    //CGFloat xOrigin = idx * self.view.frame.size.width;
    CGFloat xOrigin = idx * w;
    UIImageView *image = [[UIImageView alloc] initWithFrame:
                          CGRectMake(xOrigin, 0, w, _imageH)];
    image.image = img;
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;

    [self.scrollView1 addSubview:image];

    self.picsAdded++;
    
    if ((self.picsAdded==_quest.imagesLinks.count-1) || (!_quest.imagesLinks || _quest.imagesLinks.count==0)){
        self.loadedAllImages = YES;
        
        //set the scroll view content size
        self.scrollView1.contentSize = CGSizeMake(w * (_quest.imagesLinks.count-1), _imageH);

        //add the scrollview to this view
        [self.view addSubview:self.scrollView1];
        
        [self.view bringSubviewToFront:self.myPageControl];
        self.myPageControl.currentPage = 0;
        self.myPageControl.numberOfPages = _picsAdded;
        if (_quest.imagesLinks.count<=2) {
            self.myPageControl.hidden = YES;
        }

        self.imgsTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_TO_SWITCH_IMAGE
                                                          target:self
                                                        selector:@selector(scrollToNextImg)
                                                        userInfo:nil
                                                         repeats:YES];
        
        [self.timer invalidate];
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = NO;
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
    
}


- (void) setImagesScrollView
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    int w = screenBounds.size.width;
    
    //add the scrollview to the view
    self.scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, IMAGE_Y_START, w, _imageH)];
    self.scrollView1.pagingEnabled = YES;
    self.scrollView1.contentSize = CGSizeMake(([_quest.imagesLinks count]-1)*w, _imageH);
    
    self.scrollView1.delegate = self;
    self.scrollView1.showsHorizontalScrollIndicator = NO;
    
    [self.scrollView1 setAlwaysBounceVertical:NO];
    
    [self.navigationController.view bringSubviewToFront:self.hud];
    //[self.scrollView1 bringSubviewToFront:self.hud];

    //in case there's no images (except for the quest image) then duplicate it for the quest info
    if ([_quest.imagesLinks count]==1)
        _quest.imagesLinks = [[NSArray alloc] initWithObjects:_quest.imagesLinks[0],_quest.imagesLinks[0],nil];
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    myUtilities *myUtils = [[myUtilities alloc] init];
    
    if (_quest.imagesLinks && [_quest.imagesLinks count]>0) {
        dispatch_queue_t imageLoadingQueue = dispatch_queue_create("imageLoadingQueue", NULL);
        //we start from 1 instead of 0 because the first image is for the "quest icon"
        for (NSInteger i = 1; i < [_quest.imagesLinks count]; i++) {
            NSString *imgName = [myUtils getFileFromPath:_quest.imagesLinks[i]];
            //NSLog(@"fileName: %@",imgName);
            
            NSString *pathForImg = [myUtils getPathForSavedImage:imgName withQuestId:_quest.questId];
            //NSLog(@"path: %@",pathForImg);
            
            dispatch_async(imageLoadingQueue, ^{
                UIImage *img;
                if (pathForImg!=nil) {
                    img = [myUtils loadImage:pathForImg inDirectory:documentsDirectoryPath];
                } else {
                    img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_quest.imagesLinks[i]]]];
                    
                    [myUtils saveImage:img
                          withFileName:[NSString stringWithFormat:@"%@_%@", _quest.questId, imgName]
                           inDirectory:documentsDirectoryPath];
                    
                    [myUtils addPathForSavedImage:imgName withQuestId:_quest.questId];
                }
                if (img!=nil) {
                    [self performSelectorOnMainThread:@selector(addImgToSubview:)
                                           withObject:@[img,[NSNumber numberWithInt:(int)i]]
                                        waitUntilDone:YES];
                }
                //            } else {
                //                [self.timer invalidate];
                //                [self showMsgAndGoBack];
                //                self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                //                                                              target:self
                //                                                            selector:@selector(showMsgAndGoBack)
                //                                                            userInfo:nil
                //                                                             repeats:NO];
                //            }
            });
        }
    } else {
        UIImage *img = [UIImage imageNamed:@"no_image_found.jpg"];
        [self performSelectorOnMainThread:@selector(addImgToSubview:)
                               withObject:@[img,[NSNumber numberWithInt:(int)1]]
                            waitUntilDone:YES];
    }
}

- (void)viewDidLoad
{
   
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    _imageH = screenBounds.size.width/1.62;

    [super viewDidLoad];

    self.isStartOver = YES;
    self.goOnQuestButton.enabled = NO;
    self.loadedAllImages = NO;
    self.stopLoading = NO;
    
    //cancel the swipe gesture that pops to the previous view...
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    //buying quest stuff:
    _player = [[QSCPlayer alloc] initWithLoad];
    if (![_player isBoughtQuests:_quest.questId] && (_quest.codeReq!=CODE_REQ_free))
        self.goOnQuestButton.title = NSLocalizedString(@"Enter Code", nil);
    
    //self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    //SEGMENTED SELECTOR:
    
    CGFloat yDelta;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        yDelta = 20.0f+48.f;
    } else {
        yDelta = 0.0f+48.f;
    }
    
    UILabel *distLabel = (UILabel *)[self.view viewWithTag:210];
    distLabel.text = [NSString stringWithFormat:@"%@", _quest.durationT];
   
    UILabel *museumLabel = (UILabel *)[self.view viewWithTag:225];
    museumLabel.text = _quest.startLoc.street;
    
    //SEGMENTED CONTROL
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float lowerPartHeight = screenBounds.size.height-(290+yDelta);
    
    //_imagesH = 0.4*screenBounds.size.height;
    
    myUtilities *myUtils = [[myUtilities alloc] init];
    
    //DESCRIPTION VIEW:
    
    UIWebView *webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(0, screenBounds.size.width - 2, screenBounds.size.width, lowerPartHeight+40)];
    
    NSMutableString *html;
    if ([myUtils isRTL:_quest.description])
        html = [NSMutableString stringWithString: @"<html dir=\"rtl\" lang=\"he\" align=right background-color: transparent;>"];
    else
        html = [NSMutableString stringWithString: @"<html lang=\"en\" align=left background-color: transparent;>"];
    
    [html appendString:_quest.description];
    [html appendString:@"</html>"];
    
    //make the background transparent
    [webView1 setBackgroundColor:[UIColor clearColor]];
    [webView1 setOpaque:NO];
    //pass the string to the webview
    [webView1 loadHTMLString:[html description] baseURL:nil];
    webView1.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView1];
    
    //IMAGES LOADING PROGRESS:
    //draw progrees:
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    //hud.mode = MBProgressHUDModeDeterminate;
    self.hud.labelText = @"Loading...";
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_FOR_CONNECTION
                                                  target:self
                                                selector:@selector(showMsgAndGoBack)
                                                userInfo:nil
                                                 repeats:NO];
    
    [self setImagesScrollView];
}

- (void) showMsgAndGoBack {

    [self.timer invalidate];

    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error connecting to network", nil)
                                                    message:NSLocalizedString(@"Please try again with an active internet connection.",nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    alert.tag = 42;
//    NSLog(@"tag: %d",alert.tag);
    [alert show];
}


- (void)setApperanceForLabel:(UILabel *)label {
//    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//    UIColor *color = [UIColor clearColor];//[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = QUESITY_COLOR_FONT;//[UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:21.0f];
    label.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat pageWidth = scrollView.frame.size.width;
//    NSInteger page = scrollView.contentOffset.x / pageWidth;
//    
//    // Update the page control
//    self.myPageControl.currentPage = page;
    
    //[self.segmentedControl1 setSelectedSegmentIndex:page animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.imgsTimer invalidate];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) scrollToNextImg {
    
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView1.frame.size.width;
    int page = floor((self.scrollView1.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    int totPages = (int)_quest.imagesLinks.count-1;
    int nextPage = (page+1)%totPages;

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    int w = screenBounds.size.width;
    
    [self.scrollView1 setContentOffset:CGPointMake(nextPage*w, self.scrollView1.contentOffset.y) animated:YES];

    self.myPageControl.currentPage = nextPage;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView1.frame.size.width;
    int page = floor((self.scrollView1.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.myPageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)QSCpageDidSave:(QSCpage *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadPage:(NSInteger)pageNum {
    //load page. on finish, load next. until no more
    
    //create the string concatenated
    NSMutableString *html = [NSMutableString stringWithString: @"<html><body style='padding:0; margin:0'>"];
    
    //continue building the string
    if (self.content[pageNum] == Nil)
        [html appendString:@"first, please log in?"];
    else
        [html appendString:self.content[pageNum]];
    [html appendString:@"</body></html>"];
    
    html = [NSMutableString stringWithString:[html stringByReplacingOccurrencesOfString:@"<p>" withString:@""]];
    html = [NSMutableString stringWithString:[html stringByReplacingOccurrencesOfString:@"</p>" withString:@""]];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_FOR_CONNECTION target:self selector:@selector(showMsgAndGoBack) userInfo:nil repeats:NO];
    [self.wv loadHTMLString:[html description] baseURL:nil];

}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [self.timer invalidate];

    //for the case the user presses back in the middle of the loading
    if (!self.stopLoading) {
        
        self.hud.progress = self.pageNum*1.0/PAGES_TO_PRELOAD;
        [self.view bringSubviewToFront:self.hud];
        
        self.pageNum++;
        self.pagesLoaded++;
        //NSLog(@"loaded %ld (out of %d)", (long)self.pageNum, self.pageNums);
        
//        if (self.pageNum<self.pageNums) {
//            [self loadPage:self.pageNum];
//        } else {
//            [self.view bringSubviewToFront:self.hud];
//            [self performSegueWithIdentifier:@"goOnQuest" sender:self];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            
//            UIApplication* app = [UIApplication sharedApplication];
//            app.networkActivityIndicatorVisible = NO;
//            self.pageNum = 0;
//        }
        
        if (self.pagesLoaded<PAGES_TO_PRELOAD) {
            [self loadPage:self.pageNum];
        } else {
            if (self.pagesLoaded==PAGES_TO_PRELOAD) {
                [self.imgsTimer invalidate];
                [self.view bringSubviewToFront:self.hud];
                [self performSegueWithIdentifier:@"goOnQuest" sender:self];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            
            //keep the hud on top
            if (self.pageNum<self.pageNums) {
                [self loadPage:self.pageNum];
            } else {
                UIApplication* app = [UIApplication sharedApplication];
                app.networkActivityIndicatorVisible = NO;
                self.pageNum = 0;
            }
        }
    }
}


- (void)loadQuestsAndGo {

    self.goOnQuestButton.enabled = NO;
    self.pagesLoaded = 0;
    
    if (!isPreCacheQuest) {
        [self.imgsTimer invalidate];
        [self.timer invalidate];
        [self performSegueWithIdentifier:@"goOnQuest" sender:self];
    } else {
        self.pageNums = [self.content count];
        self.wv = [[UIWebView alloc] init];
        self.wv.delegate = self;
        
        //IMAGES LOADING PROGRESS:
        //draw progrees:
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeAnnularDeterminate;
        self.hud.labelText = @"Loading Quest ...";
        
        [self loadPage:0];
    }
}


- (void) checkCode:(NSString *)code2check {
        NSDictionary *dict2check = [[NSDictionary alloc] initWithObjectsAndKeys:
                             code2check, @"code",
                             nil];
        
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
        NSError *error1;
        NSData *postdata = [NSJSONSerialization dataWithJSONObject:dict2check options:0 error:&error1];
        NSString *fullURL = SITEURL_VALIDATE_CODE;
        
        NSURL *url = [NSURL URLWithString:fullURL];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postdata];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSHTTPURLResponse* response;
        NSError* error = nil;
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        int responseCode = (int)[response statusCode];
    
//        NSDictionary *fields = [response allHeaderFields];
//        NSLog(@"the response code is:%d, with %d headers",responseCode, fields.count);
    
        if (responseCode==200) {
            //it's valid!
            
//            NSHTTPCookie *cookie1;
//            NSHTTPCookieStorage *storage1 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            for (cookie1 in [storage1 cookies]) {
//                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
//            }
            
            [_player addQuestToBoughtQuests:_quest.questId];
            self.goOnQuestButton.title = NSLocalizedString(@"Go On Quest!", nil);
            [self goOnQuestStuff];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry...", nil)
                                                            message:NSLocalizedString(@"badCode", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0) {
        if (buttonIndex ==0) {
            self.isStartOver = YES;
            //            NSLog(@"button: %d = Start Over",buttonIndex);
        } else {
            self.isStartOver = NO;
            //            NSLog(@"button: %d = Resume",buttonIndex);
        }
        [self loadQuestsAndGo];
    } else if (alertView.tag == 42) {
        [self dismissViewControllerAnimated:YES completion:nil];
        //[self popViewControllerAnimated:YES];
    } else if (alertView.tag == 1234) {
        if (buttonIndex == 1) { //not cancel
            //let's check the code
            _codeBought = [[alertView textFieldAtIndex:0] text];
            [self checkCode: _codeBought];
        }
    }
}

- (NSUInteger) findFirst {
    return [self.is_first indexOfObjectIdenticalTo:@(YES)];
}


- (void) registerGame {
    NSString *siteStr = [NSString stringWithFormat:@"quest/%@/game/new",_quest.questId];
    NSString *siteUrl = [SITEURL stringByAppendingString:siteStr];
    NSURL *url = [NSURL URLWithString:siteUrl];

    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    //{date_started: <CURRENT_DATE>, account_id:<ACCOUNT_ID>, code:<IF RELEVANT>}
    NSDictionary *gameDict;
    if (_quest.codeReq==CODE_REQ_code) {
        gameDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                    dateString, @"date_started",
                    [_player getName], @"account_id",
                    _codeBought, @"code",
                    nil];
    } else {
        gameDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                    dateString, @"date_started",
                    [_player getName], @"account_id",
                    nil];
    }
    
    //NSLog(@"%@",gameDict);

    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSHTTPCookie *cookie1;
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSString *playerCookieValue = _player.getCookieValue;
    //NSLog(@"playerCookieValue: %@",playerCookieValue);
    for (cookie1 in [cookieStorage cookies]) {
        //NSLog(@"value: %@", cookie1.value);
        NSString *trimmedPlayerValue = [playerCookieValue substringWithRange:NSMakeRange(12, [cookie1.value length])];
        //NSLog(@"trimmedPlayerValue: %@", trimmedPlayerValue);

        if ([cookie1.value isEqualToString:trimmedPlayerValue])
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
    }
    
    NSError *error1;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:gameDict options:0 error:&error1];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postdata];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse* response;
    NSError* error = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    int code = (int)[response statusCode];
    NSLog(@"the response code for new game is:%d",code);
    
//    NSDictionary *fields = [response allHeaderFields];
//    NSLog(@"the response code is:%d, with %d headers",code, fields.count);
}

- (void) goOnQuestStuff {

    [self registerGame];
    ////// maybe there is a saved state:
    //path of quest state:
    NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",_quest.questId];
    
    //loading quest state:
    NSDictionary* stateDict = [[NSUserDefaults standardUserDefaults] objectForKey: questStatePath];
    //    NSLog(@"loaded state dict: %@",stateDict);
    
    //check whether exists
    if (stateDict!=nil) {
        NSString *continueOnPage = [stateDict objectForKey:@"continueOnPage"];
        NSString *hintsLeft = [stateDict objectForKey:@"hintsLeft"];
        
        //check that the questState is "takin"
        if (continueOnPage!=nil && hintsLeft!=nil) {
            
            NSUInteger currPage = [self findFirst];
            
            if (![self.pagesId[currPage] isEqualToString:continueOnPage]) {
                
                //ask question (and check):
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:NSLocalizedString(@"resume or start over?", nil)
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"Start Over",nil)
                                                       otherButtonTitles:NSLocalizedString(@"Resume",nil), nil];
                
                alert.alertViewStyle = UIAlertViewStyleDefault;
                alert.tag = 0;
                [alert show];
                
                //                NSLog(@"what to do?");
            } else {
                self.isStartOver = YES;
                [self loadQuestsAndGo];
            }
        } else {
            self.isStartOver = YES;
            [self loadQuestsAndGo];
        }
    } else {
        self.isStartOver = YES;
        [self loadQuestsAndGo];
    }
}

- (IBAction)didGoingOnAQuest:(id)sender {
    
    if ([_player isBoughtQuests:_quest.questId])
        [self goOnQuestStuff];

    else if (_quest.codeReq==CODE_REQ_free) {
        [_player addQuestToBoughtQuests:_quest.questId];
        [self goOnQuestStuff];
    
    } else {
        //ask question (and check):
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"This quest requires a code",nil)
                                                         message:NSLocalizedString(@"accessCodeRequest", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                               otherButtonTitles:NSLocalizedString(@"Go On Quest!",nil), nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.placeholder = NSLocalizedString(@"Access code",nil);
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        alert.tag = 1234;
        [alert show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goOnQuest"]) {
        
        //if (!self.gotJsonSuccefully)
            //[self getJson];
            //TODO: load json syncroneously (WITH block)

        //QSCpage *qscpage = [[QSCpage alloc] init];
        //[self presentViewController:qscpage animated:YES completion:^{}];

        QSCpage *destViewController = [segue destinationViewController];
        QSCpage *qscpage = destViewController;

        qscpage.content = self.content;
        qscpage.is_first = self.is_first;
        qscpage.linksToOthers = self.linksToOthers;
        qscpage.pagesHints = self.pagesHints;
        qscpage.pagesId = self.pagesId;
        
        qscpage.quest = self.quest;
        qscpage.pagesQType = self.pagesQType;

        qscpage.isStartOver = self.isStartOver;

        qscpage.delegate = self;
    }
}


#pragma mark - map view delegate
- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    //[mv setRegion:[mv regionThatFits:region] animated:YES];
    [self zoomToFitMapAnnotations:mv];
}


/*- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];

    UIImage *img = [UIImage imageNamed:@"map-pin.png"];
    //UIImage *imgResized = [ImageUtilities imageWithImage:img];
    //CGImageRef imgRef = [img CGImage];

    annotationView.image = img;
    
    annotationView.annotation = annotation;
    
    return annotationView;
}*/


- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    [self zoomToFitMapAnnotations:mv];
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mv {
    if ([mv.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mv.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.4; //1.1
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.4; //1.1
    
    region = [mv regionThatFits:region];
    [mv setRegion:region animated:YES];
}

@end
