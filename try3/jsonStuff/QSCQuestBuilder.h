//
//  QSCQuestBuilder.h
//  try3
//
//  Created by igor on 2/28/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSCQuestBuilder : NSObject

+ (NSArray *)questsFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
