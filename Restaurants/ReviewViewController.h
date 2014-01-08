//
//  ReviewTableViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 12/18/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ReviewTotal.h"

@interface ReviewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
    @property (nonatomic, strong) NSMutableArray *shopping_cart;
    @property UITableView *tableViewController;
    @property (strong, nonatomic) IBOutlet UITableView *tableView;
    @property (strong, nonatomic) IBOutlet UIView *next_view;
    @property (strong, nonatomic) IBOutlet ReviewTotal *total_view;
    @property User *main_user;
@end
