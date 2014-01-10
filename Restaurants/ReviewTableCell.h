//
//  ReviewTableCell.h
//  Restaurants
//
//  Created by Philip Tolton on 1/8/2014.
//  Copyright (c) 2014 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonCartRow.h"

@interface ReviewTableCell : UITableViewCell
    @property (nonatomic, strong) IBOutlet UILabel *dishTitle;
    @property (nonatomic, strong) IBOutlet UILabel *priceLabel;
    @property (strong, nonatomic) IBOutlet UIView *move_me_up_and_down;
    @property (nonatomic, strong) IBOutlet UILabel *quantity;
    @property (strong, nonatomic) IBOutlet UILabel *dish_options;
    @property (nonatomic, strong) IBOutlet ButtonCartRow *edit;
    @property (strong, nonatomic) IBOutlet UIImageView *more_image;
    @property (nonatomic, strong) IBOutlet ButtonCartRow *remove;
    @property (strong, nonatomic) IBOutlet UIView *separator2;
    @property (nonatomic, strong) DishTableViewCell *parent;
    @property (strong, nonatomic) IBOutlet UIView *separator1;
    @property (strong) NSNumber *fullHeight;
    - (void) buttonDash;
@end
