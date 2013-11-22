//
//  CheckoutViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 11/21/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIO.h"
#import "STPView.h"

@interface CheckoutViewController : UIViewController <CardIOPaymentViewControllerDelegate, STPViewDelegate>
    @property (nonatomic, strong) NSMutableArray *shoppingCart;
    @property (nonatomic, strong) IBOutlet UIButton *scanCard;
    -(void) scanCardMethod: sender;
    @property STPView* stripeView;
@end
