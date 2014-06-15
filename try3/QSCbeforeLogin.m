//
//  QSCbeforeLogin.m
//  Quesity
//
//  Created by igor on 6/7/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCbeforeLogin.h"
#import <QuartzCore/QuartzCore.h>


@interface QSCbeforeLogin ()

@end

@implementation QSCbeforeLogin

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
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"UI-4-1.png"]];
    //self.window.backgroundColor = QUESITY_COLOR_BG_IMG; [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]

    
    self.btnRegister.layer.cornerRadius = 5;
    self.btnRegister.clipsToBounds = YES;

    self.btnLogin.layer.cornerRadius = 5;
    self.btnLogin.clipsToBounds = YES;
    
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
