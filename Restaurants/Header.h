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
#import "White_Gradient.h"

@interface Header : UIView
    @property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tap_info;
    @property (nonatomic, strong) IBOutlet StorefrontScrollView *scroll_view;
    @property (nonatomic, strong) IBOutlet UIView *button_view;
    @property (nonatomic, strong) IBOutlet StorefrontLabel *label;
    @property (nonatomic, strong) IBOutlet UIView *spacer;
    @property (nonatomic, strong) IBOutlet UIView *spacer2;
    @property CGRect scroll_view_original_frame;
    @property (strong, nonatomic) IBOutlet UILabel *phone_label;
    @property (strong, nonatomic) IBOutlet UILabel *map_label;
@property (strong, nonatomic) IBOutlet UILabel *phone_fa;
@property (strong, nonatomic) IBOutlet UILabel *map_fa;
@property (strong, nonatomic) IBOutlet UILabel *hours_fa;
@property (strong, nonatomic) IBOutlet UILabel *hours_label;

    @property (strong, nonatomic) IBOutlet UIView *seperator;
    @property (strong, nonatomic) IBOutlet UIView *separator2;
    @property (strong, nonatomic) IBOutlet White_Gradient *gradient;
    @property (strong, nonatomic) IBOutlet UILabel *restaurant_name;
    @property CGRect button_view_original_frame;
@end
