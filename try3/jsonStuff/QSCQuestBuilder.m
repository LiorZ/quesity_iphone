//
//  QSCQuestBuilder.m
//  try3
//
//  Created by igor on 2/28/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCQuestBuilder.h"
#import "QSCQuest.h"

@implementation QSCQuestBuilder
+ (NSArray *)questsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *quests = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"results"];
    NSLog(@"Count %d", results.count);
    
    for (NSDictionary *questDic in results) {
        QSCQuest *quest = [[QSCQuest alloc] init];
        
        for (NSString *key in questDic) {
            if ([quest respondsToSelector:NSSelectorFromString(key)]) {
                [quest setValue:[questDic valueForKey:key] forKey:key];
            }
        }
        
        [quests addObject:quest];
    }
    
    return quests;
}
@end
