//
//  RestaurantViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 2013-10-08.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import <KVOController/FBKVOController.h>

@interface RestaurantViewController : UITableViewController <CLLocationManagerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
    @property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
    @property (nonatomic, strong) IBOutlet UIButton *menu;
    - (void) segueToRestaurant: (Restaurant *) restaurant;
    @property UISearchDisplayController *search_bar;
    @property UISearchBar *bar;
    @property FBKVOController *KVOController;
@end
