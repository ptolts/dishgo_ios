//
//  PrizesController.m
//  DishGo
//
//  Created by Philip Tolton on 2014-07-29.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "PrizesController.h"
#import "Constant.h"
#import "UserSession.h"
#import <FAKFontAwesome.h>

@interface PrizesController ()

@end

@implementation PrizesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) myCustomBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor almostBlackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    FAKFontAwesome *back = [FAKFontAwesome timesCircleIconWithSize:22.0f];
    [back addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *image = [back imageWithSize:CGSizeMake(45.0,45.0)];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(myCustomBack) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setRightBarButtonItem:item];
    User *user = [[UserSession sharedManager] fetchUser];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL
                                                          URLWithString:[NSString stringWithFormat:@"%@/app/prizes/list?token=%@",dishGoUrl,user.foodcloud_token]]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    [self.webview loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
