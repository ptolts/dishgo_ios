//
//  CheckoutView.h
//  Restaurants
//
//  Created by Philip Tolton on 11/13/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutView : UIView
    @property (strong, nonatomic) IBOutlet UILabel *tax_label;
    @property (strong, nonatomic) IBOutlet UILabel *tax_amount;
    @property (strong, nonatomic) IBOutlet UIButton *checkout;
    @property (strong, nonatomic) IBOutlet UILabel *total_cost;
    @property (strong, nonatomic) IBOutlet UILabel *total_label;
    @property (strong, nonatomic) IBOutlet UIView *seperator;
@end

