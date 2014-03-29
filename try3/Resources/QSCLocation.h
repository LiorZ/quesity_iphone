//
//  QSCLocation.h
//  try3
//
//  Created by igor on 3/29/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSCLocation : NSObject {
    NSNumber* lng;
    NSNumber* lat;
    NSNumber* rad;
    NSString* street;
}

@property (retain) NSNumber* lng;
@property (retain) NSNumber* lat;
@property (retain) NSNumber* rad;
@property (retain) NSString* street;

@end