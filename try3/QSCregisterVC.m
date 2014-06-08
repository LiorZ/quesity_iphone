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

#define kOFFSET_FOR_KEYBOARD 80.0

@interface QSCregisterVC ()

@end

@implementation QSCregisterVC

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.txtPassword) {
        [theTextField resignFirstResponder];
        [self didPressButtonRegister:nil];

    } else if (theTextField == self.txtEmail) {
        [self.txtFirstName becomeFirstResponder];

    } else if (theTextField == self.txtFirstName) {
        [self.txtLastName becomeFirstResponder];

    } else if (theTextField == self.txtLastName) {
        [self.txtPassword becomeFirstResponder];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
//    if (self.scv.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//    }
//    else if (self.scv.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//    }
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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float deltaToShiftKeyboard = 120 + (480 - screenBounds.size.height);
    
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        //Keyboard becomes visible
        self.scv.frame = CGRectOffset(self.scv.frame, 0, -deltaToShiftKeyboard);
//        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
//        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        self.scv.frame = CGRectOffset(self.scv.frame, 0, deltaToShiftKeyboard);

//        rect.origin.y = 0.f;
//        CGRect screenBounds = [[UIScreen mainScreen] bounds];
//        rect.size.height = screenBounds.size.height;
    }
    //self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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

-(void)hideKeyboard
{
    [self.view endEditing:YES];
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
    
    //for hiding the keyboard when pressing on the scrollview
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;
    
    [self.scv addGestureRecognizer:tapGesture];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry...", nil)
                                                            message:NSLocalizedString(@"Something is wrong. Unable to connect.",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry...", nil)
                                                        message:NSLocalizedString(@"Please enter a valid email", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

- (IBAction)didPressButtonCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
