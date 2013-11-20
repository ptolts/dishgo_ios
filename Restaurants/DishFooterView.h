//
//  DishFooterView.h
//  Restaurants
//
//  Created by Philip Tolton on 11/19/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishFooterView : UIView
    @property (weak, nonatomic) IBOutlet UIButton *add;
    @property (weak, nonatomic) IBOutlet UILabel *quantity;
    @property (weak, nonatomic) IBOutlet UIStepper *stepper;
    - (IBAction)stepperValueChanged:(id)sender;
@end
