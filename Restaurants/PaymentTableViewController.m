//
//  PaymentTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 12/12/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "PaymentTableViewController.h"
#import "PaymentTableViewCell.h"

#define CELL_SIZE 800

@interface PaymentTableViewController ()

@end

@implementation PaymentTableViewController

@synthesize main_user;
@synthesize bill_user;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self setupBackButtonAndCart];
    
    UIImage *img = [UIImage imageNamed:@"background_signup.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    [imageView setFrame:self.tableView.frame];
    imageView.contentMode = UIViewContentModeScaleToFill;
    self.tableView.backgroundView = imageView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = [UIColor bgColor];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    
}

- (void) setupBackButtonAndCart {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]; // <-- Use your own image
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
    [backBtn setImage:backBtnImage];
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
    //                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    //                                       target:nil action:nil];
    //    negativeSpacer.width = -16;// it was -6 in iOS 6
    //    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, backBtn, nil] animated:NO];
    //	self.navigationItem.leftBarButtonItem = backBtn;
    [self.navigationItem setLeftBarButtonItem:backBtn];
    // FOOD CLOUD TITLE
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Freestyle Script Bold" size:30.0f]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"Payment Method";
    self.navigationItem.titleView = label;
}

-(void) myCustomBack {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"paymentCell";
    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.controller = self;
    cell.main_user = main_user;
    cell.bill_user = bill_user;
    [cell setup];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_SIZE;
}



@end
