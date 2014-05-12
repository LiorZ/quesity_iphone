//
//  QSCAppDelegate.m
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCAppDelegate.h"
#import "myGlobalData.h"
#define kDEFAULT_BACKGROUND_GRADIENT    @"gradient5"

@implementation QSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    //self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kDEFAULT_BACKGROUND_GRADIENT]];
    
    [self changeWindowColor:@"gradient5"];
    //[[UIApplication sharedApplication] keyWindow].tintColor = [UIColor orangeColor];

    // Override point for customization after application launch.
    return YES;
}

- (void) changeWindowColor:(NSString *)color {
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    [[UITabBar appearance] setTintColor:QUESITY_COLOR_FONT];
    //[[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:QUESITY_COLOR_BG];
    
    [[UINavigationBar appearance] setTintColor:QUESITY_COLOR_FONT];
    [[UINavigationBar appearance] setBarTintColor:QUESITY_COLOR_BG];
    
    //[[UITabBar appearance] setAlpha:1.f];
    //[[UITabBar appearance] setTranslucent:FALSE];
    //self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:color]];
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
