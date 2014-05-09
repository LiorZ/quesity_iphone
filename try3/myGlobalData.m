//
//  myGlobalData.m
//  Quesity
//
//  Created by igor on 5/9/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "myGlobalData.h"

@implementation myGlobalData
@synthesize isLoggedIn = _isLoggedIn;

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

- (void) updateLoggedInStatus: (BOOL)stat {
    _isLoggedIn = stat;
    //saving stuff:
    [[NSUserDefaults standardUserDefaults] setBool:stat forKey:@"isLoggedIn"];
}

@end
