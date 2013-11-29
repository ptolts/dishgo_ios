//
//  SignInViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 11/22/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController

    - (IBAction)facebookSignIn:(id)sender;
    - (IBAction)foodcloudSignIn:(id)sender;
    - (IBAction)foodcloudSignUp:(id)sender;

    @property IBOutlet UIView *bg;

    @property IBOutlet UIButton *signUp;
    @property IBOutlet UIButton *signIn;
    @property IBOutlet UIButton *signInFacebook;

    @property IBOutlet UITextField *username;
    @property IBOutlet UITextField *password;

@end
