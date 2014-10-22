//
//  QSCQuestInfoViewController2.h
//  try3
//
//  Created by igor on 3/27/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "SDSegmentedControl.h"

@interface QSCQuestInfoViewController2 : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentDidChange:(id)sender;
@end
