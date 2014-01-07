//
//  Footer.h
//  Restaurants
//
//  Created by Philip Tolton on 10/29/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TableHeaderView.h"

@interface Footer : UIView
    @property (strong, nonatomic) IBOutlet UIView *contact_title_background;
    @property (nonatomic, strong) IBOutlet MKMapView *mapView;
    @property (nonatomic, strong) IBOutlet UILabel *phone;
    @property (nonatomic, strong) IBOutlet UILabel *address;
    @property (nonatomic, strong) IBOutlet UILabel *contact_title;
@end
