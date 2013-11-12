//
//  TableHeaderViewGradient.m
//  Restaurants
//
//  Created by Philip Tolton on 11/12/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "TableHeaderViewGradient.h"

@implementation TableHeaderViewGradient

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
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id) [UIColor whiteColor].CGColor, [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor, nil];
    
    CGFloat gradientLocations[] = {0, 0.75, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColors, gradientLocations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)/2);
    
//    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)/2);
    endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, endPoint, startPoint, 0);
    
    CGGradientRelease(gradient);
}

@end
