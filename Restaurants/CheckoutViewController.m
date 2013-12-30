//
//  CheckoutTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 12/9/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "CheckoutViewController.h"
#import "UIColor+Custom.h"
#import "UserSession.h"
#import "CheckoutCell.h"
#import "AddressForDeliveryViewController.h"
#import "SignInViewController.h"
#import "PaymentViewController.h"
#import "ReviewViewController.h"
#import "Order_Order.h"
#import <JSONModel/JSONHTTPClient.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <ALAlertBanner/ALAlertBanner.h>
#import <REFrostedViewController/REFrostedViewController.h>
#import "RootViewController.h"

#define CELL_SIZE 34

@interface CheckoutViewController ()

@end

@implementation CheckoutViewController

NSMutableDictionary *progress;
NSDictionary *titles;
NSArray *keys;
User *user_for_order;
User *user_for_billing;
bool speed_things_up;
@synthesize next_view;

- (void) setupBackButtonAndCart {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"cancel.png"]; // <-- Use your own image
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
    [backBtn setImage:backBtnImage];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    
    // FOOD CLOUD TITLE
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Freestyle Script Bold" size:30.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"Checkout";
    self.navigationItem.titleView = label;
}

-(void) myCustomBack {
//    if([progress[@"login"] isEqual: @0] || [progress[@"address"] isEqual: @0]){
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
//    
//    NSString *last_key;
//    
//    for(id key in keys){
//        
//        if([[progress objectForKey:key]  isEqual: @1]){
//            last_key = key;
//        }
//
//        if([[progress objectForKey:key]  isEqual: @0] && ![last_key isEqualToString:@""]){
//            NSLog(@"%@",[NSString stringWithFormat:@"%@Reverse",last_key]);
//            [self.tableView reloadData];
//            [progress setValue:@0  forKey:last_key];
//            [self performSelector:(NSSelectorFromString([NSString stringWithFormat:@"%@Reverse",last_key]))];
//            [self next];
//            return;
//        }
//
//    }
//    
//    
//    [progress setValue:@0  forKey:@"review"];
//    [self next];
//    return;
    
    [self.navigationController popViewControllerAnimated:YES];
    return;
    
}

-(void) viewWillAppear:(BOOL)animated {
    // Check Logged In
    if([[UserSession sharedManager] logged_in]){
        [progress setValue:@1  forKey:@"login"];
    } else {
        [progress setValue:@0  forKey:@"login"];
    }
    
    //Check Address Confirmation
    if(user_for_order.confirm_address) {
        [progress setValue:@1  forKey:@"address"];
    }
    
    //Check Address Confirmation
    if(user_for_order.validCreditCard) {
        [progress setValue:@1  forKey:@"payment"];
    }
    
    //Check Address Confirmation
    if(user_for_order.review_confirm) {
        [progress setValue:@1  forKey:@"review"];
        self.next_but_label.text = @"Place Order!";
        [self.next_but_label setNeedsLayout];
    }
    
//    if(speed_things_up){
//        [self next];
//    }
}

-(void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackButtonAndCart];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    speed_things_up = NO;
    
    user_for_order = [[User alloc] init];
    user_for_order.confirm_address = NO;
    user_for_order.foodcloud_token = [[UserSession sharedManager] fetchUser].foodcloud_token;
    
    user_for_billing = [[User alloc] init];
    user_for_billing.confirm_billing = NO;
    
    keys = @[@"login",@"address",@"payment",@"review",@"order"];
    
    progress = [[NSMutableDictionary alloc] init];
    titles = [[NSDictionary alloc] initWithObjectsAndKeys:@"Login",@"login",@"Delivery Address",@"address",@"Payment Details",@"payment",@"Review Order",@"review",@"Place Order",@"order",nil];
    
    self.tableView.backgroundColor = [UIColor bgColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor bgColor];
    
    for(NSString *val in keys){
        [progress setValue:@0  forKey:val];
    }
    
    if([[UserSession sharedManager] logged_in]){
        [progress setValue:@1  forKey:@"login"];
    } else {
        [progress setValue:@0  forKey:@"login"];
    }
    
    self.tableView.tableHeaderView = [self setupHeader];
    self.tableView.tableFooterView = [self setupFooter];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [keys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckoutCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CheckoutCell" owner:self options:nil] objectAtIndex:0];
    
    //    if (indexPath.row == 0 && indexPath.section == 1){
    //        [cell.seperator removeFromSuperview];
    //    }
    NSString *key = [keys objectAtIndex:indexPath.row];
    cell.label.text = [titles objectForKey:key];
    cell.label.textColor = [UIColor textColor];
    cell.label.font = [UIFont fontWithName:@"DamascusBold" size:14.0f];
    cell.backgroundColor = [UIColor bgColor];
    
    //    NSLog(@"%@",[[progress objectForKey:key] class]);
    
    
    if([[progress objectForKey:key]  isEqual: @1]){
        cell.checkmark.image = [UIImage imageNamed:@"checkmark.png"];
    } else {
        cell.checkmark.image = nil;
    }
    
    for (UIImageView *txt in cell.contentView.subviews){
        if ([txt isKindOfClass:[UIImageView class]]) {
            txt.layer.cornerRadius = txt.frame.size.height / 2.0;
            txt.layer.borderColor = [UIColor textColor].CGColor;
            txt.backgroundColor = [UIColor textColor];
            txt.layer.borderWidth = 1.5f;
        }
    }
    
    return cell;
}


-(void) loginReverse {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) addressReverse {
    user_for_order.confirm_address = NO;
}

- (void) reviewReverse {
    user_for_order.review_confirm = NO;
}


