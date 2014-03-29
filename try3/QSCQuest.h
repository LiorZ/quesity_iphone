//
//  Quest.h
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Resources/QSCLocation.h"

@interface QSCQuest : NSObject

@property NSString *name;
@property (nonatomic, copy) NSNumber *durationD;
@property (nonatomic, copy) NSString *durationT;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *questId;

//typedef struct {
//    int *lng;
//    int day;
//    int year;
//} Location;

@property (nonatomic, retain) QSCLocation *startLoc;

@property int rating;


@end
