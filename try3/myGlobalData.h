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

#define QUESITY_COLOR_FONT [UIColor colorWithRed:16/255.0f green:62/255.0f blue:65/255.0f alpha:1.0f]
#define QUESITY_COLOR_BG   [UIColor colorWithRed:97/255.0f green:162/255.0f blue:190/255.0f alpha:1.0f]
#define QUESITY_COLOR_TABLE_EVEN [UIColor colorWithRed:169/255.0f green:199/255.0f blue:203/255.0f alpha:.4f];
#define QUESITY_COLOR_TABLE_ODD  [UIColor colorWithRed:201/255.0f green:217/255.0f blue:220/255.0f alpha:.4f];
#define QUESITY_COLOR_NONACTIVE [UIColor colorWithRed:169/255.0f green:199/255.0f blue:203/255.0f alpha:1.f];

#import <Foundation/Foundation.h>

@interface myGlobalData : NSObject {
    BOOL isLoggedIn;
}

@property BOOL isLoggedIn;
+(myGlobalData*)getInstance;
- (void) updateLoggedInStatus: (BOOL)stat;

@end
