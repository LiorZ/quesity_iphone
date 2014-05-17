//
//  QSCFinishPageVC.h
//  Quesity
//
//  Created by igor on 5/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSCQuest.h"

@interface QSCFinishPageVC : UIViewController

//@property IBOutlet NSString *questTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property IBOutlet QSCQuest *quest;

@end
