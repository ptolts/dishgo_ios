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

    NSNumber *activeTextField;
    UITextField *sub_textfield;
    @synthesize nav_title;
    float originalScrollerOffsetY;

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
    if(nav_title == nil){
        label.text = @"Confirm Address";
    } else {
        label.text = nav_title;
    }
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
    [self.navigationController popViewControllerAnimated:YES];
    [self launchAlert:@"Address Confirmed!"];    
}

- (void)launchAlert:(NSString *)msg
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.navigationController.topViewController.view
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionTop
                                                        title:@"Success!"
                                                     subtitle:msg];
    
    
    banner.secondsToShow = 3.0f;
    
    [banner show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackButton];
    
    UIImage *img = [UIImage imageNamed:@"background_signup.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView ];
    [self.view sendSubviewToBack:imageView];
    
    self.scroll_view.backgroundColor = [UIColor bgColor];
    
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
    addy_view.controller = self;
    [addy_view.save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    
    ProfileView *prof_view = [[ProfileView alloc] init];
    prof_view.nav = self.navigationController;
    prof_view.frame = self.user_info.frame;
    [self.user_info removeFromSuperview];
    self.user_info = prof_view;
    [self.view addSubview:prof_view];
    self.user_info = prof_view;
    
//    [self.scroll_view setUserInteractionEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
//    [prof_view addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    [addy_view addObserver:self forKeyPath:@"current_textfield" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if ([keyPath isEqual:@"current_textfield"]) {
        sub_textfield = [change objectForKey:NSKeyValueChangeNewKey];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [sub_textfield resignFirstResponder];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scroll_view.contentInset = contentInsets;
    self.scroll_view.scrollIndicatorInsets = contentInsets;
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.scroll_view.frame;
    aRect.size.height -= keyboardSize.height;
    CGRect textFrame = [sub_textfield.superview convertRect:sub_textfield.frame toView:self.view];

//    NSLog(@"view minus keyboard: %@",CGRectCreateDictionaryRepresentation(aRect));
//    NSLog(@"text_view in parent: %@",CGRectCreateDictionaryRepresentation(textFrame));
    
    if (!CGRectContainsRect(aRect, textFrame)) {
//        NSLog(@"%@",CGPointCreateDictionaryRepresentation([sub_textfield.superview convertPoint:sub_textfield.frame.origin toView:self.view]));
        CGPoint scrollPoint = CGPointMake(0.0, [sub_textfield.superview convertPoint:sub_textfield.frame.origin toView:self.view].y - (keyboardSize.height-55));
//        NSLog(@"%@",CGPointCreateDictionaryRepresentation(scrollPoint));
        originalScrollerOffsetY = self.scroll_view.contentOffset.y;
        [self.scroll_view setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scroll_view.contentInset = contentInsets;
    self.scroll_view.scrollIndicatorInsets = contentInsets;
    [self.scroll_view setContentOffset:CGPointMake(0.0, originalScrollerOffsetY) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
