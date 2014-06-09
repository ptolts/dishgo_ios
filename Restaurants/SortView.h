//
//  SortView.h
//  DishGo
//
//  Created by Philip Tolton on 2014-06-09.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortView : UIView
    -(void) setupView: (NSString *)title type: (int) option_type value: (int) value;
    @property int value;
    @property int option_type;
    @property BOOL selected;
    -(void) setSelectedWithoutKvo;
@end
