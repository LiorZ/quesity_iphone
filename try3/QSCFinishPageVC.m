//
//  QSCFinishPageVC.m
//  Quesity
//
//  Created by igor on 5/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCFinishPageVC.h"
#import "myGlobalData.h"
#import "myUtilities.h"
#import "TPFloatRatingView.h"
#import "QSCratingViewController.h"

@interface QSCFinishPageVC ()

@end

@implementation QSCFinishPageVC

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = QUESITY_COLOR_BG;
    
//    self.titleLabel.text = self.quest.name;
    
    myUtilities *myUtils = [[myUtilities alloc] init];
    [self.view addSubview:[myUtils drawLine:CGRectMake(10.f, 430.f, 300.f, 0.5f)]];
    [self.view addSubview:[myUtils drawLine:CGRectMake(10.f, 495.f, 300.f, 0.5f)]];
    
    UILabel *questNameLabel = (UILabel *)[self.view viewWithTag:105];
    questNameLabel.text = self.quest.name;

    UIImageView *questImg = [[UIImageView alloc] initWithFrame:CGRectMake(60.0, 180.0, 200.0, 200.0)];
    questImg.image = self.quest.img;
    questImg.layer.cornerRadius = 100.0f;
    questImg.clipsToBounds = YES;
    [self.view addSubview:questImg];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //rating stuff:
    self.rv  =[[TPFloatRatingView alloc] initWithFrame:CGRectMake(100.f, 465.0, 120.f, 60.f)];
    self.rv.delegate = self;
    self.rv.emptySelectedImage = [UIImage imageNamed:@"star-empty"];
    self.rv.fullSelectedImage = [UIImage imageNamed:@"star-full"];
    self.rv.contentMode = UIViewContentModeScaleAspectFill;
    self.rv.maxRating = 5;
    self.rv.minRating = 1;
    self.rv.rating = 2.5;
    self.rv.editable = YES;
    self.rv.halfRatings = YES;
    self.rv.floatRatings = NO;
    
    [self.view addSubview:self.rv];
    
    self.opinion = @"";
//    
//    self.rv.delegate = self;
//    self.rv.emptySelectedImage = [UIImage imageNamed:@"star-empty"];
//    self.rv.fullSelectedImage = [UIImage imageNamed:@"star-full"];
//    self.rv.contentMode = UIViewContentModeScaleAspectFill;
//    self.rv.maxRating = 5;
//    self.rv.minRating = 1;
//    self.rv.rating = 2.5;
//    self.rv.editable = YES;
//    self.rv.halfRatings = YES;
//    self.rv.floatRatings = NO;

    
    
}

//- (IBAction)didPressRatingView:(id)sender {
//    [self segueToRatingView: sender];
//}

//- (IBAction)segueToRatingView: (id)sender
//{
//    [self performSegueWithIdentifier:@"showRatingView" sender:self];
//}

- (IBAction)returnToFinishPage:(UIStoryboardSegue *)segue {
    QSCratingViewController* sourceViewController = segue.sourceViewController;

    self.rv.rating = sourceViewController.rv.rating;
    self.opinion = sourceViewController.opinion.text;
    
    NSLog(@"And now we are again on finish page.");
}

#pragma mark - TPFloatRatingViewDelegate
- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating
{
    [self performSegueWithIdentifier:@"showRatingView" sender:self];

    NSLog(@"open rating view.");
    
}

- (void)floatRatingView:(TPFloatRatingView *)ratingView continuousRating:(CGFloat)rating
{
    NSLog(@"%@",[NSString stringWithFormat:@"%.2f", rating]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showRatingView"]) {
        QSCratingViewController *destViewController = [[segue.destinationViewController viewControllers] firstObject];
        destViewController.startWithOpinion = self.opinion;
        destViewController.startWithRating = [NSNumber numberWithFloat:self.rv.rating];
    }
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
