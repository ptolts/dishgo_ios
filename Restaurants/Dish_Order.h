//
//  Dish_Order.h
//  Restaurants
//
//  Created by Philip Tolton on 12/20/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Options_Order.h"
#import "DishTableViewCell.h"

@protocol Dish_Order

@end

@interface Dish_Order : JSONModel
    @property (strong, nonatomic) NSString* name;
    @property float total_price;
    @property int quantity;
    @property (strong, nonatomic) NSArray<Options_Order>* options;
    @property (strong, nonatomic) NSString* ident;
    -(Dish_Order *) initWithDishCell:(DishTableViewCell *)dish_cell;
@end
