//
//  SignInViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 11/22/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "SignInViewController.h"
#import "UserSession.h"
#import "SignUpViewController.h"
#import "REFrostedViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <ALAlertBanner/ALAlertBanner.h>

@interface SignInViewController ()

@end


@implementation SignInViewController

    MBProgressHUD *hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [self.view sendSubviewToBack:imageView];
    
    self.bg.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    [self.bg.layer setCornerRadius:5.0f];
    
    self.bg2.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    [self.bg2.layer setCornerRadius:5.0f];
	// Do any additional setup after loading the view.
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
    label.text = @"Sign In";
    self.navigationItem.titleView = label;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor scarletColor];
}

-(void) myCustomBack {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.bg.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

-(IBAction)dissmissKeyboard:(id)sender{
    [sender resignFirstResponder];
}

- (void)launchDialog:(NSString *)msg
{
    // Here we need to pass a full frame
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
    message.text = msg;
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0f];
    [alertView setContainerView:message];
    
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

- (void)launchAlert:(NSString *)msg
{
    return;
    
    NSArray *controllers = self.navigationController.viewControllers;
    UIViewController *cont = controllers[([controllers count]-1)];
    UIView *v = cont.view;
    
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:v
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionTop
                                                        title:@"Success!"
                                                     subtitle:msg];

    
    banner.secondsToShow = 30.0f;
    
    [banner show];
}


- (IBAction)facebookSignIn:(id)sender {
    
    for (UIView * txt in self.bg.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Working...";
    
    [[UserSession sharedManager] openSession:^(bool obj, NSString *result) {
        if(obj){
            [hud hide:YES];
            [self launchAlert:@"Logged in!"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [hud hide:YES];
            [self launchDialog:result];
            self.password.text = @"";
        }
    }];

}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)foodcloudSignIn:(id)sender {
    
    for (UIView * txt in self.bg.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
    
    if(![self NSStringIsValidEmail:self.username.text]){
        [self launchDialog:@"Invalid Email Address."];
        return;
    }
    
    if([self.password.text length] < 8){
        [self launchDialog:@"Password must be at least 8 characters."];
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Working...";
    
    [[UserSession sharedManager] signIn:self.username.text password:self.password.text block:^(bool obj, NSString *result) {
        if(obj){
            [hud hide:YES];
            [self launchAlert:@"Logged in!"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [hud hide:YES];
            [self launchDialog:@"Bad Username or Password."];
            self.password.text = @"";
        }
    }];
    
}

- (IBAction)foodcloudSignUp:(id)sender {
    SignUpViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signupViewController"];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    [navigationController pushViewController:vc animated:YES];
}

@end
