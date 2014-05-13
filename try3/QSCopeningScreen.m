//
//  QSCopeningScreen.m
//  Quesity
//
//  Created by igor on 5/13/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCopeningScreen.h"
#import "QSCAllQuestsViewController2.h"
#import "QSCMyQuestsViewController2.h"

@interface QSCopeningScreen ()

@end

@implementation QSCopeningScreen

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

    self.view.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"goFindQuests"]) {
        
        UITabBarController *destViewController = segue.destinationViewController;
        [destViewController setSelectedIndex:0];

    } else if ([segue.identifier isEqualToString:@"goMyQuests"]) {
        
        UITabBarController *destViewController = segue.destinationViewController;
        [destViewController setSelectedIndex:1];
        
    }
}

@end
