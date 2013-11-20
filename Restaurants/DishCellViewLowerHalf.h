//
//  DishCellViewLowerHalf.h
//  Restaurants
//
//  Created by Philip Tolton on 11/19/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishCellViewLowerHalf : UITableViewCell
    @property (weak, nonatomic) IBOutlet UILabel *dishDescription;
    @property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
    @property (weak, nonatomic) IBOutlet UILabel *optionLabel;
    @property float full_height;
    @property (nonatomic, strong) Dishes *dish;
@end
