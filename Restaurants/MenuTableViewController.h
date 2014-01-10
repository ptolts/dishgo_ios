//
//  MenuTableViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 10/28/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
    @property (nonatomic, assign) BOOL shopping;
    @property (nonatomic, strong) NSMutableArray *shopping_cart;
    @property (nonatomic, strong) IBOutlet UITableView *tableView;
    @property (nonatomic, strong) IBOutlet UIView *checkout_view;
    @property Restaurant *restaurant;
    -(void) setupMenu;
    -(void) checkout;
@end
