//
//  QSCLoginViewController.m
//  Quesity
//
//  Created by igor on 5/8/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCLoginViewController.h"

@interface QSCLoginViewController ()

@end

@implementation QSCLoginViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self.loginEmail setDelegate:self];
    [self.loginPass setDelegate:self];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)didPressButtonLogin:(id)sender {

    [self.view endEditing:YES];

    NSLog(@"Pressed Login.");
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.loginEmail.text, @"email",
                         self.loginPass.text, @"password",
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
    
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"the response code is:%d, with %d headers",code, fields.count);
    //self.textToDisp.text = responseString;
    
    if (code==200) {
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
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry..."
                                                        message:@"Are you sure you have the right password?"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (IBAction)didPressButtonRegister:(id)sender {
    NSLog(@"Pressed Register.");
}

- (IBAction)didPressButtonForgot:(id)sender {
    NSLog(@"Pressed Forgot.");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
