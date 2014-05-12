//
//  QSCLoginViewController.h
//  Quesity
//
//  Created by igor on 5/8/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"

@interface QSCLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginEmail;
@property (weak, nonatomic) IBOutlet UITextField *loginPass;
@property (weak, nonatomic) IBOutlet BButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;

@property (nonatomic, weak) IBOutlet UIView *main;

@end
