//
//  PinsView.h
//  Restaurants
//
//  Created by Philip Tolton on 1/7/2014.
//  Copyright (c) 2014 Philip Tolton. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PinsView : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
}
    -(id)initWithCoordinate:(CLLocationCoordinate2D) c;
    -(void) setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
