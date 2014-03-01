//
//  QSCfetchingQuestsManager.m
//  try3
//
//  Created by igor on 2/28/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCfetchingQuestsManager.h"
#import "QSCQuestBuilder.h"
#import "QSCQuestCommunicator.h"

@implementation QSCfetchingQuestsManager
- (void)fetchQuestsAtCoordinate
{
    [self.communicator searchQuestsAtCoordinate];
}

#pragma mark - MeetupCommunicatorDelegate

- (void)receivedAllQuestsJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    NSArray *Quests = [QSCQuestBuilder groupsFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchingQuestsFailedWithError:error];
        
    } else {
        [self.delegate didReceiveQuests:groups];
    }
}

- (void)fetchingAllQuestsFailedWithError:(NSError *)error
{
    [self.delegate fetchingQuestsFailedWithError:error];
}

@end
