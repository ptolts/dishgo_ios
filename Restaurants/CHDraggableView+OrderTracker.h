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
    -(void) timer:(NSNumber *)number order_id:(NSString *)order_id;
@end
