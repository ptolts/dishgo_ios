//
//  DishViewCell.h
//  Restaurants
//
//  Created by Philip Tolton on 10/31/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMPageControl.h>
#import "DishScrollView.h"
#import "DishTableViewController.h"

//@class DishTableViewController;

@interface DishViewCell : UITableViewCell <UIScrollViewDelegate>
    @property (strong, nonatomic) IBOutlet SMPageControl *page_tracker;
    @property (strong, nonatomic) IBOutlet UIView *plus_area;
    @property (strong, nonatomic) IBOutlet UILabel *plus;
    @property (strong, nonatomic) IBOutlet UILabel *see_more;
    @property (nonatomic, strong) IBOutlet DishScrollView *dishScrollView;
    @property StorefrontTableViewController *controller;
    -(void) trackPage;
@end
