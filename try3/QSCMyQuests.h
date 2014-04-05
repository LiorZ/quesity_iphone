//
//  QSCMyQuests.h
//  try3
//
//  Created by igor on 2/14/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSCQuest.h"
#import "TPFloatRatingView.h"

@interface QSCMyQuests : UITableViewController //<TPFloatRatingViewDelegate>
- (NSString *) parseString2Hebrew:(NSString *)str2parse;

//@property (weak, nonatomic) IBOutlet TPFloatRatingView *ratingViewFloat;
//@property (weak, nonatomic) IBOutlet TPFloatRatingView *ratingView;
//@property (weak, nonatomic) IBOutlet TPFloatRatingView *ratingView1;


//@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end
