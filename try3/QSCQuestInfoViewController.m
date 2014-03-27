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
#import "HMSegmentedControl/HMSegmentedControl.h"

@interface QSCQuestInfoViewController ()
@property (nonatomic, strong) UIScrollView *scrollView1;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl1;
@end

@implementation QSCQuestInfoViewController
@synthesize scrollView = _scrollView;
@synthesize imageArray;
@synthesize pageControl = _pageControl;
@synthesize quest = _quest;
@synthesize content;
@synthesize is_first;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)getJson
{
    NSURL *questURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/pages", SITEURL, _quest.questId]];
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: questURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
}

- (void) parseJson2Quest:(NSArray *)json {
    NSArray* contentFromJson = [json valueForKey:@"page_content"];
    NSArray* isFirstFromJson = [json valueForKey:@"is_first"];
    
    self.content = [[NSArray alloc] init];
    self.content = contentFromJson;

    self.is_first = [[NSArray alloc] init];
    self.is_first = isFirstFromJson;
    
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData
                     options:kNilOptions
                     error:&error];
    
    [self parseJson2Quest:json];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
	NSLog(@"yo");
}

- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
	NSLog(@"yo yo");
}

-(void)loadSegmentedControl
{
    
}

- (BOOL)isRTL {
    return ([NSLocale characterDirectionForLanguage:[[NSLocale preferredLanguages] objectAtIndex:0]] == NSLocaleLanguageDirectionRightToLeft);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    

    UITextView *textView1 = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 210)];
    textView1.text = [NSString stringWithFormat:@"\u202B%@", _quest.description]; //for right-to-left
    textView1.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView1.scrollEnabled = true;
    textView1.textAlignment = NSTextAlignmentRight;
    
    //[self setApperanceForLabel:label1];
    //label1.text = @"Worldwide";
    [self.scrollView1 addSubview:textView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, 320, 210)];
    [self setApperanceForLabel:label2];
    label2.text = @"la la";
    [self.scrollView1 addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(640, 0, 320, 210)];
    [self setApperanceForLabel:label3];
    label3.text = @"yo yo!";
    [self.scrollView1 addSubview:label3];
    
    [self.segmentedControl1 setSelectedSegmentIndex:0 animated:YES];
    
    //DESCRIPTION:
   
    //IMAGES SCROLLVIEW
    //Put the names of our image files in our array.
    self.imageArray = [[NSMutableArray alloc] initWithObjects:@"pic0.jpg", @"pic1.jpg", nil];
    
    for (int i = 0; i < [self.imageArray count]; i++) {
        //We'll create an imageView object in every 'page' of our scrollView.
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = self.scrollView.frame.origin.y;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:i]];
        [self.scrollView addSubview:imageView];
    }
    //Set the content size of our scrollview according to the total width of our imageView objects.
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.imageArray count], self.scrollView.frame.size.height);

    [self.scrollView setMinimumZoomScale:1.0];
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
        
        UINavigationController *destViewController = segue.destinationViewController;
        QSCpage *qscpage = [destViewController viewControllers][0];

        qscpage.content = self.content;
        qscpage.is_first = self.is_first;
        qscpage.quest = self.quest;

        qscpage.delegate = self;
    }
}


@end
