//
//  OptionButton.m
//  DishGo
//
//  Created by Philip Tolton on 2014-05-30.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "OptionButton.h"
#import "SizePrices.h"

@implementation OptionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) updatePrice: (NSString *)size_id {
    Option *opt = self.option;
    for(SizePrices *size_price in opt.size_prices){
        if([size_price.related_to_size isEqualToString:size_id]){
            self.option.price = size_price.price;
            self.price = [size_price.price floatValue];
            [self setTitle:[NSString stringWithFormat:@"%@\n$%@",self.option.name,size_price.price ] forState:UIControlStateNormal];
            [self setTitle:[NSString stringWithFormat:@"%@\n$%@",self.option.name,size_price.price ] forState:UIControlStateSelected];
        }
    }
}

@end
