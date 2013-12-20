//
//  Dish_Order.m
//  Restaurants
//
//  Created by Philip Tolton on 12/20/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "Dish_Order.h"
#import "Dishes.h"
#import "OptionsView.h"


@implementation Dish_Order

-(Dish_Order *) initWithDishCell:(DishTableViewCell *)dish_cell {
    Dishes *dish = dish_cell.dish;
    _name = dish.name;
    _ident = dish.id;
    NSMutableArray *opts = [[NSMutableArray alloc] init];
    NSLog(@"OPTIONVIEWS: %d", [dish_cell.option_views count]);
    for(OptionsView *o in dish_cell.option_views){
        Options_Order *oo = [[Options_Order alloc] init];
        oo.options = [o.option_order_json copy];
        NSLog(@"Option Size: %d", [oo.options count]);
        oo.name = o.op.name;
        oo.ident = o.op.id;
        [opts addObject:oo];
    }
    _options = [opts copy];
    return self;
}

@end
