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

@interface QSCQuestInfoViewController ()

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getJson];
    
    //DESCRIPTION:
    self.textView.text = [NSString stringWithFormat:@"Description:\n %@", _quest.description];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
   
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

- (void)viewDidUnload
{
    self.textView = nil;
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
