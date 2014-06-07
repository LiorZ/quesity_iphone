//
//  QSCLoginViewController.m
//  Quesity
//
//  Created by igor on 5/8/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCLoginViewController.h"
#import "BButton.h"
#import "myGlobalData.h"

@interface QSCLoginViewController ()

@end

@implementation QSCLoginViewController

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self didPressButtonLogin:nil];
    
    return YES;
}

- (void)viewDidLoad
{
    [self.loginEmail setDelegate:self];
    [self.loginPass setDelegate:self];
    self.loginPass.secureTextEntry = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    self.btnLogin.layer.cornerRadius = 5;
    self.btnLogin.clipsToBounds = YES;
    
    self.btnCancel.layer.cornerRadius = 5;
    self.btnCancel.clipsToBounds = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    NSString *fullURL = SITEURL_LOGIN;
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postdata];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse* response;
    NSError* error = nil;
    
    NSData* responseData = nil;
    //responseData = [NSMutableData data];
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    int code = [response statusCode];
    NSDictionary *fields = [response allHeaderFields];
    
    NSLog(@"the response code is:%d, with %d headers",code, fields.count);

    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",responseString);
    //self.textToDisp.text = responseString;
    
    if (code==200) {
        NSHTTPCookie *cookie1;
        NSHTTPCookieStorage *storage1 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie1 in [storage1 cookies]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
        }
        
        myGlobalData *myGD = [[myGlobalData alloc] init];
        [myGD updateLoggedInStatus:TRUE];
        
        [self performSegueWithIdentifier:@"segueAfterLogin" sender:self];
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

- (IBAction)didPressButtonCancelLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
