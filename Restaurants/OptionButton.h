//
//  OptionButton.h
//  DishGo
//
//  Created by Philip Tolton on 2014-05-30.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Option.h"
#import <BFPaperButton/BFPaperButton.h>

@interface OptionButton : BFPaperButton
    @property Option *option;
    @property float price;
    -(void) updatePrice: (NSString *)size_id;
    - (void) setup;
@end
