//
//  DishTableViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 11/19/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishTableViewCell.h"
#import "CartButton.h"

@interface DishTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
    @property (nonatomic, strong) NSMutableArray *shoppingCart;
    @property (nonatomic, strong) Dishes *dish;
    @property (nonatomic, strong) CartButton *cart;
    @property (nonatomic, strong) IBOutlet UITableView *tableView;
    -(void)addDish:dish_cell;
@end
