//
//  myUtilities.m
//  Quesity
//
//  Created by igor on 5/9/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "myUtilities.h"
#import "myGlobalData.h"

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


/* Images Stuff */

/* Get image from url */
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

/* Save Image */
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName inDirectory:(NSString *)directoryPath {
    //NSString *fn = [self getFileWOExtension:imageName];
    NSString *extension = [imageName pathExtension];
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

/* Load Image */
-(UIImage *) loadImage:(NSString *)fileName inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", directoryPath, fileName]];
    
    return result;
}

- (NSString *) getPathForSavedImage: (NSString *)imgName withQuestId:(NSString *)questId {
    //for each quest id, there is a dictionary of images with paths
    
    NSString *savedImagesDict = @"savedImagesDict";
    
    //try to load dict:
    NSDictionary* imagesDict = [[NSUserDefaults standardUserDefaults] objectForKey:savedImagesDict];
    //NSLog(@"loaded dict: %@",imagesDict);
    
    //check whether exists
    if (imagesDict!=nil) {
        NSDictionary *questImages = [imagesDict objectForKey:questId];
        
        //maybe the images for this quest haven't been cached yet.
        
        //check that the questImages is "takin"
        if (questImages!=nil) {
            NSString *imagePath = [questImages valueForKey:imgName];
            
            return imagePath;
        }
    }
    
    return nil;
}

- (void) addPathForSavedImage: (NSString *)imgName withQuestId:(NSString *)questId {
    //for each quest id, there is a dictionary of images with paths
    
    NSString *savedImagesDict = @"savedImagesDict";
    
    //try to load dict:
    NSMutableDictionary *imagesDict = [[[NSUserDefaults standardUserDefaults] objectForKey:savedImagesDict] mutableCopy];
    
    //NSLog(@"loaded imagesDict: %@",imagesDict);
    
    NSString *imgPath = [NSString stringWithFormat:@"%@_%@", questId, imgName];
    
    if (imagesDict==nil) {
        //create the dict that we are going to save:
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:imgPath forKey:imgName];
        
        imagesDict = [[NSMutableDictionary alloc] init];
        [imagesDict setObject:dict forKey:questId];
        
        //saving stuff:
        [[NSUserDefaults standardUserDefaults] setObject:imagesDict forKey:savedImagesDict];
    } else {
        // the dictionary exists, but the quest might not be cached
        NSMutableDictionary *questImagesDict = [[imagesDict objectForKey:questId] mutableCopy];
        
        //maybe the images for this quest haven't been cached yet.
        if (questImagesDict==nil) {

            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:imgPath forKey:imgName];

            [imagesDict setObject:dict forKey:questId];
            
            //saving stuff:
            [[NSUserDefaults standardUserDefaults] setObject:imagesDict forKey:savedImagesDict];
        } else {
            //NSLog(@"before: questImagesDict: %@",questImagesDict);

            //the quest exists in the existing dictionary
            NSString *imagePath = [questImagesDict objectForKey:imgName];
            
            //if the image is there, no need adding it
            if (imagePath==nil) {
                [questImagesDict setValue:imgPath forKey:imgName];
                [imagesDict setObject:questImagesDict forKey:questId];

                //saving stuff:
                [[NSUserDefaults standardUserDefaults] setObject:imagesDict forKey:savedImagesDict];
            }
            //NSLog(@"after: questImagesDict: %@",questImagesDict);
        }
        
    }
    
    //NSLog(@"updated dict: %@",imagesDict);
    
}

- (NSString *) getFileFromPath: (NSString *)path {
    NSArray *parts = [path componentsSeparatedByString:@"/"];
    return [parts objectAtIndex:[parts count]-1];
}

- (NSString *) getFileWOExtension: (NSString *)fn {
    NSArray *parts = [fn componentsSeparatedByString:@"."];
    return [parts firstObject];
}

- (UIView *) drawLine: (CGRect)rect {
    UIView *v = [[UIView alloc] initWithFrame:rect];
    v.opaque = YES;
    v.backgroundColor = [UIColor colorWithRed:16/255.0f green:62/255.0f blue:65/255.0f alpha:1.0f];
    v.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    return v;
}

- (void) drawLine1: (CGRect)rect toView: (UIView *)v {
    CAShapeLayer *lineShape = nil;
    CGMutablePathRef linePath = nil;
    linePath = CGPathCreateMutable();
    lineShape = [CAShapeLayer layer];
    
    lineShape.lineWidth = 1.f;
    lineShape.lineCap = kCALineCapSquare;
    lineShape.strokeColor = [[UIColor grayColor] CGColor];
    
    int x = rect.origin.x;
    int y = rect.origin.y;
    int toX = rect.origin.x+rect.size.width;
    int toY = rect.origin.y+rect.size.height;
    
    CGPathMoveToPoint(linePath, NULL, x, y);
    CGPathAddLineToPoint(linePath, NULL, toX, toY);
    
    lineShape.path = linePath;
    CGPathRelease(linePath);
    [v.layer addSublayer:lineShape];
}

- (BOOL)isRTL: (NSString *)str {
    int c = [[str lowercaseString] characterAtIndex:0];
    
    if (c>=97 && c<=122) {
        NSLog(@"English");
        return NO;
    } else {
        NSLog(@"Not English");
        return YES;
    }
}


@end
