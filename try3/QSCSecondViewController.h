//
//  QSCSecondViewController.h
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Security;

@interface QSCSecondViewController : UIViewController

@property (strong, nonatomic) NSArray *countryNames;
//@property NSString *chosen;
@property (weak, nonatomic) IBOutlet UIWebView *viewWeb;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UITextView *textToDisp;


//- (void)reloadAllComponents;
//- (void)reloadComponent:(NSInteger)component;
//- (NSInteger)selectedRowInComponent:(NSInteger)component;
//- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

@end
