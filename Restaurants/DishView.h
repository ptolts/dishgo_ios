//
//  DishView.h
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StorefrontTableViewController;

@interface DishView : UIView
    @property (strong, nonatomic) IBOutlet UILabel *see_more;
    @property (strong, nonatomic) IBOutlet UIImageView *more;
    @property (strong, nonatomic) IBOutlet UIImageView *plus;
    @property (nonatomic, strong) IBOutlet UILabel *dishTitle;
    @property (nonatomic, strong) IBOutlet UILabel *dishDescription;
    @property (nonatomic, strong) IBOutlet UILabel *read_more;
    @property (nonatomic, strong) IBOutlet UIImageView *left_arrow;
    @property (nonatomic, strong) IBOutlet UIImageView *right_arrow;
    @property IBOutlet UIView *seperator;
//    - (void) setupPlus;
    @property StorefrontTableViewController *controller;
@end