- (void) paymentReverse {
    user_for_order.validCreditCard = NO;
}


-(void) login {
    SignInViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) address {
    AddressForDeliveryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addressViewController"];
    vc.main_user = user_for_order;
    vc.bill_user = user_for_billing;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) review {
    ReviewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"reviewViewController"];
    vc.shopping_cart = self.shoppingCart;
    vc.main_user = user_for_order;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) payment {
    PaymentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"];
    vc.main_user = user_for_order;
    vc.bill_user = user_for_billing;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) place_order {
    user_for_order.billing_user = user_for_billing;
    user_for_order.shopping_cart = self.shoppingCart;
    Order_Order *json_order = [[Order_Order alloc] init];
    [json_order setupJsonWithUser:user_for_order];
    
    NSString *json = [json_order toJSONString];
    
    NSLog(@"token %@",user_for_order.foodcloud_token);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Placing Order...";
    
    //make post, get requests
    [JSONHTTPClient postJSONFromURLWithString:@"http://dev.foodcloud.ca:3000/api/v1/order/submit_order"
                                       params:@{@"order":json,@"foodcloud_token":user_for_order.foodcloud_token}
                                   completion:^(id json, JSONModelError *err) {
                                       NSLog(@"RESPONSE: %@",json);
                                       Order_Order *response = [[Order_Order alloc] initWithString:json error:nil];
                                       [hud hide:YES];
                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                       [((RootViewController *)self.frostedViewController) trackOrder:response.order_id];
                                       [self launchAlert:@"Order Submitted!"];
                                   }];
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

- (void) next {
    
    // Check Logged In
    if([[UserSession sharedManager] logged_in]){
        [progress setValue:@1  forKey:@"login"];
    } else {
        [progress setValue:@0  forKey:@"login"];
    }
    
    //Check Address Confirmation
    if(user_for_order.confirm_address) {
        [progress setValue:@1  forKey:@"address"];
    }
    
    //Check Address Confirmation
    if(user_for_order.validCreditCard) {
        [progress setValue:@1  forKey:@"payment"];
    }
    
    //Check Address Confirmation
    if(user_for_order.review_confirm) {
        [progress setValue:@1  forKey:@"review"];
        self.next_but_label.text = @"Place Order!";
        [self.next_but_label setNeedsLayout];
    }
    
    NSLog(@"next!");
    
    speed_things_up = YES;
    for(id key in keys){
        if([[progress objectForKey:key]  isEqual: @0]){
            NSLog(@"key: %@",key);
            if([key isEqualToString:@"login"]){
                [self login];
                return;
            } else if ([key isEqualToString:@"address"]){
                [self address];
                return;
            } else if ([key isEqualToString:@"payment"]){
                [self payment];
                speed_things_up = NO;
                return;
            } else if ([key isEqualToString:@"review"]){
                [self review];
                return;
            } else {
                [self place_order];
                return;
            }
        }
    }
    NSLog(@"Finished!");
}

- (UIView *) setupFooter {
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    
    //    UILabel *next_but = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 38)];
    //    next_but.text = @"Next";
    //    [next_but setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    //    next_but.textColor = [UIColor bgColor];
    //    next_but.textAlignment = NSTextAlignmentCenter;
    //    [next_but setUserInteractionEnabled:NO];
    //
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //
    //    [btn setFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, 38)];
    //    btn.backgroundColor = [UIColor nextColor];
    //    btn.layer.cornerRadius = 3.0f;
    ////    btn.layer.borderColor = [UIColor blackColor].CGColor;
    ////    btn.layer.borderWidth = 1.0f;
    //    self.next_but = btn;
    //    [btn addSubview:next_but];
    //
    //    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [footer addSubview:btn];
    
    //    footer.layer.borderColor = [UIColor blackColor].CGColor;
    //    footer.layer.borderWidth = 1.0f;
    
    return footer;
    
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupNextButton];
}

- (void) setupNextButton {
    if([[next_view subviews] count] == 0){
        next_view.backgroundColor = [UIColor clearColor];
        NSLog(@"Adding Next");
        int total_height = self.view.frame.size.height;
        int view_height = 60;
        int button_height = 38;
        int view_position = total_height - view_height;
        
        CGRect frame = next_view.frame;
        frame.origin.y = view_position;
        frame.size.height = view_height;
        next_view.frame = frame;
        
        frame = self.tableView.frame;
        frame.size.height = self.view.frame.size.height - view_height;
        self.tableView.frame = frame;
        
        UILabel *next_but = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, button_height)];
        next_but.text = @"Next";
        [next_but setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
        next_but.textColor = [UIColor bgColor];
        next_but.textAlignment = NSTextAlignmentCenter;
        [next_but setUserInteractionEnabled:NO];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20, ((view_height - button_height) / 2.0), self.view.frame.size.width - 40, button_height)];
        btn.backgroundColor = [UIColor nextColor];
        btn.layer.cornerRadius = 3.0f;
        [btn addSubview:next_but];
        [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        self.next_but_label = next_but;
        [next_view addSubview:btn];
    }
}

- (UIView *) setupHeader {
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((320.0/2.0) - 50, 25, 100, 100)];
    [logo setContentMode:UIViewContentModeCenter];
    logo.image = [UIImage imageNamed:@"checkout.png"];
    
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
    
    [head addSubview:logo];
    
    //    UILabel *text_header = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 25)];
    //    text_header.text = @"Progress";
    //    text_header.textAlignment = NSTextAlignmentCenter;
    //    text_header.font = [UIFont fontWithName:@"DamascusBold" size:18.0f];
    //    text_header.textColor = [UIColor textColor];
    //    [head addSubview:text_header];
    
    return head;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_SIZE;
}

@end
