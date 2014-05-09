//
//  myGlobalData.h
//  Quesity
//
//  Created by igor on 5/9/14.
//  Copyright (c) 2014 igor. All rights reserved.
//
#define SITEURL @"http://quesity.herokuapp.com/"
#define SITEURL_LOGIN      [SITEURL stringByAppendingString:@"app/login/local/"]
#define SITEURL_QUEST      [SITEURL stringByAppendingString:@"quest/"]
#define SITEURL_ALL_QUESTS [SITEURL stringByAppendingString:@"all_quests"]
#define QUESITY_COLOR  [UIColor colorWithRed:73/255.0f green:138/255.0f blue:128/255.0f alpha:1.0f]

#import <Foundation/Foundation.h>

@interface myGlobalData : NSObject {
    BOOL isLoggedIn;
}

@property BOOL isLoggedIn;
+(myGlobalData*)getInstance;
- (void) updateLoggedInStatus: (BOOL)stat;

@end
