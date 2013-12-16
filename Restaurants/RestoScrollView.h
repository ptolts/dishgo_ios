//
//  RestoScrollView.h
//  Restaurants
//
//  Created by Philip Tolton on 10/25/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestoScrollView : UIScrollView
    @property int numberOfPages;
    - (void) scrollPages;
    - (void) killScroll;
    @property int currentPage;
@end
