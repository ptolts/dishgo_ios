//
//  ReviewTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 12/18/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "ReviewViewController.h"
#import "ShoppingCartTableView.h"
#import <ALAlertBanner/ALAlertBanner.h>
#import "DishTableViewCell.h"

#define DEFAULT_SIZE 43
#define LARGE_SIZE 86

@interface ReviewViewController ()

@end

@implementation ReviewViewController

    NSMutableDictionary *heights;
//    ShoppingCartTableView *shop;
    @synthesize main_user;
    @synthesize next_view;

-(void) myCustomBack {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) setupBackButtonAndCart {
	self.navigationItem.hidesBackButton = YES; // Important
    UIImage *backBtnImage = [UIImage imageNamed:@"back.png"]; // <-- Use your own image
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
    label.text = @"Review Order";
    self.navigationItem.titleView = label;
}

- (void) next {
    main_user.review_confirm = YES;
    [self.navigationController popViewControllerAnimated:YES];
    [self launchAlert:@"Order Review Confirmed!"];
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
    label.text = @"Review Order";
    self.navigationItem.titleView = label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackButton];
    [self setupHeight];
//    shop = [[ShoppingCartTableView alloc] init];
//    shop.junk = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
//    shop.frame = self.tableView.frame;
//    shop.tableViewController = self.tableView;
//    shop.shopping_cart = self.shopping_cart;
//    self.tableView.delegate = shop;
//    self.tableView.dataSource = shop;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CGRect frame = self.tableView.frame;
    frame.origin.x = (self.view.frame.size.width - ((DishTableViewCell *)[self.shopping_cart firstObject]).shoppingCartCell.frame.size.width) / 2;
    self.tableView.frame = frame;
    
    self.tableView.backgroundColor = [UIColor bgColor];
    self.view.backgroundColor = [UIColor bgColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self setupHeader];
    self.tableView.tableFooterView = [self setupFooter];
    [self.tableView reloadData];
    
}

- (UIView *) setupFooter {
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
//    UILabel *next_but = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 35)];
//    next_but.text = @"Next";
//    [next_but setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
//    next_but.textColor = [UIColor bgColor];
//    next_but.textAlignment = NSTextAlignmentCenter;
//    [next_but setUserInteractionEnabled:NO];
//    next_but.layer.cornerRadius = 3.0f;
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, 35)];
//    btn.backgroundColor = [UIColor nextColor];
//    //    btn.layer.borderColor = [UIColor blackColor].CGColor;
//    //    btn.layer.borderWidth = 1.0f;
////    self.next_but = btn;
//    [btn addSubview:next_but];
//    
//    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
//    
//    [footer addSubview:btn];
//    
//    //    footer.layer.borderColor = [UIColor blackColor].CGColor;
//    //    footer.layer.borderWidth = 1.0f;
    
    return footer;
    
}

- (UIView *) setupHeader {
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((320.0/2.0) - 50, 25, 100, 100)];
    [logo setContentMode:UIViewContentModeScaleToFill];
    logo.image = [UIImage imageNamed:@"logo_black.png"];
    
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
//    [head addSubview:logo];
    
    //    UILabel *text_header = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 25)];
    //    text_header.text = @"Progress";
    //    text_header.textAlignment = NSTextAlignmentCenter;
    //    text_header.font = [UIFont fontWithName:@"DamascusBold" size:18.0f];
    //    text_header.textColor = [UIColor textColor];
    //    [head addSubview:text_header];
    
    return head;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [next_view addSubview:btn];
    }
}

-(void) setupHeight {
    heights = [[NSMutableDictionary alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (heights == nil){
        NSLog(@"Setting up height dict");
        [self setupHeight];
    }
    
    [self.tableView beginUpdates];
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    if([[heights valueForKey:key] integerValue] == DEFAULT_SIZE){
        //        DishTableViewCell *c = (DishTableViewCell *)[self cellForRowAtIndexPath:indexPath];
        int size = LARGE_SIZE;
        for(id kkey in [heights allKeys]) {
            [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:kkey];
        }
        [heights setObject:[NSNumber numberWithInteger:size] forKey:key];
    } else {
        [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:key];
    }
    [self.tableView endUpdates];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"HIEGHT FOR ROW: %ld",(long)indexPath.row);
    
//    if([self.shopping_cart count] == 0){
//        return self.tableViewController.frame.size.height - self.tableViewController.tableHeaderView.frame.size.height - self.tableViewController.tableFooterView.frame.size.height;
//    }
//    
//    if([self.shopping_cart count] == (int)indexPath.row){
//        NSLog(@"it equals count");
//        if (heights == nil){
//            [self setupHeight];
//        }
//        int height = self.tableViewController.frame.size.height - self.tableViewController.tableHeaderView.frame.size.height - self.tableViewController.tableFooterView.frame.size.height;
//        for(id val in heights){
//            //            NSLog(@"height: %d",[((NSNumber *)[heights objectForKey:val]) intValue]);
//            height -= [((NSNumber *)[heights objectForKey:val]) intValue];
//        }
//        if(height < 0){
//            height = 0;
//        }
//        NSLog(@"RETURNING SPACER CELL OF HEIGHT: %d", height);
//        return height;
//    }
    
//    NSLog(@"DIDNT RETURN SPACER CELL");
    
    if (heights == nil){
        NSLog(@"Setting up height dict");
        [self setupHeight];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    if([heights valueForKey:key]){
        NSLog(@"%f",[[heights valueForKey:key] doubleValue]);
        return [[heights valueForKey:key] doubleValue];
    } else {
        [heights setObject:[NSNumber numberWithInteger:DEFAULT_SIZE] forKey:key];
        return DEFAULT_SIZE;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.shopping_cart count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc] init];
    DishTableViewCell *dish_view = [self.shopping_cart objectAtIndex:indexPath.row];
//    UIView *offset_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dish_view.shoppingCartCell.frame.size.width, dish_view.shoppingCartCell.frame.size.height)];
//
//    CGRect frame = dish_view.shoppingCartCell.frame;
//    frame.origin.y = 0;
//    dish_view.shoppingCartCell.frame = frame;
//    
//    [offset_view addSubview:dish_view.shoppingCartCell];
//    
//    frame = offset_view.frame;
//    frame.size.width = self.view.frame.size.width;
//    cell.frame = frame;
//    
//    frame = offset_view.frame;
//    frame.origin.x = (cell.frame.size.width - offset_view.frame.size.width) / 2;
//    offset_view.frame = frame;
//    
//    [cell addSubview:offset_view];
//    
//    NSLog(@"Cell Frame: %@\nOffsetViewFrame: %@\nDishCellTableViewFrame: %@\n",CGRectCreateDictionaryRepresentation(cell.frame),CGRectCreateDictionaryRepresentation(offset_view.frame),CGRectCreateDictionaryRepresentation(dish_view.shoppingCartCell.frame));
    
//    return cell;
//    dish_view.shoppingCartCell.backgroundColor = [UIColor redColor];
    return dish_view.shoppingCartCell;
}


@end
