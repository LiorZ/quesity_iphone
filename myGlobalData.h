//
//  myGlobalData.h
//  Quesity
//
//  Created by igor on 5/9/14.
//  Copyright (c) 2014 igor. All rights reserved.
//
#define SITEURL @"http://quesity.herokuapp.com/"
//#define SITEURL @"http://192.168.209.129:8080/"

//#define SITEURL_LOGIN      [SITEURL stringByAppendingString:@"app/login/local/"]
#define SITEURL_VALIDATE_CODE   [SITEURL stringByAppendingString:@"app/validate_code"]
#define SITEURL_REGISTER        [SITEURL stringByAppendingString:@"register/action"]
#define SITEURL_QUEST           [SITEURL stringByAppendingString:@"quest/"]
#define SITEURL_ALL_QUESTS      [SITEURL stringByAppendingString:@"all_quests"] 

#define QUESITY_COLOR  [UIColor colorWithRed:73/255.0f green:138/255.0f blue:128/255.0f alpha:1.0f]
#define QUESITY_COLOR_PC  [UIColor colorWithRed:73/255.0f green:138/255.0f blue:128/255.0f alpha:0.2f] //pagecontroller

#define QUESITY_COLOR_FONT [UIColor colorWithRed:16/255.0f green:62/255.0f blue:65/255.0f alpha:1.0f]
#define QUESITY_COLOR_BG   [UIColor colorWithRed:97/255.0f green:162/255.0f blue:190/255.0f alpha:1.0f]
#define QUESITY_COLOR_TABLE_EVEN [UIColor colorWithRed:169/255.0f green:199/255.0f blue:203/255.0f alpha:.4f]
#define QUESITY_COLOR_TABLE_ODD  [UIColor colorWithRed:201/255.0f green:217/255.0f blue:220/255.0f alpha:.4f]
#define QUESITY_COLOR_TABLE_EVEN_NOALPHA [UIColor colorWithRed:122/255.0f green:170/255.0f blue:198/255.0f alpha:1.f]
#define QUESITY_COLOR_TABLE_ODD_NOALPHA  [UIColor colorWithRed:131/255.0f green:179/255.0f blue:191/255.0f alpha:1.f]
#define QUESITY_COLOR_NONACTIVE [UIColor colorWithRed:169/255.0f green:199/255.0f blue:203/255.0f alpha:1.f]
#define QUESITY_COLOR_BG_IMG [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]
#define QUESITY_COLOR_TAGS [UIColor colorWithRed:225/255.0f green:88/255.0f blue:34/255.0f alpha:1.0f]

#define TIMEOUT_FOR_CONNECTION 28

//#define isDbgMode YES
#define isDbgMode NO

#define isPreCacheQuest YES

//macro for localization
#define NSLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CODE_REQ) {
    CODE_REQ_free,
    CODE_REQ_code,
    CODE_REQ_inApp
};

@interface myGlobalData : NSObject {
//    BOOL isLoggedIn;
//    BOOL isAskToLoginRegister;
}

//@property BOOL isLoggedIn;
//@property BOOL isAskToLoginRegister;

+(myGlobalData*)getInstance;
//- (void) updateLoggedInStatus: (BOOL)stat;
//- (BOOL) isLoggedInStatus;
//- (void) updateAskToLoginRegisterStatus: (BOOL)stat;
//- (BOOL) isAskToLoginRegisterStatus;
- (BOOL) isDbg;

@end
