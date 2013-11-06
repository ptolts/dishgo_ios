//
//  DishViewCell.h
//  Restaurants
//
//  Created by Philip Tolton on 10/31/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishViewCell : UITableViewCell
    @property (nonatomic, strong) IBOutlet UILabel *dishTitle;
    @property (nonatomic, strong) IBOutlet UILabel *dishDescription;
@end
