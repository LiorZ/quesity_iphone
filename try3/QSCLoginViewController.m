//
//  QSCLoginViewController.m
//  Quesity
//
//  Created by igor on 5/8/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCLoginViewController.h"
#import "myGlobalData.h"

@interface QSCLoginViewController ()

@end

@implementation QSCLoginViewController

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self didPressButtonLogin:nil];
    
    return YES;
}

-(void)keyboardWillShow {

}

-(void)keyboardWillHide {
    if (self.scv.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.scv.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if  (self.scv.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height==480) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3]; // if you want to slide up the view
        
        //    CGRect screenBounds = [[UIScreen mainScreen] bounds];
        //    float deltaToShiftKeyboard = 120 - (480 - screenBounds.size.height);
        
        if (movedUp)
        {
            //Keyboard becomes visible
            self.scv.frame = CGRectOffset(self.scv.frame, 0, -80);
        }
        else
        {
            // revert back to the normal state.
            self.scv.frame = CGRectOffset(self.scv.frame, 0, 80);
            
        }
        
        [UIView commitAnimations];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height==480) {
        [super viewWillAppear:animated];
        // register for keyboard notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height==480) {
        [super viewWillDisappear:animated];
        // unregister for keyboard notifications while not visible.
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
    }
}


-(void)hideKeyboard
{
    [self.view endEditing:YES];
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
    
    //for hiding the keyboard when pressing on the scrollview
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;
    
    [self.scv addGestureRecognizer:tapGesture];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)didPressButtonLogin:(id)sender {

    [self.view endEditing:YES];

//    NSLog(@"Pressed Login.");
    
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
    
    //NSData* responseData = nil;
    //responseData = [NSMutableData data];
    //responseData =
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    int code = (int)[response statusCode];
//    NSDictionary *fields = [response allHeaderFields];
    
//    NSLog(@"the response code is:%d, with %d headers",code, fields.count);

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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry...", nil)
                                                        message:NSLocalizedString(@"Wrong email or password", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
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
