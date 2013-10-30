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
    @property (nonatomic, strong) IBOutlet StorefrontScrollView *scroll_view;
    @property (nonatomic, strong) IBOutlet StorefrontLabel *label;
@end
