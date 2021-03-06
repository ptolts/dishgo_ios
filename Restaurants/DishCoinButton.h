//
//  DishCoinButton.h
//  DishGo
//
//  Created by Philip Tolton on 2014-07-28.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishCoinButton : UIBarButtonItem
    - (DishCoinButton *) init: (id) target;
    @property UIImageView *image_view;
    @property UIButton *button;
    @property UIView *button_view;
@end
