//
//  QSCStack.h
//  Quesity
//
//  Created by igor on 9/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSCStack : NSObject
{
    NSMutableArray* m_array;
    int count;
}

- (void)push:(id)anObject;
- (id)pop;
- (void)clear;

@property (nonatomic, readonly) int count;

@end
