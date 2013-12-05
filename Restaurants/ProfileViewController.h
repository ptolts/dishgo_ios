//
//  ProfileViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 12/4/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ProfileViewController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate>
- (IBAction)save:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *street_number;
    - (IBAction)load_current_location:(id)sender;
    @property (strong, nonatomic) IBOutlet UIButton *load_current;
    @property (strong, nonatomic) IBOutlet UIButton *save;
    @property (strong, nonatomic) IBOutlet UITextField *postal_code;
    @property (strong, nonatomic) IBOutlet UITextField *province;
    @property (strong, nonatomic) IBOutlet UITextField *city;
    @property (strong, nonatomic) IBOutlet UITextField *apartment_number;
    @property (strong, nonatomic) IBOutlet UITextField *street_address;
    @property (strong, nonatomic) IBOutlet UITextField *phone_number;
    @property IBOutlet UIView *bg;
    @property IBOutlet UIView *bg2;
@end