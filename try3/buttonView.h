//
//  buttonView.h
//  Quesity
//
//  Created by igor on 5/12/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface buttonView : UIButton

@property (weak, nonatomic) IBOutlet UILabel *buttonText;
@property (weak, nonatomic) IBOutlet UIImageView *img;

- (id) initWithBorders: (BOOL)borders;
+ (id)buttonView;

@end
