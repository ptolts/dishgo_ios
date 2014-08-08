//
//  ProfileViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 12/4/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "ProfileViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "UserSession.h"
#import <ALAlertBanner/ALAlertBanner.h>
#import "AddressView.h"
#import "ProfileView.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController
//    CLGeocoder *geocoder;
//    CLLocationManager *locationManager;
    MBProgressHUD *hud;
    float originalScrollerOffsetY;
    NSNumber *activeTextField;
    UITextField *sub_textfield;
    BOOL setup_equal;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(IBAction)load_current_location:(id)sender{
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//    
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.labelText = @"Finding Location...";
//    [locationManager startUpdatingLocation];
//}

- (void)launchAlert:(NSString *)msg
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.navigationController.view
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionBottom
                                                        title:@"Success!"
                                                     subtitle:msg];
    
    banner.secondsToShow = 2.5f;
    
    [banner show];
}

- (void)launchAlertTop:(NSString *)msg
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionTop
                                                        title:@"Be Aware!"
                                                     subtitle:msg];
    
    banner.secondsToShow = 10.0f;
    
    [banner show];
}



- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if ([keyPath isEqual:@"current_textfield"]) {
        sub_textfield = [change objectForKey:NSKeyValueChangeNewKey];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"End Editing!!");
    [self.scroll_view endEditing:YES];
    [sub_textfield resignFirstResponder];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scroll_view.contentInset = contentInsets;
    self.scroll_view.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.scroll_view.frame;
    aRect.size.height -= keyboardSize.height;
    CGRect textFrame = [sub_textfield.superview convertRect:sub_textfield.frame toView:self.scroll_view];
