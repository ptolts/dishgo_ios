//
//  ContactViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 1/3/2014.
//  Copyright (c) 2014 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Footer.h"

@interface ContactViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
    @property Restaurant *restaurant;
    @property Footer *footer;
@end
