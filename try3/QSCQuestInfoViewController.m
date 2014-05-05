//
//  QSCQuestInfoViewController.m
//  try3
//
//  Created by igor on 2/16/14.
//  Copyright (c) 2014 igor. All rights reserved.
//
#define SITEURL @"http://quesity.herokuapp.com/quest/"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "QSCQuestInfoViewController.h"
#import "QSCpage.h"
#import "HMSegmentedControl2/HMSegmentedControl.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"

@interface QSCQuestInfoViewController ()
@property (nonatomic, strong) UIScrollView *scrollView1;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl1;
@property NSMutableArray *imgs;
@property UIActivityIndicatorView *indicator;
@property QSCQuest *questToShow;
@property BOOL gotJsonSuccefully;
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
//    NSString *cToSend;
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSLog(@"num of cookies: %d", cookieJar.cookies.count);
    for (cookie in [cookieJar cookies]) {
        NSLog(@"%@", cookie);
        NSLog(@"spesifically, the value is: %@",cookie.value);
//        cToSend = cookie.value;
    }
    
    NSURL *questURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/pages", SITEURL, _quest.questId]];
    
//    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:questURL];
//    [request addValue:cToSend forHTTPHeaderField:@"Cookie"];
//    
//    NSHTTPURLResponse* response;
//    NSError* error = nil;
//    
//    NSData* responseData = nil;
//    responseData = [NSMutableData data];
//    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//
//    int code = [response statusCode];
//    NSLog(@"response code: %d", code);
//
//    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"Response: %@", responseString);

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
    
    self.gotJsonSuccefully = YES;
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
	NSLog(@"yo");
}

- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
	NSLog(@"yo yo");
}


- (BOOL)isRTL {
    return ([NSLocale characterDirectionForLanguage:[[NSLocale preferredLanguages] objectAtIndex:0]] == NSLocaleLanguageDirectionRightToLeft);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gotJsonSuccefully = NO;
    [self getJson];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //SEGMENTED SELECTOR:

    CGFloat yDelta;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        yDelta = 20.0f;
    } else {
        yDelta = 0.0f;
    }
    
    // Minimum code required to use the segmented control with the default styling.
    self.segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Description", @"Map", @"Reviews"]];
    self.segmentedControl1.frame = CGRectMake(0, 250 + yDelta, 320, 40);
    self.segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl1.tag = 3;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl1 setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView1 scrollRectToVisible:CGRectMake(320 * index, 0, 320, 200) animated:YES];
    }];

    [self.view addSubview:self.segmentedControl1];
    
    self.scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 290 + yDelta, 320, 210)];
    self.scrollView1.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView1.pagingEnabled = YES;
    self.scrollView1.showsHorizontalScrollIndicator = NO;
    self.scrollView1.contentSize = CGSizeMake(960, 200);
    self.scrollView1.delegate = self;
    [self.scrollView1 scrollRectToVisible:CGRectMake(320, 0, 320, 200) animated:NO];
    [self.view addSubview:self.scrollView1];
    
    //DESCRIPTION VIEW:
    
    UITextView *textView1 = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 210)];
    textView1.text = [NSString stringWithFormat:@"\u202B%@", _quest.description]; //for right-to-left
    textView1.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView1.scrollEnabled = true;
    textView1.textAlignment = NSTextAlignmentRight;
    textView1.editable = FALSE;
    
    [self.scrollView1 addSubview:textView1];
    
    //MAP:
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(320, 0, 320, 210)];
    self.mapView.delegate = self;

    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.mapView setShowsUserLocation:YES];

    double lat = [_quest.startLoc.lat doubleValue];
    double lng = [_quest.startLoc.lng doubleValue];
    //double rad = [_quest.startLoc.rad doubleValue];
    
    CLLocationCoordinate2D startPos = CLLocationCoordinate2DMake(lat, lng);
    MKPointAnnotation *startAnnotation = [[MKPointAnnotation alloc] init];
    startAnnotation.coordinate= startPos;
    startAnnotation.title = [NSString stringWithFormat:@"%@",_quest.name];
    startAnnotation.subtitle = [NSString stringWithFormat:@"%@",_quest.startLoc.street];
    [self.mapView addAnnotation:startAnnotation];
    
    //MKUserLocation *userLocation = self.mapView.userLocation;
    //NSLog(@"user loc:[%f,%f]",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    //[self zoomToFitMapAnnotations:self.mapView];
    
    [self.scrollView1 addSubview:self.mapView];
    
    //REVIEWS:
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(640, 0, 320, 210)];
    [self setApperanceForLabel:label3];
    label3.text = @"yo yo!";
    [self.scrollView1 addSubview:label3];
    
    [self.segmentedControl1 setSelectedSegmentIndex:0 animated:YES];
    
    //IMAGES LOADING PROGRESS:
    
    dispatch_queue_t imageLoadingQueue = dispatch_queue_create("imageLoadingQueue", NULL);

    //draw progrees:
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"Loading...";
    
    //load images async:
    picsList = [[NSMutableArray alloc] init];
    NSString *stam = @"";
    
    dispatch_async(imageLoadingQueue, ^{
        for (int i = 0; i < [_quest.imagesLinks count]; i++) {
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_quest.imagesLinks[i]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                ListItem *item = [[ListItem alloc] initWithFrame:CGRectZero image:img text:@""];
                [picsList addObject:item];
                //hud.progress = picsList.count*1.0/_quest.imagesLinks.count;
                if (picsList.count==_quest.imagesLinks.count) {
                    POHorizontalList *list;
                    list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 40.0, 320.0, 210.0) title:stam items:picsList];
                    [self.view addSubview:list];

                    app.networkActivityIndicatorVisible = NO;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            });
        }
    });
}


- (void)setApperanceForLabel:(UILabel *)label {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    label.backgroundColor = color;
    label.textColor = [UIColor whiteColor];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goOnQuest"]) {
        
        //if (!self.gotJsonSuccefully)
            //[self getJson];
            //TODO: load json syncroneously (WITH block)

        UINavigationController *destViewController = segue.destinationViewController;
        QSCpage *qscpage = [destViewController viewControllers][0];

        qscpage.content = self.content;
        qscpage.is_first = self.is_first;
        qscpage.linksToOthers = self.linksToOthers;
        qscpage.pagesHints = self.pagesHints;
        qscpage.pagesId = self.pagesId;
        
        qscpage.quest = self.quest;
        qscpage.pagesQType = self.pagesQType;

        qscpage.delegate = self;
    }
}


#pragma mark - map view delegate
- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [mv setRegion:[mv regionThatFits:region] animated:YES];
}


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
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mv regionThatFits:region];
    [mv setRegion:region animated:YES];
}

@end
