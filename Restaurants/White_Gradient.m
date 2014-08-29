//
//  White_Gradient.m
//  DishGo
//
//  Created by Philip Tolton on 2014-07-21.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "White_Gradient.h"

@implementation White_Gradient

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *al = [[UIColor almostBlackColor] colorWithAlphaComponent:1];
    UIColor *all = [[UIColor almostBlackColor] colorWithAlphaComponent:0.3];
    NSArray *gradientColors = [NSArray arrayWithObjects:(id) al.CGColor, [UIColor clearColor].CGColor, nil];
    
    CGFloat gradientLocations[] = {0, 0.75, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColors, gradientLocations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
}


@end
