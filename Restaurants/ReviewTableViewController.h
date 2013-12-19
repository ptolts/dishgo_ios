//
//  ReviewTableViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 12/18/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ReviewTableViewController : UITableViewController
    @property (nonatomic, strong) NSMutableArray *shopping_cart;
    @property UITableView *tableViewController;
    @property User *main_user;
@end
