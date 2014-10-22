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
#import "QSCPlayer.h"
#import "QSCAllQuestsViewController2.h"

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
    self.rv  =[[TPFloatRatingView alloc] initWithFrame:CGRectMake(100.f, pushUp + 465.0, 120.f, 30.f)];
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

- (void) sendReview: (QSCPlayer *)player {
    NSString *siteStr = [NSString stringWithFormat:@"quest/%@/review",_quest.questId];
    NSString *siteUrl = [SITEURL stringByAppendingString:siteStr];
    NSURL *url = [NSURL URLWithString:siteUrl];
    
    //account_id: <ACCOUNT_ID>, review_text: <TEXT REVIEW>, rating: <# STARS>, game_id: <ID OF GAME>
    NSString *playerName = [player getName];
    
    NSDictionary *reviewDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               self.opinion, @"review_text",
                               playerName, @"account_id",
                               [NSNumber numberWithFloat:self.rv.rating], @"rating",
                               _quest.gameStartId, @"game_id", nil];
    
// also works:
//    NSDictionary *reviewDic = @{@"account_id" : playerName,
//                                 @"review_text" : self.opinion,
//                                 @"rating" : [NSNumber numberWithFloat:self.rv.rating],
//                                 @"game_id" : _quest.gameStartId};
    
    
//    NSLog(@"%@",reviewDic);
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSHTTPCookie *cookie1;
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSString *playerCookieValue = player.getCookieValue;
    for (cookie1 in [cookieStorage cookies]) {
        NSString *trimmedPlayerValue = [playerCookieValue substringWithRange:NSMakeRange(12, [cookie1.value length])];
        
        if ([cookie1.value isEqualToString:trimmedPlayerValue])
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
    }
    
    NSError *error1;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:reviewDic options:0 error:&error1];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postdata];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse* response;
    NSError* error = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    int code = (int)[response statusCode];
    NSLog(@"the response code for the sent review is: %d",code);
}


- (IBAction)returnToFinishPage:(UIStoryboardSegue *)segue {
    QSCratingViewController* sourceViewController = segue.sourceViewController;

    self.rv.rating = sourceViewController.rv.rating;
    self.opinion = sourceViewController.opinion.text;
    
    //buying quest stuff:
    QSCPlayer *player = [[QSCPlayer alloc] initWithLoad];
    [self sendReview: player];
    
    //    NSLog(@"And now we are again on finish page.");
}

#pragma mark - TPFloatRatingViewDelegate
- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating
{
    [self performSegueWithIdentifier:@"showRatingView" sender:self];

//    NSLog(@"open rating view.");
    
}

- (void)floatRatingView:(TPFloatRatingView *)ratingView continuousRating:(CGFloat)rating
{
//    NSLog(@"%@",[NSString stringWithFormat:@"%.2f", rating]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showRatingView"]) {
        QSCratingViewController *destViewController = [[segue.destinationViewController viewControllers] firstObject];
        destViewController.startWithOpinion = self.opinion;
        destViewController.startWithRating = [NSNumber numberWithFloat:self.rv.rating];
    
    }
//    else if ([segue.identifier isEqualToString:@"fromFinishToAllQuests"]) {
//        QSCAllQuestsViewController2 *destViewController = [segue destinationViewController];
//    {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
