//
//  Address_Order.m
//  Restaurants
//
//  Created by Philip Tolton on 12/20/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "Address_Order.h"

@implementation Address_Order
    -(Address_Order *) initBillingWithUser:(User *)user {
        _phone_number = user.billing_user.phone_number;
        _street_number = user.billing_user.street_number;
        _street_address = user.billing_user.street_address;
        _city = user.billing_user.city;
        _postal_code = user.billing_user.postal_code;
        _province = user.billing_user.province;
        _last_name = user.billing_user.last_name;
        _first_name = user.billing_user.first_name;
        return self;
    }

    -(Address_Order *) initDeliveryWithUser:(User *)user {
        _phone_number = user.phone_number;
        _street_number = user.street_number;
        _street_address = user.street_address;
        _city = user.city;
        _postal_code = user.postal_code;
        _province = user.province;
        _last_name = user.last_name;
        _first_name = user.first_name;
        return self;
    }

    +(BOOL)propertyIsOptional:(NSString*)propertyName
    {
//        NSLog(@"Optional Property: %@",propertyName);
        return YES;
    }
@end
