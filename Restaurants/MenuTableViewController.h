//
//  MenuTableViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 10/28/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewController : UITableViewController
    @property (nonatomic, assign) BOOL shopping;
    @property (nonatomic, strong) NSMutableArray *shopping_cart;
    -(void) setupMenu;
@end
