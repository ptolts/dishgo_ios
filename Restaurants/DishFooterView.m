//
//  DishFooterView.m
//  Restaurants
//
//  Created by Philip Tolton on 11/19/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "DishFooterView.h"

@implementation DishFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)stepperValueChanged:(id)sender
{
    double stepperValue = self.stepper.value;
    self.quantity.text = [NSString stringWithFormat:@"%.f", stepperValue];
    [self.parent setPrice];
}

@end
