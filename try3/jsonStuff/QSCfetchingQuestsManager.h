//
//  QSCfetchingQuestsManager.h
//  try3
//
//  Created by igor on 2/28/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSCQuestsCommunicatorDelegate.h"
#import "QSCfetchingQuestsManagerDelegate.h"
#import "QSCQuestCommunicator.h"
@class QSCfetchingQuestsCommunicator;

@interface QSCfetchingQuestsManager : NSObject<QSCQuestsCommunicatorDelegate>
@property (strong, nonatomic) QSCQuestCommunicator *communicator;
@property (weak, nonatomic) id<QSCfetchingQuestsManagerDelegate> delegate;

- (void)fetchQuestsAtCoordinate;

@end
