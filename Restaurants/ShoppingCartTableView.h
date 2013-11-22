//
//  ShoppingCartTableView.h
//  Restaurants
//
//  Created by Philip Tolton on 11/13/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
    @property (nonatomic, strong) NSMutableArray *shopping_cart;
    @property UITableView *tableViewController;
@end
