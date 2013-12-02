//
//  StorefrontGradientView.m
//  Restaurants
//
//  Created by Philip Tolton on 10/29/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "StorefrontGradientView.h"

@implementation StorefrontGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    NSArray *gradientColors = [NSArray arrayWithObjects:(id) [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9].CGColor, [UIColor clearColor].CGColor, nil];
//    
//    CGFloat gradientLocations[] = {0, 1};
//    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColors, gradientLocations);
//    
//    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
//    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
//    
//    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
//    CGGradientRelease(gradient);
//}



@end
