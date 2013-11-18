//
//  DishTableViewCell.h
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dishes.h"

@interface DishTableViewCell : UITableViewCell
    @property (nonatomic, strong) IBOutlet UILabel *dishTitle;
    @property (nonatomic, strong) IBOutlet UILabel *dishDescription;
    @property (nonatomic, nonatomic) IBOutlet UILabel *priceLabel;
    @property (nonatomic, strong) Dishes *dish;
    @property int full_height;
    -(NSString *) getPrice;
    -(NSString *) getPriceFast;
    -(void) setPrice;
@end
