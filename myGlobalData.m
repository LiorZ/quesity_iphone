//
//  myGlobalData.m
//  Quesity
//
//  Created by igor on 5/9/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "myGlobalData.h"

@implementation myGlobalData
//@synthesize isLoggedIn = _isLoggedIn;
//@synthesize isAskToLoginRegister = _isAskToLoginRegister;

static myGlobalData *instance = nil;

+(myGlobalData *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [myGlobalData new];
        }
    }

    return instance;
}

//- (void) updateLoggedInStatus: (BOOL)stat {
//    _isLoggedIn = stat;
//    //saving stuff:
//    [[NSUserDefaults standardUserDefaults] setBool:stat forKey:@"isLoggedIn"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
////    NSLog(@"isLoggedIn: %hhd",[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"]);
//
//}
//
//- (BOOL) isLoggedInStatus{
//    _isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"];
////    NSLog(@"isLoggedIn: %hhd",[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"]);
//    return _isLoggedIn;
//}
//
//- (void) updateAskToLoginRegisterStatus: (BOOL)stat {
//    _isAskToLoginRegister = stat;
//    //saving stuff:
//    [[NSUserDefaults standardUserDefaults] setBool:stat forKey:@"isAskToLoginRegister"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (BOOL) isAskToLoginRegisterStatus {
//    _isAskToLoginRegister = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAskToLoginRegister"];
//
//    //check whether it exists
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isAskToLoginRegister"]!=nil)
//        return _isAskToLoginRegister;
//    else
//        return TRUE;
//}

- (BOOL) isDbg {
    return isDbgMode;
}

@end
