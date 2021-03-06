//
//  RestoScrollView.h
//  Restaurants
//
//  Created by Philip Tolton on 10/25/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantViewController.h"

@interface RestoScrollView : UIScrollView
    @property int numberOfPages;
    - (void) scrollPages:(int) i;
    - (void) killScroll;
    @property int currentPage;
    @property Restaurant *restaurant;
    @property RestaurantViewController *segue_controller;
@end
