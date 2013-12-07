//
//  CartButton.h
//  Restaurants
//
//  Created by Philip Tolton on 11/21/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartButton : UIView
    @property (strong, nonatomic) IBOutlet UIView *background;
    @property (strong, atomic) IBOutlet UILabel *cart_count;
    @property (strong, atomic) UIButton *button;
    - (void) setCount:(NSString *)newText;
@end
