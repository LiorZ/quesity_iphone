//
//  QSCFinishPageVC.m
//  Quesity
//
//  Created by igor on 5/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCFinishPageVC.h"
#import "myGlobalData.h"

@interface QSCFinishPageVC ()

@end

@implementation QSCFinishPageVC

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = QUESITY_COLOR_BG;
    
    self.titleLabel.text = self.questTitle;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)didPressFinish:(id)sender {
//
//
//}

@end
