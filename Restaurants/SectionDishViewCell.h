//
//  SectionDishViewCell.h
//  Restaurants
//
//  Created by Philip Tolton on 11/19/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionDishViewCell : UITableViewCell
    @property (nonatomic, strong) IBOutlet UILabel *dishTitle;
    @property (nonatomic, strong) IBOutlet UILabel *dishDescription;
    @property (strong, nonatomic) IBOutlet UIImageView *dishImage;
    @property (nonatomic, nonatomic) IBOutlet UILabel *priceLabel;
    @property (nonatomic, nonatomic) IBOutlet UIView *seperator;
    @property (nonatomic, strong) Dishes *dish;
    @property int full_height;
    -(NSString *) getPrice;
    -(NSString *) getPriceFast;
    -(void) setPrice;
@end
