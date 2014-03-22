//
//  Quest.h
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSCQuest : NSObject

@property NSString *name;
@property (nonatomic, copy) NSNumber *durationD;
@property (nonatomic, copy) NSString *durationT;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *questId;
//@property int durationT;
@property int rating;
//@property NSString *title;
//@property NSNumber *durationTime;
//@property NSNumber *durationDistance;


@end
