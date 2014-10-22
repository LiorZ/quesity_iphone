//
//  QSCPlayer.m
//  Quesity
//
//  Created by igor on 10/9/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCPlayer.h"
#import "myGlobalData.h"

@implementation QSCPlayer


- (BOOL) isExistPlayer {
    //player exists if there's the playerData entry saved

    NSDictionary* playerDict = [[NSUserDefaults standardUserDefaults] objectForKey: @"playerData"];
    return (playerDict!=nil);
}


- (NSString *) generateName {

    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    int len = 22;
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: (int)arc4random_uniform((int)[letters length]) % (int)[letters length]]];
    }
    
    return [randomString stringByAppendingString:@"_iphone@email.com"];
}


- (void) registerUser {
    //{ email: <EMAIL>, name: { first: "IPHONE", last: "USER"}, password:1}
    NSDictionary *name = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"IPHONE", @"first",
                          @"USER", @"last",
                          nil];
    
    NSDictionary *user2reg = [[NSDictionary alloc] initWithObjectsAndKeys:
                              playerName, @"email",
                              name, @"name",
                              @"1", @"password",
                              nil];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSError *error1;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:user2reg options:0 error:&error1];
    NSString *fullURL = SITEURL_REGISTER;
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postdata];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse* response;
    NSError* error = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    int code = (int)[response statusCode];

    NSDictionary *fields = [response allHeaderFields];
    NSLog(@"the response code is:%d, with %lu headers",code, (unsigned long)fields.count);
    
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",responseString);
    //self.textToDisp.text = responseString;
    
//    }

    if (code==200) {
        cookieValue = [fields objectForKey:@"Set-Cookie"];
        [self updatePlayer];

        NSHTTPCookie *cookie1;
        NSHTTPCookieStorage *storage1 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie1 in [storage1 cookies]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
        }
    }

}

- (void) loadPlayer {
    if (![self isExistPlayer]) {
        
        //playerName:
        playerName = [self generateName];
        NSLog(@"generated player: %@",playerName);

        //empty NSArray (didn't buy nothing yet. going to be a list of questIds (for bought quests)
        self.questsBought = [[NSMutableArray alloc] init];
        cookieValue = @"";
        
        NSDictionary *playerDict = @{@"playerName" : playerName,
                                     @"questsBought" : self.questsBought,
                                     @"cookieValue" : cookieValue};

        //save it:
        [[NSUserDefaults standardUserDefaults] setObject:playerDict forKey:@"playerData"];
        
        
        //register user:
        [self registerUser];
    } else {
        
        NSDictionary *playerDict =[[NSUserDefaults standardUserDefaults] objectForKey:@"playerData"];
        
        playerName = [playerDict objectForKey:@"playerName"];
        self.questsBought = [NSMutableArray arrayWithArray:[playerDict objectForKey:@"questsBought"]];
        cookieValue = [playerDict objectForKey:@"cookieValue"];
    }
}

- (void) updatePlayer {
    NSDictionary *playerDict = @{@"playerName" : playerName,
                                 @"questsBought" : self.questsBought,
                                 @"cookieValue" : cookieValue};
    [[NSUserDefaults standardUserDefaults] setObject:playerDict forKey:@"playerData"];
}

/* public methods */
- (id) initWithLoad {
    self = [super init];

    [self loadPlayer];
    return self;
}

- (NSString *) getName {
    return playerName;
}

- (NSString *) getCookieValue {
    return cookieValue;
}

- (void) addQuestToBoughtQuests:(NSString *)questId {
    if ([_questsBought indexOfObject:questId] == NSNotFound) {
//        if ([_questsBought count]==0)
//            _questsBought = [[NSMutableArray alloc] init];
        
        [_questsBought addObject:questId];
        NSLog(@"bought quest: %@",questId);
        
        [self updatePlayer];
    }
}

- (BOOL) isBoughtQuests:(NSString *)questId {
    return ([_questsBought indexOfObject:questId] != NSNotFound);
}

@end
