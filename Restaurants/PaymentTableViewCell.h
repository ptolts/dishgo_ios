//
//  PaymentTableViewCell.h
//  Restaurants
//
//  Created by Philip Tolton on 12/12/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIO.h"
#import "STPView.h"
#import "User.h"

@interface PaymentTableViewCell : UITableViewCell <CardIOPaymentViewControllerDelegate, STPViewDelegate, PKViewDelegate>

    @property (strong, nonatomic) IBOutlet UIButton *confirm;
    @property (nonatomic, strong) NSMutableArray *shoppingCart;
    -(void) scanCardMethod: sender;
    @property User *main_user;
    @property (strong, nonatomic) IBOutlet UIButton *scan_card;
    @property STPView* stripeView;
    @property IBOutlet PKView* paymentView;
    @property UITableViewController *controller;
    -(void) setup;
@end
