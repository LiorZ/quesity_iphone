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

@interface QSCQuestInfoViewController ()
@property (nonatomic, strong) UIScrollView *scrollView1;
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
@end

@implementation QSCQuestInfoViewController
@synthesize scrollView = _scrollView;
@synthesize imageArray;
@synthesize pageControl = _pageControl;
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
    
    if (self.isMovingFromParentViewController) {
        NSLog(@"No patiance. navigating away.");
        self.stopLoading = YES;
        
        //stop stuff that might be running
        [self.timer invalidate];
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isStartOver = YES;
    self.goOnQuestButton.enabled = NO;
    self.loadedAllImages = NO;
    self.stopLoading = NO;
    
    //cancel the swipe gesture that pops to the previous view...
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
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
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float lowerPartHeight = screenBounds.size.height-(290+yDelta);
    
    myUtilities *myUtils = [[myUtilities alloc] init];
    
    //DESCRIPTION VIEW:
    
    UIWebView *webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 318, 320, lowerPartHeight+40)];
    
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
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    //hud.mode = MBProgressHUDModeDeterminate;
    self.hud.labelText = @"Loading...";
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_FOR_CONNECTION target:self selector:@selector(showMsgAndGoBack) userInfo:nil repeats:NO];
    
    //load images async:
    picsList = [[NSMutableArray alloc] init];
    NSString *stam = @"";
    
    //in case there's no images (except for the quest image) then duplicate it for the quest info
    if ([_quest.imagesLinks count]==1)
        _quest.imagesLinks = [[NSArray alloc] initWithObjects:_quest.imagesLinks[0],_quest.imagesLinks[0],nil];
    
    dispatch_queue_t imageLoadingQueue = dispatch_queue_create("imageLoadingQueue", NULL);
    dispatch_async(imageLoadingQueue, ^{
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        //we start from 1 instead of 0 because the first image is for the "quest icon"
        for (int i = 1; i < [_quest.imagesLinks count]; i++) {
            NSString *imgName = [myUtils getFileFromPath:_quest.imagesLinks[i]];
            //NSLog(@"fileName: %@",imgName);
            
            NSString *pathForImg = [myUtils getPathForSavedImage:imgName withQuestId:_quest.questId];
            //NSLog(@"path: %@",pathForImg);
            
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
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ListItem *item = [[ListItem alloc] initWithFrame:CGRectZero image:img text:@""];
                [picsList addObject:item];
                //hud.progress = picsList.count*1.0/_quest.imagesLinks.count;
                if (picsList.count==_quest.imagesLinks.count-1) {
                    POHorizontalList *list;
                    list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 35.0, 320.0, 180.0) title:stam items:picsList];
                    [self.view addSubview:list];

                    //keep the hud on top
                    [self.view bringSubviewToFront:self.hud];
                    
                    self.loadedAllImages = YES;

                    if (self.gotJsonSuccefully) {
                        [self.timer invalidate];
                        app.networkActivityIndicatorVisible = NO;
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                }
            });
        }
    });
}


- (void) showMsgAndGoBack {

    [self.timer invalidate];

    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
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
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl1 setSelectedSegmentIndex:page animated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)QSCpageDidSave:(QSCpage *)controller
{
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
    //for the case the user presses back in the middle of the loading
    if (!self.stopLoading) {
        
        [self.timer invalidate];
        
        self.hud.progress = self.pageNum*1.0/PAGES_TO_PRELOAD;
        [self.view bringSubviewToFront:self.hud];
        
        self.pageNum++;
        self.pagesLoaded++;
        NSLog(@"loaded %d (out of %d)", self.pageNum, self.	pageNums);
        
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
    
    if (!isPreCacheQuest)
        [self performSegueWithIdentifier:@"goOnQuest" sender:self];
    else {
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
    }
}

- (NSUInteger) findFirst {
    return [self.is_first indexOfObjectIdenticalTo:@(YES)];
}



- (IBAction)didGoingOnAQuest:(id)sender {
    
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
