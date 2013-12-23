//
//  CheckoutTableViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 12/9/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
    @property (nonatomic, strong) NSMutableArray *shoppingCart;
    @property (strong, nonatomic) IBOutlet UITableView *tableView;
    @property (strong, nonatomic) IBOutlet UIView *next_view;
    @property UIButton *next_but;
@end
