//
//  QSCregisterVC.m
//  Quesity
//
//  Created by igor on 6/7/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCregisterVC.h"
#import "BButton.h"
#import "myGlobalData.h"

@interface QSCregisterVC ()

@end

@implementation QSCregisterVC

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self didPressButtonRegister:nil];
    
    return YES;
}

///Returns YES (true) if EMail is valid
-(BOOL) isValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

- (void)viewDidLoad
{

    self.btnRegister.layer.cornerRadius = 5;
    self.btnRegister.clipsToBounds = YES;
    
    self.btnCancel.layer.cornerRadius = 5;
    self.btnCancel.clipsToBounds = YES;
    
    [self.txtEmail setDelegate:self];
    [self.txtFirstName setDelegate:self];
    [self.txtLastName setDelegate:self];
    [self.txtPassword setDelegate:self];
    self.txtPassword.secureTextEntry = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)didPressButtonRegister:(id)sender {
    
    [self.view endEditing:YES];
    
    NSLog(@"Pressed Register.");
    
    if ([self isValidEmail:self.txtEmail.text Strict:NO]) {
        
        NSDictionary *nameDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  self.txtFirstName.text, @"first",
                                  self.txtLastName.text, @"last",
                                  nil];
        
        NSDictionary *dict2send = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   nameDict, @"name",
                                   self.txtEmail.text, @"email",
                                   self.txtPassword.text, @"password",
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
        NSData *postdata = [NSJSONSerialization dataWithJSONObject:dict2send options:0 error:&error1];
        NSString *fullURL = SITEURL_REGISTER;
        
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
        
//        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",responseString);
        //self.textToDisp.text = responseString;
        
        if (code==200) {
            NSHTTPCookie *cookie1;
            NSHTTPCookieStorage *storage1 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie1 in [storage1 cookies]) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
            }
            
            myGlobalData *myGD = [[myGlobalData alloc] init];
            [myGD updateLoggedInStatus:YES];

            [self performSegueWithIdentifier:@"segueAfterRegister" sender:self];
            
            //[self dismissViewControllerAnimated:YES completion:nil];
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry..."
                                                            message:@"Something is wrong. Unable to connect."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry..."
                                                        message:@"Please enter a valid email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

- (IBAction)didPressButtonCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
