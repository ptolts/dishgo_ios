//
//  Order_Order.h
//  Restaurants
//
//  Created by Philip Tolton on 12/20/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Address_Order.h"
#import "User.h"
#import "Dish_Order.h"

@interface Order_Order : JSONModel
    @property (strong, nonatomic) Address_Order* delivery_address;
    @property (strong, nonatomic) Address_Order* billing_address;
//    @property (strong, nonatomic) NSString *order_id;
//    @property BOOL confirmed;
    @property (strong, nonatomic) NSString *foodcloud_token;
    @property (strong, nonatomic) NSString *restaurant_id;
    @property float total_cost;
    @property (strong, nonatomic) NSArray<Dish_Order>* order;
    - (void) setupJsonWithUser:(User *) user;
    +(BOOL)propertyIsOptional:(NSString*)propertyName;
    -(NSMutableArray *)reverseJsonWithRestaurant:(Restaurant *)resto;
@end
