//
//  CartRowCell.h
//  Restaurants
//
//  Created by Philip Tolton on 11/19/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishTableViewCell.h"
#import "ButtonCartRow.h"

@class DishTableViewCell;
@class ButtonCartRow;

@interface CartRowCell : UITableViewCell
    @property (strong, nonatomic) IBOutlet UIView *seperator;
    @property (nonatomic, strong) IBOutlet UILabel *dishTitle;
    @property (nonatomic, strong) IBOutlet UILabel *priceLabel;
    @property (nonatomic, strong) IBOutlet UILabel *quantity;
    @property (nonatomic, strong) IBOutlet ButtonCartRow *edit;
@property (strong, nonatomic) IBOutlet UILabel *edit_label;
    @property (strong, nonatomic) IBOutlet UIImageView *more;
@property (strong, nonatomic) IBOutlet UILabel *remove_label;
    @property (nonatomic, strong) IBOutlet ButtonCartRow *remove;
    @property (nonatomic, strong) DishTableViewCell *parent;
    @property (strong) NSNumber *fullHeight;
    - (void) buttonDash;
@end
