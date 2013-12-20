//
//  Address_Order.h
//  Restaurants
//
//  Created by Philip Tolton on 12/20/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "User.h"

@interface Address_Order : JSONModel
    @property (nonatomic, copy) NSString *email;
    @property (nonatomic, copy) NSString *phone_number;
    @property (nonatomic, copy) NSString *street_address;
    @property (nonatomic, copy) NSString *street_number;
    @property (nonatomic, copy) NSString *apartment_number;
    @property (nonatomic, copy) NSString *city;
    @property (nonatomic, copy) NSString *postal_code;
    @property (nonatomic, copy) NSString *province;
    @property (nonatomic, copy) NSString *first_name;
    @property (nonatomic, copy) NSString *last_name;
    -(Address_Order *) initBillingWithUser:(User *) user;
    -(Address_Order *) initDeliveryWithUser:(User *) user;
@end
