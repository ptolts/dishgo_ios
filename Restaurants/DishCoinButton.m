//
//  DishCoinButton.m
//  DishGo
//
//  Created by Philip Tolton on 2014-07-28.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "DishCoinButton.h"
#import <FAKFontAwesome.h>

@implementation DishCoinButton
- (DishCoinButton *) init: (id) target {
    UIImage *b = [UIImage imageNamed:@"dishcoin@2x.png"];
    self.image_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,25,25)];
    self.image_view.image = b;
    self.image_view.contentMode = UIViewContentModeScaleAspectFit;
    self.button_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    self.image_view.center = self.button_view.center;
    [self.button_view addSubview:self.image_view];
    self.button_view.userInteractionEnabled = NO;
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,32,32)];
    [self.button addSubview:self.button_view];
    [self.button addTarget:target action:@selector(cartClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *pointaaa = self.button_view;
    self = [[DishCoinButton alloc] initWithCustomView:self.button];
    self.button_view = pointaaa;
    return self;
}
@end
