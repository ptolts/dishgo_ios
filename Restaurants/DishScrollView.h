//
//  DishScrollView.h
//  Restaurants
//
//  Created by Philip Tolton on 11/7/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishScrollView : UIScrollView
    @property (nonatomic, strong) Sections *section;
    -(void)setupViews;
    -(int) currentPage;
@end
