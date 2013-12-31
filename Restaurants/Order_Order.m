//
//  Order_Order.m
//  Restaurants
//
//  Created by Philip Tolton on 12/20/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "Order_Order.h"
#import "DishTableViewCell.h"


@implementation Order_Order

@synthesize billing_address;
@synthesize delivery_address;
@synthesize order;
@synthesize foodcloud_token;

    -(void)setupJsonWithUser:(User *)user {
        billing_address = [[Address_Order alloc] initBillingWithUser:user];
        delivery_address = [[Address_Order alloc] initDeliveryWithUser:user];
        foodcloud_token = user.foodcloud_token;
        
        NSMutableArray *order_mutable = [[NSMutableArray alloc] init];
        
        for(DishTableViewCell *dish_cell in user.shopping_cart){
            Dish_Order *dish = [[Dish_Order alloc] initWithDishCell:dish_cell];
            [order_mutable addObject:dish];
        }
        
        self.order = [order_mutable copy];
    }

//    +(BOOL)propertyIsOptional:(NSString*)propertyName
//    {
//        NSLog(@"%@",propertyName);
//        return YES;
//    }

@end
