//
//  QSCQuestsCommunicatorDelegate.h
//  try3
//
//  Created by igor on 2/25/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QSCQuestsCommunicatorDelegate <NSObject>
- (void)receivedAllQuestsJSON:(NSData *)objectNotation;
- (void)fetchingAllQuestsFailedWithError:(NSError *)error;
@end
