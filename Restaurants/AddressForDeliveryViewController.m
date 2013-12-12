//
//  AddressForDeliveryViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 12/11/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "AddressForDeliveryViewController.h"
#import <ALAlertBanner/ALAlertBanner.h>

@interface AddressForDeliveryViewController ()

@end

@implementation AddressForDeliveryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    label.text = @"Confirm Address";
    self.navigationItem.titleView = label;
}

- (IBAction)save:(UIButton *)sender {
    
    if(!([self.user_address validate] && [self.user_info validate])){
        return;
    }
    
    _main_user.phone_number = self.user_info.phone_number.text;
    _main_user.street_number = self.user_address.street_number.text;
    _main_user.street_address = self.user_address.street_address.text;
    _main_user.city = self.user_address.city.text;
    _main_user.postal_code = self.user_address.postal_code.text;
    _main_user.province = self.user_address.province.text;
    _main_user.last_name = self.user_info.last_name.text;
    _main_user.first_name = self.user_info.first_name.text;
    
    _bill_user.phone_number = self.user_info.phone_number.text;
    _bill_user.street_number = self.user_address.street_number.text;
    _bill_user.street_address = self.user_address.street_address.text;
    _bill_user.city = self.user_address.city.text;
    _bill_user.postal_code = self.user_address.postal_code.text;
    _bill_user.province = self.user_address.province.text;
    _bill_user.last_name = self.user_info.last_name.text;
    _bill_user.first_name = self.user_info.first_name.text;
    
    if(self.user_address.apartment_number.text == nil){
        _main_user.apartment_number = @"";
        _bill_user.apartment_number = @"";
    } else {
        _main_user.apartment_number = self.user_address.apartment_number.text;
        _bill_user.apartment_number = self.user_address.apartment_number.text;
    }
    
    _main_user.confirm_address = YES;
    [self launchAlert:@"Address Confirmed!"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)launchAlert:(NSString *)msg
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.navigationController.view
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionBottom
                                                        title:@"Success!"
                                                     subtitle:msg];
    
    
    banner.secondsToShow = 30.0f;
    
    //    banner.layer.shadowColor = [UIColor clearColor].CGColor;
    //    banner.layer.borderColor = [UIColor clearColor].CGColor;
    //    banner.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:181.0/255.0 blue:241.0/255.0 alpha:0.95];
    
    for(UIView *v in [banner subviews]){
        NSLog(@"%@",v.class);
        NSLog(@"%@",CGRectCreateDictionaryRepresentation(v.frame));
        if([v isKindOfClass:[UILabel class]]){
            CGRect frame = v.frame;
            frame.size.width = 320;
            frame.origin.x = 0;
            v.frame = frame;
            ((UILabel *)v).textAlignment = NSTextAlignmentCenter;
        }
        
        if([v isKindOfClass:[UIImageView class]]){
            ((UIImageView *)v).contentMode = UIViewContentModeCenter;
            ((UIImageView *)v).image = [UIImage imageNamed:@"info.png"];
        }
    }
    
    [banner show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackButton];
    // This is just hideous, but at least we can reuse views.
    AddressView *addy_view = [[AddressView alloc] init];
    addy_view.nav = self.navigationController;
    addy_view.frame = self.user_address.frame;
    [self.user_address removeFromSuperview];
    self.user_address = addy_view;
    [addy_view.save setTitle:@"Confirm" forState:UIControlStateNormal];
    [addy_view.save.titleLabel sizeToFit];
    [self.view addSubview:addy_view];
    self.user_address = addy_view;
    [addy_view.save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    
    ProfileView *prof_view = [[ProfileView alloc] init];
    prof_view.nav = self.navigationController;
    prof_view.frame = self.user_info.frame;
    [self.user_info removeFromSuperview];
    self.user_info = prof_view;
    [self.view addSubview:prof_view];
    self.user_info = prof_view;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
