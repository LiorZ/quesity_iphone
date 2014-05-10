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

-(UIImage *) getImageFromURL:(NSString *)fileURL;
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName inDirectory:(NSString *)directoryPath;
-(UIImage *) loadImage:(NSString *)fileName inDirectory:(NSString *)directoryPath;

- (NSString *) getPathForSavedImage: (NSString *)imgName withQuestId:(NSString *)questId;
- (void) addPathForSavedImage: (NSString *)imgName withQuestId:(NSString *)questId;

- (NSString *) getFileFromPath: (NSString *)path;


@end
