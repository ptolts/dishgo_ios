//
//  Header.h
//  Restaurants
//
//  Created by Philip Tolton on 10/29/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorefrontLabel.h"
#import "StorefrontScrollView.h"

@interface Header : UIView
    @property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tap_info;
    @property (nonatomic, strong) IBOutlet StorefrontScrollView *scroll_view;
    @property (nonatomic, strong) IBOutlet UIView *button_view;
    @property (nonatomic, strong) IBOutlet StorefrontLabel *label;
    @property (nonatomic, strong) IBOutlet UIView *spacer;
    @property (nonatomic, strong) IBOutlet UIView *spacer2;
    @property CGRect scroll_view_original_frame;
    @property CGRect button_view_original_frame;
@end
