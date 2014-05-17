//
//  QSCmapViewController.m
//  Quesity
//
//  Created by igor on 5/17/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCmapViewController.h"

@interface QSCmapViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
//    [self performSegueWithIdentifier:@"UnwindSegueIdentifier" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController pre]
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //QSCpage *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FinishPage"];
    
    //NSLog(@"passing title: %@",self.questTitle.text);
    //vc.questTitle = self.questTitle.text;
    //vc.quest = self.quest;
    
    //[self presentViewController:self.page animated:YES completion:nil];
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [mv setRegion:[mv regionThatFits:region] animated:YES];
}

@end
