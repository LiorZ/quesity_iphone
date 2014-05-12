//
//  buttonView.m
//  Quesity
//
//  Created by igor on 5/12/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "buttonView.h"
#import "myGlobalData.h"

@implementation buttonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id) initWithBorders: (BOOL)borders {
    self.backgroundColor = QUESITY_COLOR_BG;
    [self.buttonText setTextColor:QUESITY_COLOR_FONT];

    //adding borders on sides and top:
    CGSize mainViewSize = self.bounds.size;
    CGFloat borderWidth = 1.f;
    UIColor *borderColor = QUESITY_COLOR_FONT;

    if (borders) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, borderWidth, mainViewSize.height)];
        leftView.opaque = YES;
        leftView.backgroundColor = borderColor;
        leftView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:leftView];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(mainViewSize.width - borderWidth, 0, borderWidth, mainViewSize.height)];
        rightView.opaque = YES;
        rightView.backgroundColor = borderColor;
        rightView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:rightView];
    }
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainViewSize.width, borderWidth)];
    topView.opaque = YES;
    topView.backgroundColor = borderColor;
    topView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:topView];
    
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
