//
//  DishCellClean.h
//  DishGo
//
//  Created by Philip Tolton on 2014-06-23.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sections.h"

@interface DishCellClean : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *dish_count;
@property (strong, nonatomic) IBOutlet UILabel *price_range;
@property (strong, nonatomic) IBOutlet UILabel *dishes_count_label;
@property (strong, nonatomic) IBOutlet UILabel *range_label;
@property (strong, nonatomic) IBOutlet UILabel *rating_label;
@property (strong, nonatomic) IBOutlet UILabel *rating;
@property (strong, nonatomic) IBOutlet UIView *separator;
@property Sections *section;
- (void) setup;
@end
