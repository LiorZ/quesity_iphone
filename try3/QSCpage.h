//
//  QSCpage.h
//  try3
//
//  Created by igor on 3/22/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSCQuest.h"

@class QSCpage;
@protocol QSCpageDelegate <NSObject>
- (void)QSCpageDidSave:(QSCpage *)controller;
@end

@interface QSCpage : UIViewController
@property IBOutlet QSCQuest *quest;
@property IBOutlet NSArray *content;
@property IBOutlet NSArray *is_first;
@property IBOutlet NSArray *linksToOthers;
@property IBOutlet NSArray *pagesId;
@property NSUInteger currPage;
@property (weak, nonatomic) IBOutlet UIButton *didPressButton2;

@property (weak, nonatomic) IBOutlet UIWebView *webStuff2;

//sague back buisness
@property (nonatomic, weak) id <QSCpageDelegate> delegate;
- (IBAction)back:(id)sender;

@property UIWebView *webStuff3;

@end
