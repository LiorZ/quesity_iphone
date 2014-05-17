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
@property (nonatomic, copy) NSNumber *gamesPlayed;
@property (nonatomic, copy) NSString *durationT;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *questId;
@property (nonatomic, copy) NSNumber *allowedHints;
@property (nonatomic, copy) NSArray *tags;
//typedef struct {
//    int *lng;
//    int day;
//    int year;
//} Location;

@property (nonatomic, retain) QSCLocation *startLoc;

@property (nonatomic, copy) UIImage *img;

@property (nonatomic,copy) NSArray *imagesLinks;

@property float rating;


@end
