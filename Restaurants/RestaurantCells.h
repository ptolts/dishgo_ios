//
//  RestaurantCells.h
//  Restaurants
//
//  Created by Philip Tolton on 2013-10-08.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestoScrollView.h"

@interface RestaurantCells : UITableViewCell
    @property (nonatomic, strong) IBOutlet UILabel* restaurantLabel;
    @property (nonatomic,strong) IBOutlet RestoScrollView* scrollView;
@end
