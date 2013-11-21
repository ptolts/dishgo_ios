//
//  DishTableViewCell.h
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dishes.h"
#import "DishCellViewLowerHalf.h"
#import "DishTableViewController.h"
#import "CartRowCell.h"
#import "DishFooterView.h"

@class DishTableViewController;

@interface DishTableViewCell : UIView
    @property (nonatomic, strong) IBOutlet UILabel *dishTitle;
//    @property (nonatomic, strong) IBOutlet UILabel *dishDescription;
    @property (nonatomic, nonatomic) IBOutlet UILabel *priceLabel;
    @property (nonatomic, nonatomic) DishCellViewLowerHalf *lower_half;
    @property (nonatomic, nonatomic) DishFooterView *dishFooterView;
    @property (nonatomic, nonatomic) CartRowCell *shoppingCartCell;
    @property (nonatomic, strong) Dishes *dish;
    @property DishTableViewController *parent;
    @property int full_height;
    -(NSString *) getPrice;
    -(NSString *) getPriceFast;
    -(void) setupLowerHalf;
    -(void) setPrice;
@end
