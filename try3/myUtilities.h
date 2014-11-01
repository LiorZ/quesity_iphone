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

- (void) sendScreenToGA: (NSString *)screenName;
- (void) sendEventToGA: (NSString *)category withAction: (NSString *)action withLabel:(NSString *)label;
- (void) sendPageChangeToGA: (NSString *)label withPagesViewed: (NSNumber *)pagesViewed withPageName: (NSString *)pageName;

-(UIImage *) getImageFromURL:(NSString *)fileURL;
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName inDirectory:(NSString *)directoryPath;
-(UIImage *) loadImage:(NSString *)fileName inDirectory:(NSString *)directoryPath;

- (NSString *) getPathForSavedImage: (NSString *)imgName withQuestId:(NSString *)questId;
- (void) addPathForSavedImage: (NSString *)imgName withQuestId:(NSString *)questId;

- (NSString *) getFileFromPath: (NSString *)path;

- (UIView *) drawLine: (CGRect)rect;
- (void) drawLine1: (CGRect)rect toView: (UIView *)v;

- (BOOL)isRTL: (NSString *)str;


@end
