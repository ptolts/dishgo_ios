//
//  User.h
//  Restaurants
//
//  Created by Philip Tolton on 11/28/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
    @property (nonatomic, copy) NSString *facebook_token;
    @property (nonatomic, copy) NSString *facebook_id;
    @property (nonatomic, copy) NSString *facebook_name;
    @property (nonatomic, copy) NSString *foodcloud_token;
    @property (nonatomic, copy) NSString *password;
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
@end
