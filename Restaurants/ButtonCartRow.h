//
//  ButtonCartRow.h
//  Restaurants
//
//  Created by Philip Tolton on 11/22/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishTableViewCell.h"

@class DishTableViewCell;

@interface ButtonCartRow : UIView
    @property (strong,nonatomic) DishTableViewCell *parent;
@end
