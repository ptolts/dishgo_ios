//
//  FilterDishButton.m
//  DishGo
//
//  Created by Philip Tolton on 2014-07-31.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "FilterDishButton.h"
#import "FilterDishView.h"
#import "RAppDelegate.h"
#import <FAKFontAwesome.h>

@implementation FilterDishButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (FilterDishButton *) x:(float)x y:(float)y {
    FilterDishView *filter = [[[NSBundle mainBundle] loadNibNamed:@"FilterDishView" owner:self options:nil] objectAtIndex:0];
    [filter setUserInteractionEnabled:NO];
    CGRect old_frame = filter.frame;
    UIWindow *mainWindow = (((RAppDelegate *)[UIApplication sharedApplication].delegate).window);
    float y_index = mainWindow.frame.size.height - old_frame.size.height - y;
    CGRect frame = CGRectMake(x,y_index,old_frame.size.width,old_frame.size.height);
    FilterDishButton *s = [[FilterDishButton alloc] initWithFrame:frame];
    FAKFontAwesome *searchIcon = [FAKFontAwesome searchIconWithSize:25.0f];
    [searchIcon addAttribute:NSForegroundColorAttributeName value:[UIColor scarletColor]];
    filter.search_label.attributedText = [searchIcon attributedString];
    [s addSubview:filter];
    [s bringSubviewToFront:filter];
    return s;
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
