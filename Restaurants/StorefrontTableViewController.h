//
//  StorefrontTableViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 10/29/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "StorefrontScrollView.h"
#import "StorefrontLabel.h"
#import <RestKit/RestKit.h>

@interface StorefrontTableViewController : UITableViewController <CLLocationManagerDelegate, MKMapViewDelegate>
    @property (nonatomic, strong) Restaurant *restaurant;
    @property (nonatomic, strong) RKManagedObjectStore *managedObjectStore;
    - (UIView *) headerView:(NSInteger)sectionIndex tableView:(UITableView *)tableView;
    - (UIView *) subheaderView:(NSInteger)sectionIndex tableView:(UITableView *)tableView;
@end
