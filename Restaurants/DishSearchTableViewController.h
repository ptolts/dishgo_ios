//
//  DishSearchTableViewController.h
//  DishGo
//
//  Created by Philip Tolton on 2014-07-31.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishSearchTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
    @property (strong, nonatomic) IBOutlet UISearchDisplayController *search_bar;
    @property (strong, nonatomic) IBOutlet UISearchBar *bar;
    @property Restaurant *restaurant;
    @property (nonatomic, strong) NSMutableArray *shoppingCart;
@end
