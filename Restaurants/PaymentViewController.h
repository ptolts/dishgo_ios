//
//  PaymentTableViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 12/12/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "CardIO.h"
#import "STPView.h"

#import "User.h"

@interface PaymentViewController : UIViewController <CardIOPaymentViewControllerDelegate, STPViewDelegate, PKViewDelegate>
    @property User *main_user;
    @property User *bill_user;
    @property (strong, nonatomic) IBOutlet UIView *next_view;
    @property (strong, nonatomic) IBOutlet UIScrollView *scroll_view;
    @property (strong, nonatomic) IBOutlet UIButton *confirm;
    @property (nonatomic, strong) NSMutableArray *shoppingCart;
    -(void) scanCardMethod: sender;
    @property (strong, nonatomic) IBOutlet UIButton *scan_card;
    @property STPView* stripeView;
    @property IBOutlet PKView* paymentView;
//    @property PaymentViewController *controller;
    -(void) setup;
    @property (strong, nonatomic) IBOutlet UIImageView *secured_image;
    @property IBOutlet UIView *b_view;
    @property IBOutlet PKTextField *card_field;
    @property IBOutlet PKTextField *card_date;
    @property IBOutlet PKTextField *card_cvv;
    @property IBOutlet UIImageView *card_image;
    @property IBOutlet UIView *card_bg;
    @property (strong, nonatomic) IBOutlet UIView *bg;
    @property IBOutlet UIButton *completeButton;
    - (void) confirmDetails;
@end
