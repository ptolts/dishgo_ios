//
//  CHDraggableView+OrderTracker.h
//  Restaurants
//
//  Created by Philip Tolton on 12/30/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

//#import "CHDraggableView.h"
#import "CHDraggableView+Avatar.h"

@interface CHDraggableView (OrderTracker)
    @property (strong, nonatomic) NSString *order_id;
    -(void) timer:(NSNumber *)number;
@end
