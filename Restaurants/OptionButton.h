//
//  OptionButton.h
//  DishGo
//
//  Created by Philip Tolton on 2014-05-30.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Option.h"

@interface OptionButton : UIButton
    @property Option *option;
    @property float price;
    -(void) updatePrice: (NSString *)size_id;
@end
