//
//  QSCQuestInfoViewController.h
//  try3
//
//  Created by igor on 2/16/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSCQuest.h"

@interface QSCQuestInfoViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property IBOutlet UIPageControl *pageControl;
@property IBOutlet QSCQuest *quest;
@property (nonatomic, retain) IBOutlet UITextView* textView;
@end
