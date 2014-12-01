//
//  QSCFinishPageVC.h
//  Quesity
//
//  Created by igor on 5/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSCQuest.h"
#import "TPFloatRatingView.h"

@interface QSCFinishPageVC : UIViewController <TPFloatRatingViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//@property IBOutlet NSString *questTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UILabel *howWasItLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnShare;

@property IBOutlet QSCQuest *quest;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *rv;
@property (nonatomic, copy) NSString *opinion;

@end
