//
//  QSCratingViewController.h
//  Quesity
//
//  Created by igor on 5/18/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"
#import "QSCFinishPageVC.h"

@interface QSCratingViewController : UIViewController <TPFloatRatingViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet TPFloatRatingView *rv;

@property IBOutlet NSNumber *startWithRating;
@property IBOutlet NSString *startWithOpinion;

@property (weak, nonatomic) IBOutlet UITextView *opinion;
@property (weak, nonatomic) IBOutlet UITextField *defaultLabel;

@property (weak, nonatomic) IBOutlet UILabel *justALabel;

@end
