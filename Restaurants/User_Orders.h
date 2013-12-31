//
//  User_Orders.h
//  Restaurants
//
//  Created by Philip Tolton on 12/31/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
#import "Order_Status.h"

@interface User_Orders : JSONModel
    @property (strong, nonatomic) NSArray<Order_Status>* orders;
@end
