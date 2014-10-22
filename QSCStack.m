//
//  QSCStack.m
//  Quesity
//
//  Created by igor on 9/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCStack.h"

@implementation QSCStack
@synthesize count;

- (id)init
{
    if( self=[super init] )
    {
        m_array = [[NSMutableArray alloc] init];
        count = 0;
    }
    return self;
}

- (void)push:(id)anObject
{
    [m_array addObject:anObject];
    count++;
}

- (id)pop
{
    id obj = nil;
    if(m_array.count > 0)
    {
        obj = [m_array lastObject];
        [m_array removeLastObject];
        count--;
    }
    return obj;
}

- (void)clear
{
    [m_array removeAllObjects];
    count = 0;
}

@end
