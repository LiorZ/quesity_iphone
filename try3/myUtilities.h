//
//  myUtilities.h
//  try3
//
//  Created by igor on 4/4/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myUtilities :NSObject
- (NSString *) parseString2Hebrew:(NSString *)str2parse;
@end

@implementation myUtilities

- (NSString *) parseString2Hebrew:(NSString *)str2parse
{
    // will cause trouble if you have "abc\\\\uvw"
    NSString* esc1 = [str2parse stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString* esc2 = [esc1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString* quoted = [[@"\"" stringByAppendingString:esc2] stringByAppendingString:@"\""];
    NSData* data = [quoted dataUsingEncoding:NSUTF8StringEncoding];
    NSString* unesc = [NSPropertyListSerialization propertyListFromData:data
                                                       mutabilityOption:NSPropertyListImmutable format:NULL
                                                       errorDescription:NULL];
    assert([unesc isKindOfClass:[NSString class]]);
    return unesc;
}

@end