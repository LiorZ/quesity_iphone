//
//  QSCfetchingQuestsManagerDelegate.h
//  try3
//
//  Created by igor on 2/28/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QSCfetchingQuestsManagerDelegate <NSObject>
- (void)didReceiveQuests:(NSArray *)quests;
- (void)fetchingQuestsFailedWithError:(NSError *)error;
@end
