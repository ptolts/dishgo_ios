//
//  RestaurantViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 2013-10-08.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"

@interface RestaurantViewController : UITableViewController <CLLocationManagerDelegate>
    @property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
    @property (nonatomic, strong) IBOutlet UIButton *menu;
@end
