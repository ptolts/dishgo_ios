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


@interface ProfileViewController ()

@end

@implementation ProfileViewController
    CLGeocoder *geocoder;
    CLLocationManager *locationManager;
    MBProgressHUD *hud;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)load_current_location:(id)sender{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Finding Location...";
    [locationManager startUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self.signupHeader setFont:[UIFont fontWithName:@"Freestyle Script Bold" size:30.0f]];
    [self setupBackButton];
    
    UIImage *img = [UIImage imageNamed:@"background_signup.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView ];
    [self.view sendSubviewToBack:imageView ];
    
    self.bg.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    [self.bg.layer setCornerRadius:5.0f];
    
    self.bg2.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    [self.bg2.layer setCornerRadius:5.0f];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation: locationManager.location completionHandler:
     
     //Getting Human readable Address from Lat long,,,
     
     ^(NSArray *placemarks, NSError *error) {
         //Get nearby address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         //String to hold address
//         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         //Print the location to console
         NSLog(@"Location Dict %@",placemark.addressDictionary);
         self.street_address.text = [placemark.addressDictionary objectForKey:@"Thoroughfare"];
         self.city.text = [placemark.addressDictionary objectForKey:@"City"];
         self.postal_code.text = [placemark.addressDictionary objectForKey:@"ZIP"];
         self.province.text = [placemark.addressDictionary objectForKey:@"State"];
     }];
 
    [locationManager stopUpdatingLocation];
    [hud hide:YES];
    [self launchDialog:@"This is just our best attempt at your current location. Please go over the result and correct any errors. Thanks!"];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.bg.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
    [self.view endEditing:YES];
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
    [label setFont:[UIFont fontWithName:@"Freestyle Script Bold" size:30.0f]];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int length = [self getLength:textField.text];
    //NSLog(@"Length  =  %d ",length);
    
    if(length == 10)
    {
        if(range.length == 0)
            return NO;
    }
    
    if(length == 3)
    {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
        NSString *num = [self formatNumber:textField.text];
        //NSLog(@"%@",[num  substringToIndex:3]);
        //NSLog(@"%@",[num substringFromIndex:3]);
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    
    return length;
    
    
}

@end
