//
//  CameraButton.h
//  DishGo
//
//  Created by Philip Tolton on 2014-05-21.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dishes.h"

@class SectionDishViewCell;

@interface CameraButton : UIButton
    @property Dishes *dish;
    @property SectionDishViewCell *parent_cell;
@end
