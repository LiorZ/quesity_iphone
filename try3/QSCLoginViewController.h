//
//  QSCLoginViewController.h
//  Quesity
//
//  Created by igor on 5/8/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSCLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginEmail;
@property (weak, nonatomic) IBOutlet UITextField *loginPass;
//@property (weak, nonatomic) IBOutlet BButton *loginButton;

@property (nonatomic, weak) IBOutlet UIView *main;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIScrollView *scv;

@end
