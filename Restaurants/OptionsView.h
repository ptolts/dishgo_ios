//
//  OptionsView.h
//  Restaurants
//
//  Created by Philip Tolton on 11/14/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Options.h"
#import "DishTableViewCell.h"
#import "Option_Order.h"

@interface OptionsView : UIView
    @property (strong, nonatomic) IBOutlet UILabel *optionTitle;
    @property (weak, nonatomic) Options *op;
    @property (weak, nonatomic) DishTableViewCell *parent;
    @property NSMutableArray<Option_Order> *option_order_json;
    -(void) setupOption;
    -(float) getPrice;
    @property int full_height;
@end
