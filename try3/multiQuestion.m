//
//  multiQuestion.m
//  Quesity
//
//  Created by igor on 6/13/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "multiQuestion.h"
#import "myGlobalData.h"

@implementation multiQuestion
    static NSString *cellIdentifier;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithlinks:(NSArray *)links
{
    self = [super init];
    if (self) {
        self.tableOptions.delegate = self;
        self.tableOptions.dataSource = self;
        
        self.opts = [links copy];

        cellIdentifier = @"rowCell";
        [self.tableOptions registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        
        self.layer.cornerRadius = 20;
        self.clipsToBounds = YES;
        
        [self.layer setBorderWidth:3.0];
        [self.layer setBorderColor:[QUESITY_COLOR_BG CGColor]];   //Adding Border color.
        
        self.btnCancel.layer.cornerRadius = 5;
        self.btnCancel.clipsToBounds = YES;

    }
    return self;
}


+ (id)multiQuestionView
{
    multiQuestion *customView = [[[NSBundle mainBundle] loadNibNamed:@"multiQuestion" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[multiQuestion class]])
        return customView;
    else
        return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.opts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"\u202B%@",[self.opts objectAtIndex:indexPath.row]];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping; // Pre-iOS6 use UILineBreakModeWordWrap
    cell.textLabel.numberOfLines = 2;  // 0 means no max.
    cell.textLabel.textAlignment = UITextLayoutDirectionRight;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@ was chosen", indexPath);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
