//
//  QSCinfoViewController2.m
//  try3
//
//  Created by igor on 2/17/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCinfoViewController2.h"

@interface QSCinfoViewController2 ()
@property UIScrollView *scrollView;
@end

@implementation QSCinfoViewController2

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

	_scrollView.clipsToBounds = NO;
	_scrollView.pagingEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
	
	CGFloat contentOffset = 0.0f;
	NSArray *imageFilenames = [NSArray arrayWithObjects:@"pic0.jpg",
							   @"pic1.jpg",
							   nil];
    
	for (NSString *singleImageFilename in imageFilenames) {
		CGRect imageViewFrame = CGRectMake(contentOffset, 0.0f, _scrollView.frame.size.width, _scrollView.frame.size.height);
        
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
		imageView.image = [UIImage imageNamed:singleImageFilename];
		imageView.contentMode = UIViewContentModeCenter;
		[_scrollView addSubview:imageView];
		//[imageView release];
        
		contentOffset += imageView.frame.size.width;
		_scrollView.contentSize = CGSizeMake(contentOffset, _scrollView.frame.size.height);
	}
//    //add the scrollview to the view
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,
//                                                                     self.view.frame.size.width,
//                                                                     self.view.frame.size.height)];
//    self.scrollView.pagingEnabled = YES;
//    [self.scrollView setAlwaysBounceVertical:NO];
//    //setup internal views
//    NSInteger numberOfViews = 2;
//    for (int i = 0; i < numberOfViews; i++) {
//        CGFloat xOrigin = i * self.view.frame.size.width;
//        UIImageView *image = [[UIImageView alloc] initWithFrame:
//                              CGRectMake(xOrigin, 0,
//                                         self.view.frame.size.width,
//                                         self.view.frame.size.height)];
//        image.image = [UIImage imageNamed:[NSString stringWithFormat:
//                                           @"pic_%d.jpg", i+1]];
//        image.contentMode = UIViewContentModeScaleAspectFit;
//        [self.scrollView addSubview:image];
//    }
//    //set the scroll view content size
//    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width *
//                                             numberOfViews,
//                                             self.view.frame.size.height);
//    //add the scrollview to this view
//    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
