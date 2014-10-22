//
//  QSCmapViewController.m
//  Quesity
//
//  Created by igor on 5/17/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCmapViewController.h"

@interface QSCmapViewController ()
@property BOOL isCenterd;
@end

@implementation QSCmapViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myMAp.delegate = self;
    self.isCenterd = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
}

- (IBAction)back:(id)sender {
    [self performSegueWithIdentifier:@"returnToStepOne" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - map view delegate
- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.isCenterd) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 250, 250);
        [mv setRegion:[mv regionThatFits:region] animated:YES];
        self.isCenterd = YES;
    }
}


@end