//    NSLog(@"View Frame: %@\nScrollview Frame: %@\nSubfieldview Frame: %@\n",CGRectCreateDictionaryRepresentation(self.view.frame),CGRectCreateDictionaryRepresentation(self.scroll_view.frame),CGRectCreateDictionaryRepresentation(textFrame));
    if (!CGRectContainsRect(aRect, textFrame)) {
        CGPoint scrollPoint = CGPointMake(0.0, [sub_textfield.superview convertPoint:sub_textfield.frame.origin toView:self.scroll_view].y - (keyboardSize.height-55));
        originalScrollerOffsetY = self.scroll_view.contentOffset.y;
        [self.scroll_view setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scroll_view.contentInset = contentInsets;
    self.scroll_view.scrollIndicatorInsets = contentInsets;
    [self.scroll_view setContentOffset:CGPointMake(0.0, originalScrollerOffsetY) animated:YES];
    sub_textfield = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self.signupHeader setFont:[UIFont fontWithName:@"Copperplate-Bold" size:20.0f]];
    [self setupBackButton];
    
    UIImage *img = [UIImage imageNamed:@"background_signup.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView ];
    [self.view sendSubviewToBack:imageView ];
    
    
    // This is just hideous, but at least we can reuse views.
    AddressView *addy_view = [[AddressView alloc] init];
    addy_view.nav = self.navigationController;
    addy_view.frame = self.address_view.frame;
    [self.address_view removeFromSuperview];
    self.address_view = addy_view;
    [self.scroll_view addSubview:addy_view];
    self.address_view = addy_view;
    addy_view.controller = self;
    [addy_view.save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    
    ProfileView *prof_view = [[ProfileView alloc] init];
    prof_view.nav = self.navigationController;
    prof_view.frame = self.profile_view.frame;
    [self.profile_view removeFromSuperview];
    self.profile_view = prof_view;
    [self.scroll_view addSubview:prof_view];
    self.profile_view = prof_view;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [addy_view addObserver:self forKeyPath:@"current_textfield" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.address_view.hidden = YES;
    
}

-(IBAction)clear:(id)sender {
//    self.phone_number.text = u.phone_number;
//    self.street_number.text = nil;
//    self.street_address.text = nil;
//    self.city.text = nil;
//    self.postal_code.text = nil;
//    self.province.text = nil;
//    self.apartment_number.text = nil;
    [self.address_view clear];
    [self.profile_view clear];
}

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
////         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
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

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    for (UIView * txt in self.address_view.subviews){
//        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
//            [txt resignFirstResponder];
//        }
//    }
//    
//    for (UIView * txt in self.profile_view.subviews){
//        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
//            [txt resignFirstResponder];
//        }
//    }
//    
//    [self.view endEditing:YES];
//}

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

-(void) myCustomBack {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) setupBackButton {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]; // <-- Use your own image
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
    [backBtn setImage:backBtnImage];
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
    //                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    //                                       target:nil action:nil];
    //    negativeSpacer.width = -16;// it was -6 in iOS 6
    //    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, backBtn, nil] animated:NO];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    // FOOD CLOUD TITLE
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Copperplate-Bold" size:20.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"Profile";
    self.navigationItem.titleView = label;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    int length = [self getLength:textField.text];
//    //NSLog(@"Length  =  %d ",length);
//    
//    if(length == 10)
//    {
//        if(range.length == 0)
//            return NO;
//    }
//    
//    if(length == 3)
//    {
//        NSString *num = [self formatNumber:textField.text];
//        textField.text = [NSString stringWithFormat:@"(%@) ",num];
//        if(range.length > 0)
//            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
//    }
//    else if(length == 6)
//    {
//        NSString *num = [self formatNumber:textField.text];
//        //NSLog(@"%@",[num  substringToIndex:3]);
//        //NSLog(@"%@",[num substringFromIndex:3]);
//        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
//        if(range.length > 0)
//            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
//    }
//    
//    return YES;
//}

//-(NSString*)formatNumber:(NSString*)mobileNumber
//{
//    
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
//    
//    NSLog(@"%@", mobileNumber);
//    
//    int length = [mobileNumber length];
//    if(length > 10)
//    {
//        mobileNumber = [mobileNumber substringFromIndex: length-10];
//        NSLog(@"%@", mobileNumber);
//        
//    }
//    
//    
//    return mobileNumber;
//}
//
//
//-(int)getLength:(NSString*)mobileNumber
//{
//    
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
//    
//    int length = [mobileNumber length];
//    
//    return length;
//    
//    
//}

- (IBAction)save:(UIButton *)sender {
    
//    if([self.phone_number.text length] < 10){
//        [self launchDialog:@"Phone number appears invalid."];
//        return;
//    }
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
//    
//    if([self.first_name.text length] == 0){
//        [self launchDialog:@"First name required."];
//        return;
//    }
//    
//    if([self.last_name.text length] == 0){
//        [self launchDialog:@"Last name required."];
//        return;
//    }
    
    
    if(!([self.address_view validate] && [self.profile_view validate])){
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Saving...";
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:self.profile_view.phone_number.text forKey:@"phone_number"];
    [dict setObject:self.address_view.street_number.text forKey:@"street_number"];
    [dict setObject:self.address_view.street_address.text forKey:@"street_address"];
    [dict setObject:self.address_view.city.text forKey:@"city"];
    [dict setObject:self.address_view.postal_code.text forKey:@"postal_code"];
    [dict setObject:self.address_view.province.text forKey:@"province"];
    [dict setObject:self.profile_view.last_name.text forKey:@"last_name"];
    [dict setObject:self.profile_view.first_name.text forKey:@"first_name"];
    if(self.address_view.apartment_number.text == nil){
        [dict setObject:@"" forKey:@"apartment_number"];
    } else {
        [dict setObject:self.address_view.apartment_number.text forKey:@"apartment_number"];
    }

    
    [[UserSession sharedManager] setAddress:dict block:^(bool obj, NSString *error) {
        if(obj){
            [hud hide:YES];
            [self launchAlert:@"Profile Updated."];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [hud hide:YES];
            [self launchDialog:error];
        }
    }];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupNextButton];
}

- (void) setupNextButton {
    if(!setup_equal){
        [self equalSpace];
        setup_equal = YES;
    }
}

- (void) equalSpace {
    
    int available = self.scroll_view.frame.size.height;
    
    int subcount = [[self.scroll_view subviews] count];
    for(UIView *v in [self.scroll_view subviews]){
        available -= v.frame.size.height;
    }
    
    NSComparator comparatorBlock = ^(UIView *obj1, UIView *obj2) {
        if (obj1.frame.origin.y > obj2.frame.origin.y) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (obj1.frame.origin.y < obj2.frame.origin.y) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    int new_offset = 0;
    int add_offset = (int)(available / subcount);
    
    NSLog(@"Add_offset: %d",add_offset);
    
    for(UIView *v in [[self.scroll_view subviews] sortedArrayUsingComparator:comparatorBlock]){
        new_offset += add_offset;
        CGRect frame = v.frame;
        frame.origin.y += new_offset;
        v.frame = frame;
    }
}

@end
