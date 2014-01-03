//
//  StorefrontScrollView.h
//  Restaurants
//
//  Created by Philip Tolton on 10/29/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StorefrontLabel.h"
#import "StorefrontImageView.h"

@protocol StoreFrontScrollViewDelegate;

@interface StorefrontScrollView : UIScrollView <UIScrollViewDelegate>
    @property (nonatomic, strong) Restaurant *restaurant;
    @property (nonatomic, strong) StorefrontLabel *label;
    @property (nonatomic, weak) id<StoreFrontScrollViewDelegate> img_delegate;
    -(void)setupImages;
@end

@protocol StoreFrontScrollViewDelegate <NSObject>

- (void)currentImageView:(StorefrontImageView *)current;

@end