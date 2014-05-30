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
#import "ReviewTableCell.h"
#import <KVOController/FBKVOController.h>

@class DishTableViewController;
@class DishFooterView;
@class CartRowCell;
@class ReviewTableCell;

@interface DishTableViewCell : UIView
    @property (nonatomic, strong) IBOutlet UILabel *dishTitle;
//    @property (nonatomic, strong) IBOutlet UILabel *dishDescription;
    @property (nonatomic, nonatomic) IBOutlet UILabel *priceLabel;
    @property (nonatomic, strong) DishCellViewLowerHalf *lower_half;
    @property (nonatomic, strong) DishFooterView *dishFooterView;
    @property (nonatomic, strong) CartRowCell *shoppingCartCell;
    @property (nonatomic, strong) ReviewTableCell *reviewCartCell;
    @property NSMutableDictionary *optionViews;
    @property (nonatomic, strong) Dishes *dish;
    @property Restaurant *restaurant;
    @property NSMutableArray *option_views;
    @property DishTableViewController *parent;
    @property int full_height;
    @property BOOL editing;
    @property BOOL final_editing;
    -(float) getPrice;
    -(NSString *) getPriceFast;
    -(void) setupLowerHalf;
    -(void) setPrice;
    -(void) setupShoppingCart;
    -(void) setupReviewCell;
    @property FBKVOController *KVOController;
@end
