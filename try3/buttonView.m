//
//  buttonView.m
//  Quesity
//
//  Created by igor on 5/12/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "buttonView.h"

@implementation buttonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)buttonView
{
    buttonView *customView = [[[NSBundle mainBundle] loadNibNamed:@"buttonView" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[buttonView class]])
        return customView;
    else
        return nil;
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
