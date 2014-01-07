//
//  DishViewCell.h
//  Restaurants
//
//  Created by Philip Tolton on 10/31/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishScrollView.h"

@interface DishViewCell : UITableViewCell <UIScrollViewDelegate>
    @property (strong, nonatomic) IBOutlet UIPageControl *page_tracker;
    @property (nonatomic, strong) IBOutlet DishScrollView *dishScrollView;
    -(void) trackPage;
@end
