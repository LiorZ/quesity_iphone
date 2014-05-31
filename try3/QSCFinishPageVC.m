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

    //robustness for iphone 4 & 5
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float pushUp = 0.f;
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
    } else {
        pushUp = 480-568;
    }
    
    myUtilities *myUtils = [[myUtilities alloc] init];
    [self.view addSubview:[myUtils drawLine:CGRectMake(10.f, pushUp + 430.f, 300.f, 0.5f)]];
    [self.view addSubview:[myUtils drawLine:CGRectMake(10.f, pushUp + 495.f, 300.f, 0.5f)]];
    
    UILabel *questNameLabel = (UILabel *)[self.view viewWithTag:105];
    questNameLabel.text = self.quest.name;

    UIImageView *questImg = [[UIImageView alloc] initWithFrame:CGRectMake(60.0, 180.0 + pushUp/2, 200.0, 200.0)];
    questImg.image = self.quest.img;
    questImg.layer.cornerRadius = 100.0f;
    questImg.clipsToBounds = YES;
    [self.view addSubview:questImg];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //rating stuff:
    self.rv  =[[TPFloatRatingView alloc] initWithFrame:CGRectMake(100.f, pushUp + 465.0, 120.f, 60.f)];
    self.rv.delegate = self;
    self.rv.emptySelectedImage = [UIImage imageNamed:@"star-empty"];
    self.rv.fullSelectedImage = [UIImage imageNamed:@"star-full"];
    self.rv.contentMode = UIViewContentModeScaleAspectFill;
    self.rv.maxRating = 5;
    self.rv.minRating = 1;
    self.rv.rating = 0;
    self.rv.editable = YES;
    self.rv.halfRatings = YES;
    self.rv.floatRatings = NO;
    
    [self.view addSubview:self.rv];
    
    self.opinion = @"";
    
    //remove the hints number and page number dictionary:
    //path of quest state:
    NSString *questStatePath = [NSString stringWithFormat:@"%@_questState",self.quest.questId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:questStatePath];
    
    
}

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


@end
