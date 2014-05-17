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
    
    //rating stuff:
    TPFloatRatingView *rv = [[TPFloatRatingView alloc] initWithFrame:CGRectMake(100.f, 465.0, 120.f, 60.f)];
    rv.emptySelectedImage = [UIImage imageNamed:@"star-empty"];
    rv.fullSelectedImage = [UIImage imageNamed:@"star-full"];
    rv.contentMode = UIViewContentModeScaleAspectFill;
    rv.maxRating = 5;
    rv.minRating = 1;
    rv.rating = 0;
    rv.editable = NO;
    rv.halfRatings = NO;
    rv.floatRatings = YES;
    [self.view addSubview:rv];
    
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
