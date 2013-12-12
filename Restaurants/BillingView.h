//
//  BillingView.h
//  Restaurants
//
//  Created by Philip Tolton on 12/12/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface BillingView : UIView
    @property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *actual_data;
    @property User *u;
    @property (strong, nonatomic) IBOutlet UILabel *street_number;
    - (IBAction)load_current_location:(id)sender;
    //    @property (strong, nonatomic) IBOutlet UIButton *save;
    @property (strong, nonatomic) IBOutlet UILabel *postal_code;
    @property (strong, nonatomic) IBOutlet UILabel *province;
    @property (strong, nonatomic) IBOutlet UILabel *city;
    @property (strong, nonatomic) IBOutlet UILabel *apartment_number;
    @property (strong, nonatomic) IBOutlet UILabel *street_address;
    //    @property (strong, nonatomic) IBOutlet UITextField *phone_number;
    @property (strong, nonatomic) IBOutlet UILabel *first_name;
    @property (strong, nonatomic) IBOutlet UILabel *last_name;
@end
