//
//  StorefrontScrollView.h
//  Restaurants
//
//  Created by Philip Tolton on 10/29/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorefrontLabel.h"

@interface StorefrontScrollView : UIScrollView
    @property (nonatomic, strong) Restaurant *restaurant;
    @property (nonatomic, strong) StorefrontLabel *label;
    -(void)setupImages;
@end
