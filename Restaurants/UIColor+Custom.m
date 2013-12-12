//
//  UIColor+ScarletColor.m
//  Restaurants
//
//  Created by Philip Tolton on 12/2/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

    + (UIColor*)scarletColor {
        return [UIColor colorWithRed:207.0/255.0 green:47.0/255.0 blue:40.0/255.0 alpha:1];
    }

    + (UIColor*)bgColor {
        return [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    }

    + (UIColor*)textColor {
        return [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1];
    }

    + (UIColor*)seperatorColor {
        return [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1];
    }

    + (UIColor*)almostBlackColor {
        return [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1];
    }

    + (UIColor*)titleRed {
        return [UIColor colorWithRed:(192/255.0) green:0 blue:0 alpha:0.9];
    }

@end
