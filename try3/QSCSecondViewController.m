//
//  QSCSecondViewController.m
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCSecondViewController.h"
#import "QSCMyQuests.h"
#import "KeychainItemWrapper.h"

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


- (IBAction)didPOST:(id)sender {
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"tubis@nana.co.il", @"email",
                         @"rocket", @"password",
                         nil];
    
//    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"YourAppLogin" accessGroup:nil];
//
//    //setting user and password in keychain
//    [keychainItem setObject:@"rocket" forKey:(__bridge id)(kSecValueData)];
//    [keychainItem setObject:@"tubis@nana.co.il" forKey:(__bridge id)(kSecAttrAccount)];
    
    //retrieving from keyChain
//    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
//    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    //delete keyChainItem:
    //[keychainItem resetKeychainItem];

    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSError *error1;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error1];
    NSString *fullURL = @"http://quesity.herokuapp.com/login/local";
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postdata];

    NSHTTPURLResponse* response;
    NSError* error = nil;

    NSData* responseData = nil;
    responseData = [NSMutableData data];
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    int code = [response statusCode];
    NSDictionary *fields = [response allHeaderFields];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"the response code is:%d, with %d headers",code, fields.count);
    self.textToDisp.text = responseString;
    
    NSHTTPCookie *cookie1;
    NSHTTPCookieStorage *storage1 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSLog(@"num of cookies: %d", storage1.cookies.count);
//    NSString *cToSend = @"";
    for (cookie1 in [storage1 cookies]) {
//        NSLog(@"domain: %@",[cookie1 domain]);
//        NSLog(@"stuff: %@",cookie1.value);
//        //        if [cookie1 domain]==@"quesity.herokuapp.com"
//        cToSend = cookie1.value;
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
    }

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
