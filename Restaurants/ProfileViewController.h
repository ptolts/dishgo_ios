//
//  ProfileViewController.h
//  Restaurants
//
//  Created by Philip Tolton on 12/4/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ProfileViewController : UIViewController <CLLocationManagerDelegate>
    @property IBOutlet UIView *bg;
@end
