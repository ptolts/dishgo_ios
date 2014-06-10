//
//  SortView.m
//  DishGo
//
//  Created by Philip Tolton on 2014-06-09.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "SortView.h"

@implementation SortView {
    UIImageView *imageView;
}

@synthesize selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setupView: (NSString *)title type: (int) option_type value: (int) value {
    self.value = value;
    self.option_type = option_type;
    UIColor *sign_in_color = sign_in_color = [UIColor whiteColor];
    int sortIconSize = 15;
    int sortStartPoint = 70;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(sortStartPoint, 5, sortIconSize, sortIconSize)];
    [imageView setContentMode:UIViewContentModeCenter];
    imageView.image = [UIImage imageNamed:[[NSString stringWithFormat:@"%@.png",title] lowercaseString]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = sortIconSize / 2.0;
    imageView.layer.borderColor = sign_in_color.CGColor;
    imageView.layer.borderWidth = 1.5f;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    imageView.layer.shouldRasterize = YES;
    imageView.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(sortIconSize + 20 + sortStartPoint, (sortIconSize / 2.0) - 5, 100, 20)];
    label.text = title;
    label.textColor = sign_in_color;
    label.font = [UIFont fontWithName:@"GurmukhiMN-Bold" size:16.0f];
    label.layer.cornerRadius = 5.0f;
    label.textAlignment = NSTextAlignmentLeft;
    label.userInteractionEnabled = NO;
    
    CGRect frame = CGRectMake(0, 0, imageView.frame.size.width + label.frame.size.width, 54);
    frame.origin.x = 10.0;
    self.frame = frame;
    
    [self addSubview:imageView];
    [self addSubview:label];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(select:)];
    [self addGestureRecognizer:singleFingerTap];
}

- (void)select:(UITapGestureRecognizer *)recognizer {
    self.selected = !self.selected;
    if(self.selected){
        imageView.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

-(void) setSelectedWithoutKvo {
    selected = NO;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
