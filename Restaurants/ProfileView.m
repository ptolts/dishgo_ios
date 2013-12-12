//
//  ProfileView.m
//  Restaurants
//
//  Created by Philip Tolton on 12/9/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "ProfileView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <ALAlertBanner/ALAlertBanner.h>
#import "UserSession.h"

@implementation ProfileView

CLGeocoder *geocoder;
CLLocationManager *locationManager;
MBProgressHUD *hud;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
        [self.layer setCornerRadius:5.0f];
        
        if([[UserSession sharedManager] hasAddress]){
            User *u = [[UserSession sharedManager] fetchUser];
            self.phone_number.text = u.phone_number;
            //            self.street_number.text = u.street_number;
            //            self.street_address.text = u.street_address;
            //            self.city.text = u.city;
            //            self.postal_code.text = u.postal_code;
            //            self.province.text = u.province;
            //            self.apartment_number.text = u.apartment_number;
            self.first_name.text = u.first_name;
            self.last_name.text = u.last_name;
        }
    }
    return self;
}

//-(IBAction)load_current_location:(id)sender{
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//    
//    hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.labelText = @"Finding Location...";
//    [locationManager startUpdatingLocation];
//}

- (void)launchAlert:(NSString *)msg
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.nav.view
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionBottom
                                                        title:@"Success!"
                                                     subtitle:msg];
    
    banner.secondsToShow = 2.5f;
    
    [banner show];
}

- (void)launchAlertTop:(NSString *)msg
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.nav.view
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionTop
                                                        title:@"Be Aware!"
                                                     subtitle:msg];
    
    banner.secondsToShow = 10.0f;
    
    [banner show];
}

//-(IBAction)clear:(id)sender {
//    //    self.phone_number.text = u.phone_number;
//    self.street_number.text = nil;
//    self.street_address.text = nil;
//    self.city.text = nil;
//    self.postal_code.text = nil;
//    self.province.text = nil;
//    self.apartment_number.text = nil;
//}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    
//    geocoder = [[CLGeocoder alloc]init];
//    [geocoder reverseGeocodeLocation: locationManager.location completionHandler:
//     
//     //Getting Human readable Address from Lat long,,,
//     
//     ^(NSArray *placemarks, NSError *error) {
//         //Get nearby address
//         CLPlacemark *placemark = [placemarks objectAtIndex:0];
//         //String to hold address
//         //         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//         //Print the location to console
//         NSLog(@"Location Dict %@",placemark.addressDictionary);
//         self.street_address.text = [placemark.addressDictionary objectForKey:@"Thoroughfare"];
//         self.city.text = [placemark.addressDictionary objectForKey:@"City"];
//         self.postal_code.text = [placemark.addressDictionary objectForKey:@"ZIP"];
//         self.province.text = [placemark.addressDictionary objectForKey:@"State"];
//     }];
//    
//    [locationManager stopUpdatingLocation];
//    [hud hide:YES];
//    [self launchAlertTop:@"This is just our best attempt at your current location. Please go over the result and correct any errors. Thanks!"];
//    
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
    [self endEditing:YES];
}

-(IBAction)dissmissKeyboard:(id)sender{
    [sender resignFirstResponder];
}

- (void)launchDialog:(NSString *)msg
{
    // Here we need to pass a full frame
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 100)];
    // Add some custom content to the alert view
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 230, 100)];
    message.text = msg;
    message.numberOfLines = 0;
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
    [v addSubview:message];
    [alertView setContainerView:v];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Ok", nil]];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

-(void)clear {
    self.phone_number.text = @"";
    self.first_name.text = @"";
    self.last_name.text = @"";
}

- (BOOL) validate {

    if([self.phone_number.text length] < 10){
        [self launchDialog:@"Phone number appears invalid."];
        return NO;
    }
//
//    if([self.street_number.text length] == 0){
//        [self launchDialog:@"Street Number required.\nIf you don't have one, enter 0."];
//        return;
//    }
//
//    if([self.street_address.text length] == 0){
//        [self launchDialog:@"Street required."];
//        return;
//    }
//
//    if([self.city.text length] == 0){
//        [self launchDialog:@"City required."];
//        return;
//    }
//
//    if([self.postal_code.text length] == 0){
//        [self launchDialog:@"Postal Code required."];
//        return;
//    }
//
//    if([self.province.text length] == 0){
//        [self launchDialog:@"Province required."];
//        return;
//    }

    if([self.first_name.text length] == 0){
        [self launchDialog:@"First name required."];
        return NO;
    }

    if([self.last_name.text length] == 0){
        [self launchDialog:@"Last name required."];
        return NO;
    }
    
    return YES;

//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//    hud.labelText = @"Saving...";
//
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//
//    [dict setObject:self.phone_number.text forKey:@"phone_number"];
//    [dict setObject:self.street_number.text forKey:@"street_number"];
//    [dict setObject:self.street_address.text forKey:@"street_address"];
//    [dict setObject:self.city.text forKey:@"city"];
//    [dict setObject:self.postal_code.text forKey:@"postal_code"];
//    [dict setObject:self.province.text forKey:@"province"];
//    [dict setObject:self.last_name.text forKey:@"last_name"];
//    [dict setObject:self.first_name.text forKey:@"first_name"];
//    if(self.apartment_number.text == nil){
//        [dict setObject:@"" forKey:@"apartment_number"];
//    } else {
//        [dict setObject:self.apartment_number.text forKey:@"apartment_number"];
//    }
//
//
//    [[UserSession sharedManager] setAddress:dict block:^(bool obj, NSString *error) {
//        if(obj){
//            [hud hide:YES];
//            [self launchAlert:@"Profile Updated."];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        } else {
//            [hud hide:YES];
//            [self launchDialog:error];
//        }
//    }];
}

@end