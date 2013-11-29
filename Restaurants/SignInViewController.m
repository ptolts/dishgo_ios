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

@interface SignInViewController ()

@end

@implementation SignInViewController

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
//    [self.signupHeader setFont:[UIFont fontWithName:@"Freestyle Script Bold" size:30.0f]];
    [self setupBackButton];
    
    UIImage *img = [UIImage imageNamed:@"background_signup.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView ];
    [self.view sendSubviewToBack:imageView ];
    
    self.bg.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    [self.bg.layer setCornerRadius:5.0f];
	// Do any additional setup after loading the view.
}

- (void) setupBackButton {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]; // <-- Use your own image
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
    [backBtn setImage:backBtnImage];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, backBtn, nil] animated:NO];
    //	self.navigationItem.leftBarButtonItem = backBtn;
    
    // FOOD CLOUD TITLE
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Freestyle Script Bold" size:30.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"Foodcloud";
    self.navigationItem.titleView = label;
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

- (IBAction)facebookSignIn:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Working...";
    
    [[UserSession sharedManager] openSession:^(bool obj, NSString *result) {
        if(obj){
            [hud hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [hud hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:result
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            self.password.text = @"";
        }
    }];

}

- (IBAction)foodcloudSignIn:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Working...";

    
    [[UserSession sharedManager] signIn:self.username.text password:self.password.text block:^(bool obj, NSString *result) {
        if(obj){
            [hud hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [hud hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Error"
                                      message:result
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
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
