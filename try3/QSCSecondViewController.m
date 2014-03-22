//
//  QSCSecondViewController.m
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCSecondViewController.h"
#import "QSCMyQuests.h"

@interface QSCSecondViewController ()

@end

@implementation QSCSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _countryNames = @[@"Australia (AUD)", @"China (CNY)",
                      @"France (EUR)", @"Great Britain (GBP)", @"Japan (JPY)"];
    
    NSString *fullURL = @"http://quesity.herokuapp.com/home";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_viewWeb loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _countryNames.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _countryNames[row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
//    [[[UIApplication sharedApplication] delegate] changeWindowColor:"@gradient2"];
//    QSCAppDelegate* aDelegate = (QSCAppDelegate *)[[UIApplication sharedApplication] delegate];

//    [QSCMyQuests  *v = self.;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient2"]];

    //    float rate = [_exchangeRates[row] floatValue];
//    float dollars = [_dollarText.text floatValue];
//    float result = dollars * rate;
    
//    NSString *resultString = [[NSString alloc] initWithFormat:
//                              @"%.2f USD = %.2f %@", dollars, result,
//                              _countryNames[row]];
//    _resultLabel.text = resultString;
}

//-(void)addPickerView{
//    pickerArray = [[NSArray alloc]initWithObjects:@"Chess",
//                   @"Cricket",@"Football",@"Tennis",@"Volleyball", nil];
//    myTextField = [[UITextField alloc]initWithFrame:
//                   CGRectMake(10, 100, 300, 30)];
//    myTextField.borderStyle = UITextBorderStyleRoundedRect;
//    myTextField.textAlignment = UITextAlignmentCenter;
//    myTextField.delegate = self;
//    [self.view addSubview:myTextField];
//    [myTextField setPlaceholder:@"Pick a Sport"];
//    myPickerView = [[UIPickerView alloc]init];
//    myPickerView.dataSource = self;
//    myPickerView.delegate = self;
//    myPickerView.showsSelectionIndicator = YES;
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
//                                   target:self action:@selector(done:)];
//    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
//                          CGRectMake(0, self.view.frame.size.height-
//                                     myDatePicker.frame.size.height-50, 320, 50)];
//    [toolBar setBarStyle:UIBarStyleBlackOpaque];
//    NSArray *toolbarItems = [NSArray arrayWithObjects:
//                             doneButton, nil];
//    [toolBar setItems:toolbarItems];
//    myTextField.inputView = myPickerView;
//    myTextField.inputAccessoryView = toolBar;
//    
//}


@end
