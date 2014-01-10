//
//  DishTableViewCell.m
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "SectionDishViewCell.h"
#import "DishTableViewCell.h"
#import "OptionsView.h"

@implementation SectionDishViewCell {
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
    
    if(self.dish.price == nil){
        totalPrice = 0.0f;
    } else {
        totalPrice = [self.dish.price floatValue];
    }
    
    for (OptionsView *priceView in [self.contentView subviews]){
//        NSLog(@"Querying price on view with tag %d and class of %@",priceView.tag,priceView.class);
        if (priceView.tag == 12347){
            totalPrice += [priceView getPrice];
        }
    }
    
    return [NSString stringWithFormat:@"%.02f", totalPrice];
}

-(NSString *) getPriceFast {
    
    if(self.dish.price == nil){
        totalPrice = 0.0f;
    } else {
        totalPrice = [self.dish.price floatValue];
    }
    
    if(totalPrice == 0.0){
        return @"-";
    } else {
        return [NSString stringWithFormat:@"%.02f", totalPrice];
    }
}


-(void) setPrice {
    NSLog(@"Updating price %@",[self getPrice]);
    self.priceLabel.text = [self getPrice];
}


- (void) layoutSubviews {
    [super layoutSubviews];
//    NSLog(@"FRAME: %@",CGRectCreateDictionaryRepresentation(self.dishImage.frame));
}
@end
