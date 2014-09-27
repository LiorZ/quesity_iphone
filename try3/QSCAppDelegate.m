//
//  QSCAppDelegate.m
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCAppDelegate.h"
#import "myGlobalData.h"

@implementation QSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myData"];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedImagesDict"];

    self.window.backgroundColor = QUESITY_COLOR_BG_IMG;
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"mainAllQuests"];//@"mainAfterLogin"];
    self.window.rootViewController = viewController;

    //    //decide which main VC to show:
//    myGlobalData *myGD = [[myGlobalData alloc] init];
//    if (![myGD isAskToLoginRegisterStatus]) {
//        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"mainAfterLogin"];
//        self.window.rootViewController = viewController;
//    } else {
//        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"mainBeforeLogin"];
//        self.window.rootViewController = viewController;
//    }

    [self changeWindowColor:@"the usual"];
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

- (void) changeWindowColor:(NSString *)color {
    self.window.backgroundColor = QUESITY_COLOR_BG_IMG;

    [[UITabBar appearance] setTintColor:QUESITY_COLOR_FONT];
    [[UITabBar appearance] setBarTintColor:QUESITY_COLOR_BG];
    
    [[UINavigationBar appearance] setTintColor:QUESITY_COLOR_FONT];
    [[UINavigationBar appearance] setBarTintColor:QUESITY_COLOR_BG];
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
