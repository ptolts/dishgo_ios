//
//  OptionsView.h
//  Restaurants
//
//  Created by Philip Tolton on 11/14/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Options.h"

@interface OptionsView : UIView
    @property (weak, nonatomic) IBOutlet UILabel *optionTitle;
    @property (weak, nonatomic) Options *op;
    -(void) setupOption;
    -(float) getPrice;
    @property int full_height;
@end
