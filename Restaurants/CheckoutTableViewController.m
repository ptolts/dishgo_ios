//
//  CheckoutTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 12/9/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "CheckoutTableViewController.h"
#import "UIColor+Custom.h"
#import "UserSession.h"
#import "CheckoutCell.h"
#import "AddressForDeliveryViewController.h"
#import "SignInViewController.h"
#import "PaymentTableViewController.h"

#define CELL_SIZE 34

@interface CheckoutTableViewController ()

@end

@implementation CheckoutTableViewController
    NSMutableDictionary *progress;
    NSDictionary *titles;
    NSArray *keys;
    User *user_for_order;
    User *user_for_billing;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setupBackButtonAndCart {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]; // <-- Use your own image
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
    [backBtn setImage:backBtnImage];
    [self.navigationItem setLeftBarButtonItem:backBtn];
}

-(void) myCustomBack {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) viewDidAppear:(BOOL)animated {
    
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
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackButtonAndCart];
    
    user_for_order = [[User alloc] init];
    user_for_order.confirm_address = NO;
    
    user_for_billing = [[User alloc] init];
    user_for_billing.confirm_billing = NO;
    
    keys = @[@"login",@"address",@"payment",@"review",@"order"];
    
    progress = [[NSMutableDictionary alloc] init];
    titles = [[NSDictionary alloc] initWithObjectsAndKeys:@"Login",@"login",@"Delivery Address",@"address",@"Payment Details",@"payment",@"Review Order",@"review",@"Place Order",@"order",nil];
    
    self.tableView.backgroundColor = [UIColor bgColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
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

    NSLog(@"%@",[[progress objectForKey:key] class]);
    

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

-(void) login {
    NSLog(@"Clicked Signin");
    SignInViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) address {
    [self payment];
    return;
    NSLog(@"Clicked Signin");
    AddressForDeliveryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addressViewController"];
    vc.main_user = user_for_order;
    vc.bill_user = user_for_billing;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) payment {
    NSLog(@"Clicked Signin");
    PaymentTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"];
    vc.main_user = user_for_order;
    vc.bill_user = user_for_billing;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) next {
    NSLog(@"next!");
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
                return;
            } else {
                NSLog(@"What!");
                return;
            }
        }
    }
    NSLog(@"Finished!");
}

- (UIView *) setupFooter {
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];

    UILabel *next_but = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 35)];
    next_but.text = @"Next";
    next_but.textColor = [UIColor bgColor];
    next_but.textAlignment = NSTextAlignmentCenter;
    [next_but setUserInteractionEnabled:NO];
    next_but.layer.cornerRadius = 3.0f;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(220, 40, 75, 35)];
    btn.backgroundColor = [UIColor scarletColor];
//    btn.layer.borderColor = [UIColor blackColor].CGColor;
//    btn.layer.borderWidth = 1.0f;
    [btn addSubview:next_but];
    
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    [footer addSubview:btn];
    
//    footer.layer.borderColor = [UIColor blackColor].CGColor;
//    footer.layer.borderWidth = 1.0f;
    
    return footer;
    
}

- (UIView *) setupHeader {
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((320.0/2.0) - 50, 5, 100, 100)];
    [logo setContentMode:UIViewContentModeScaleToFill];
    logo.image = [UIImage imageNamed:@"logo_black.png"];
    
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];

    [head addSubview:logo];
    
    UILabel *text_header = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 25)];
    text_header.text = @"Progress";
    text_header.textAlignment = NSTextAlignmentCenter;
    text_header.font = [UIFont fontWithName:@"DamascusBold" size:18.0f];
    text_header.textColor = [UIColor textColor];
    [head addSubview:text_header];
    
    return head;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_SIZE;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
