//
//  RootViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 10/28/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "REFrostedViewController.h"
#import "CHDraggingCoordinator.h"

@interface RootViewController : REFrostedViewController <CHDraggingCoordinatorDelegate>
    -(void) showOldOrders;
    @property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
    @property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator;
    - (void) trackOrder:(NSString *)order_id;
@end
