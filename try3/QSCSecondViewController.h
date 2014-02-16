//
//  QSCSecondViewController.h
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSCSecondViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *countryNames;
//@property NSString *chosen;

//- (void)reloadAllComponents;
//- (void)reloadComponent:(NSInteger)component;
//- (NSInteger)selectedRowInComponent:(NSInteger)component;
//- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

@end
