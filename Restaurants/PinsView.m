//
//  PinsView.m
//  Restaurants
//
//  Created by Philip Tolton on 1/7/2014.
//  Copyright (c) 2014 Philip Tolton. All rights reserved.
//

#import "PinsView.h"

@implementation PinsView
    @synthesize coordinate;

    - (NSString *)subtitle{
        return nil;
    }

    - (NSString *)title{
        return nil;
    }

    -(void) setCoordinate:(CLLocationCoordinate2D)newCoordinate {
        coordinate = newCoordinate;
    }

    -(id)initWithCoordinate:(CLLocationCoordinate2D) c{
        coordinate = c;
        return self;
    }
@end
