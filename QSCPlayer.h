//
//  QSCPlayer.h
//  Quesity
//
//  Created by igor on 10/9/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSCPlayer : NSObject {
    NSString *playerName;
    NSString *cookieValue;

}

- (id) initWithLoad;
- (void) addQuestToBoughtQuests:(NSString *)questId;
- (BOOL) isBoughtQuests:(NSString *)questId;
- (NSString *) getName;
- (NSString *) getCookieValue;


@property (nonatomic, retain) NSMutableArray *questsBought; //list of bought quests


@end
