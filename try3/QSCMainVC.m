//
//  QSCMainVC.m
//  Quesity
//
//  Created by igor on 5/13/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCMainVC.h"

@interface QSCMainVC ()

@end

@implementation QSCMainVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    //UITabBarItem *tabBarItem = [self.tabBarController.tabBar objectAtIndex:0];
    
    // Do any additional setup after loading the view.
    [self.tabBarController.delegate tabBarController:self.tabBarController shouldSelectViewController:[[self viewControllers] objectAtIndex:1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSLog(@"ha?");
    return TRUE;
}



@end
