//
//  QSCQuestCommunicator.m
//  try3
//
//  Created by igor on 2/25/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "QSCQuestCommunicator.h"
#import "QSCQuestsCommunicatorDelegate.h"

@implementation QSCQuestCommunicator

- (void)searchQuestsAtCoordinate
{
    NSString *urlAsString = [NSString stringWithFormat:@"http://quesity.herokuapp.com/all_quests"];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingAllQuestsFailedWithError: error];
        } else {
            [self.delegate receivedAllQuestsJSON: data];
        }
    }];
}


@end
