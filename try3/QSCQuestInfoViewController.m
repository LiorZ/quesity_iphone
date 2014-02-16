//
//  QSCQuestInfoViewController.m
//  try3
//
//  Created by igor on 2/16/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCQuestInfoViewController.h"

@interface QSCQuestInfoViewController ()

@end

@implementation QSCQuestInfoViewController
@synthesize scrollView = _scrollView;
@synthesize imageArray; 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Put the names of our image files in our array.
    self.imageArray = [[NSMutableArray alloc] initWithObjects:@"pic0.jpg", @"pic1.jpg", nil];
    
    for (int i = 0; i < [self.imageArray count]; i++) {
        //We'll create an imageView object in every 'page' of our scrollView.
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:i]];
        [self.scrollView addSubview:imageView];
    }
    //Set the content size of our scrollview according to the total width of our imageView objects.
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.imageArray count], self.scrollView.frame.size.height);
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    //CGFloat pageWidth = self.scrollView.frame.size.width;
    //int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //self.pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
