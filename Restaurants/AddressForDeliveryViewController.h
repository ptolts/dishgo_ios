//
//  AddressForDeliveryViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 12/11/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileView.h"
#import "AddressView.h"
#import "User.h"

@interface AddressForDeliveryViewController : UIViewController
    @property (strong, nonatomic) IBOutlet ProfileView *user_info;
    @property (strong, nonatomic) IBOutlet AddressView *user_address;
    @property User *main_user;
    @property User *bill_user;
@end
