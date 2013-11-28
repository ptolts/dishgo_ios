//
//  SignUpViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 11/27/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
    - (IBAction)foodcloudSignUp:(id)sender;
    -(IBAction)dissmissKeyboard;

    @property IBOutlet UIButton *signUp;

    @property IBOutlet UITextField *username;
    @property IBOutlet UITextField *password;
@end
