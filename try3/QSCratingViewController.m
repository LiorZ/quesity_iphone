//
//  QSCratingViewController.m
//  Quesity
//
//  Created by igor on 5/18/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCratingViewController.h"

@interface QSCratingViewController ()

@end

@implementation QSCratingViewController

- (void)viewDidLoad
{

    self.opinion.delegate = self;
    
    //self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    //rating stuff:
    self.rv.emptySelectedImage = [UIImage imageNamed:@"star-empty"];
    self.rv.fullSelectedImage = [UIImage imageNamed:@"star-full"];
    self.rv.contentMode = UIViewContentModeScaleAspectFill;
    self.rv.maxRating = 5;
    self.rv.minRating = 1;
    self.rv.rating = [self.startWithRating floatValue];
    self.rv.editable = YES;
    self.rv.halfRatings = YES;
    self.rv.floatRatings = NO;
    self.rv.backgroundColor = [UIColor clearColor];

    if ([self.startWithOpinion length] > 0) {
        self.opinion.text = self.startWithOpinion;
        self.defaultLabel.hidden = YES;
    }
   
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

-(void)dismissKeyboard {
    [self.opinion resignFirstResponder];
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
}

#pragma mark - TPratingViewDelegate


- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating
{

}

- (void)floatRatingView:(TPFloatRatingView *)ratingView continuousRating:(CGFloat)rating
{

}

#pragma mark - textViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.defaultLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)txtView
{
    self.defaultLabel.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.defaultLabel.hidden = ([txtView.text length] > 0);
}


//- (IBAction)back:(id)sender {
//    [self performSegueWithIdentifier:@"returnToFinishScreen" sender:self];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
