//
//  CheckoutTableViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 12/9/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutTableViewController : UITableViewController
    @property (nonatomic, strong) NSMutableArray *shoppingCart;
    @property UIButton *next_but;
@end
