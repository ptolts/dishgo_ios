//
//  User.h
//  Restaurants
//
//  Created by Philip Tolton on 11/28/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Stripe/Stripe.h>
#import <JSONModel.h>
#import "Order_Status.h"
#import "Restaurant.h"


@interface User  : JSONModel
    @property (nonatomic, copy) NSString *facebook_token;
    @property (nonatomic, copy) NSString *facebook_id;
    @property (nonatomic, copy) NSString *facebook_name;
    @property (nonatomic, copy) NSString *owns_restaurant_id;
    @property (nonatomic, copy) NSString *foodcloud_token;
    @property (nonatomic, copy) NSString *password;
    @property (nonatomic, copy) NSString *email;
    @property (nonatomic, copy) NSString *phone_number;
    @property (nonatomic, copy) NSString *street_address;
    @property (nonatomic, copy) NSString *street_number;
    @property (nonatomic, copy) NSString *apartment_number;
    @property (nonatomic, copy) NSString *city;
    @property (nonatomic, copy) NSNumber *dishcoins;
    @property (nonatomic, copy) NSString *postal_code;
    @property (nonatomic, copy) NSString *province;
    @property (nonatomic, copy) NSString *first_name;
    @property (nonatomic, copy) NSString *last_name;
    @property (nonatomic, copy) NSArray<Order_Status> *current_orders;
    @property BOOL confirm_address;
    @property BOOL is_admin;
    @property BOOL payment_details;
    @property BOOL confirm_billing;
    @property BOOL review_confirm;
    @property BOOL validCreditCard;
    @property (nonatomic, copy) NSString *cc_number;
    @property (nonatomic, copy) NSString *month;
    @property (nonatomic, copy) NSString *year;
    @property (nonatomic, copy) NSString *secret_number;
    @property STPCard *stripeCard;
    @property User *billing_user;
    @property Restaurant *restaurant;
    @property NSMutableArray *shopping_cart;
    -(NSString *) get_full_name;
    +(BOOL)propertyIsOptional:(NSString*)propertyName;
@end
