//
//  multiQuestion.h
//  Quesity
//
//  Created by igor on 6/13/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface multiQuestion : UIView <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *labeltitle;

@property (weak, nonatomic) IBOutlet UITableView *tableOptions;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property NSArray *opts;


+ (id)multiQuestionView;
- (id)initWithlinks:(NSArray *)links;

@end
