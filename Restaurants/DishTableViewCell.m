//
//  DishTableViewCell.m
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "DishTableViewCell.h"

@implementation DishTableViewCell {
    float totalPrice;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *) getPrice {
    
    if(totalPrice == 0.0){
        NSLog(@"%.02f",[self.dish.price floatValue]);
        if(self.dish.price == nil){
            totalPrice = 0.0f;
        } else {
            totalPrice = [self.dish.price floatValue];
        }
    }
    
    return [NSString stringWithFormat:@"%.02f", totalPrice];
}

@end
