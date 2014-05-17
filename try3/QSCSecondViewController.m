//
//  QSCSecondViewController.m
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCSecondViewController.h"
#import "KeychainItemWrapper.h"
#import "myGlobalData.h"

@interface QSCSecondViewController ()

@end

@implementation QSCSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)didPressSignOut:(id)sender {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Signed Out");

    myGlobalData *myGD = [[myGlobalData alloc] init];
    [myGD updateLoggedInStatus:FALSE];
    
}


- (IBAction)didPressEraseAllQuestsJson:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myData"];
}

- (IBAction)didPressEraseSavedImagesDict:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedImagesDict"];
}



@end
