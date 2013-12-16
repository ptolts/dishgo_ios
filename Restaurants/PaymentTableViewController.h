//
//  PaymentTableViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 12/12/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface PaymentTableViewController : UITableViewController
    @property User *main_user;
    @property User *bill_user;
@end
