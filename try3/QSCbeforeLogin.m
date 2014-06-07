//
//  QSCbeforeLogin.m
//  Quesity
//
//  Created by igor on 6/7/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCbeforeLogin.h"
#import <QuartzCore/QuartzCore.h>


@interface QSCbeforeLogin ()

@end

@implementation QSCbeforeLogin

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
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"UI-4-1.png"]];
    //self.window.backgroundColor = QUESITY_COLOR_BG_IMG; [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]

    
    self.btnRegister.layer.cornerRadius = 5;
    self.btnRegister.clipsToBounds = YES;

    self.btnLogin.layer.cornerRadius = 5;
    self.btnLogin.clipsToBounds = YES;
    
    [super viewDidLoad];
    
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    
//    //iphone 4 frame:
//    UIButton *btnFind  = [[UIButton alloc] initWithFrame:CGRectMake(38.f, 220.f, 244.f, 52.f)];
//    UIButton *btnMy    = [[UIButton alloc] initWithFrame:CGRectMake(38.f, 299.5f, 244.f, 52.f)];
//    UIButton *btnAbout = [[UIButton alloc] initWithFrame:CGRectMake(38.f, 379.f, 244.f, 52.f)];
//    
//    if (screenBounds.size.height==568) {
//        btnFind.frame  = CGRectMake(38.f, 260.f, 244.f, 62.f);
//        btnMy.frame    = CGRectMake(38.f, 356.f, 244.f, 62.f);
//        btnAbout.frame = CGRectMake(38.f, 449.f, 244.f, 62.f);
//    }
//    
//    UITapGestureRecognizer *singleFingerTapFind = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                          action:@selector(didPressButtonFind:)];
//    UITapGestureRecognizer *singleFingerTapMy = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                        action:@selector(didPressButtonMy:)];
//    UITapGestureRecognizer *singleFingerTapAbout = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                           action:@selector(didPressButtonAbout:)];
//    
//    [btnFind  addGestureRecognizer:singleFingerTapFind];
//    [btnMy    addGestureRecognizer:singleFingerTapMy];
//    [btnAbout addGestureRecognizer:singleFingerTapAbout];
//    
//    [btnFind  setImage:[UIImage imageNamed:NSLocalizedString(@"btnFind",nil)]  forState:UIControlStateNormal];
//    [btnMy    setImage:[UIImage imageNamed:NSLocalizedString(@"btnMy",nil)]    forState:UIControlStateNormal];
//    [btnAbout setImage:[UIImage imageNamed:NSLocalizedString(@"btnAbout",nil)] forState:UIControlStateNormal];
//    
//    [btnFind  setImage:[UIImage imageNamed:NSLocalizedString(@"btnFindPressed",nil)]  forState:UIControlStateHighlighted];
//    [btnMy    setImage:[UIImage imageNamed:NSLocalizedString(@"btnMyPressed",nil)]    forState:UIControlStateHighlighted];
//    [btnAbout setImage:[UIImage imageNamed:NSLocalizedString(@"btnAboutPressed",nil)] forState:UIControlStateHighlighted];
//    
//    [self.view addSubview:btnFind];
//    [self.view addSubview:btnMy];
//    [self.view addSubview:btnAbout];
    
}

- (IBAction)didPressButtonFind:(id)sender {
    [self performSegueWithIdentifier:@"goFindQuest1" sender:self];
}
- (IBAction)didPressButtonMy:(id)sender {
    [self performSegueWithIdentifier:@"goMyQuests1" sender:self];
}
- (IBAction)didPressButtonAbout:(id)sender {
    [self performSegueWithIdentifier:@"goAbout1" sender:self];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goFindQuests"]) {
        NSLog(@"go to find quests");
    } else if ([segue.identifier isEqualToString:@"goMyQuests"]) {
        NSLog(@"show my quests");
    }
}
@end
