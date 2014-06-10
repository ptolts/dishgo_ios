//
//  StorefrontImageView.h
//  Restaurants
//
//  Created by Philip Tolton on 10/29/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StorefrontTableViewController;

@interface StorefrontImageView : UIImageView
    @property Dishes *dish;
    @property StorefrontTableViewController *controller;
@end
