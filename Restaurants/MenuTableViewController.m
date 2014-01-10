//
//  MenuTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 10/28/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "MenuTableViewController.h"
#import "REFrostedViewController.h"
#import "ShoppingCartTableView.h"
#import "CheckoutView.h"
#import "CheckoutViewController.h"
#import "DishTableViewCell.h"
#import "DishTableViewController.h"
#import "ButtonCartRow.h"
#import "UserSession.h"
#import "UIColor+Custom.h"
#import "ProfileViewController.h"
#import <ALAlertBanner/ALAlertBanner.h>
#import "WobbleCell.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController {
    ShoppingCartTableView *shop;
    UIColor *mainColor;
    UIColor *sign_in_color;
    CheckoutView *checkoutView;
}

-(void) edit:(ButtonCartRow *) dish_button {
    DishTableViewCell *dish_cell = dish_button.parent;
    [dish_cell.dishFooterView.add setTitle:@"Save" forState:UIControlStateNormal];
    dish_cell.editing = YES;
    DishTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"dishEditViewController"];
    vc.shoppingCart = self.shopping_cart;
    [vc preloadDishCell:dish_cell];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    [navigationController pushViewController:vc animated:YES];
    [self.frostedViewController hideMenuViewController];
}

-(void) remove:(ButtonCartRow *) dish_button {
    DishTableViewCell *dish_cell = dish_button.parent;
    [self.shopping_cart removeObject:dish_cell];
    [UIView transitionWithView: self.tableView
                      duration: 0.35f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
         [self.tableView reloadData];
     }
                    completion: ^(BOOL isFinished)
     {

     }];
    [self updatePrice];
//    [[((UINavigationController *)self.frostedViewController.contentViewController) topViewController] viewDidAppear:NO];
}

-(void) checkout {
    CheckoutViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"checkoutTableViewController"];
    vc.shoppingCart = self.shopping_cart;
    vc.restaurant = self.restaurant;
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    [navigationController pushViewController:vc animated:YES];
    [self.frostedViewController hideMenuViewController];
}

-(void) signin {
    NSLog(@"Clicked Signin");
    CheckoutViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    [navigationController pushViewController:vc animated:YES];
    [self.frostedViewController hideMenuViewController];
}

-(void) profile {
    NSLog(@"Clicked Profile");
    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    [navigationController pushViewController:vc animated:YES];
    [self.frostedViewController hideMenuViewController];
}

-(void) favorites {
    NSLog(@"Clicked Signin");
    CheckoutViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    [navigationController pushViewController:vc animated:YES];
    [self.frostedViewController hideMenuViewController];
}

-(void) settings {
    NSLog(@"Clicked Signin");
    CheckoutViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signinController"];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    [navigationController pushViewController:vc animated:YES];
    [self.frostedViewController hideMenuViewController];
}

-(void) logout {
    [[UserSession sharedManager] logout];
    [self launchAlert:@"Logged out!"];
    [self.frostedViewController hideMenuViewController];
}

- (void)launchAlert:(NSString *)msg
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.frostedViewController.contentViewController.view
                                                        style:ALAlertBannerStyleNotify
                                                     position:ALAlertBannerPositionBottom
                                                        title:@"Success!"
                                                     subtitle:msg];
    
    banner.secondsToShow = 1.5f;
    
    [banner show];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupMenu];
}

-(void)setupMenu {
    
    NSLog(@"Loop?");
    
//    self.tableView = nil;
//    self.tableView = [[UITableView alloc] init];
//    self.tableView.tableHeaderView = nil;
//    self.tableView.tableFooterView = nil;
//    
//    [self.checkout_view removeFromSuperview];    
    
    CGRect frame = self.tableView.frame;
    frame.size.height = self.view.frame.size.height;
    frame.size.width = self.view.frame.size.width;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.tableView.frame = frame;
    
    frame = self.checkout_view.frame;
    frame.size.height = 0;
    frame.origin.y = self.view.frame.size.height;
    self.checkout_view.frame = frame;
    
    if([self shopping]){
        shop = [[ShoppingCartTableView alloc] init];
        shop.junk = 0;
        shop.frame = self.tableView.frame;
        shop.tableViewController = self.tableView;
        shop.shopping_cart = self.shopping_cart;
        self.tableView.delegate = shop;
        self.tableView.dataSource = shop;
        checkoutView = [[CheckoutView alloc] init];
        checkoutView.checkout.backgroundColor = [UIColor nextColor];
        float tot = 0.0f;
        for(DishTableViewCell *dish_cell in self.shopping_cart){
            tot += dish_cell.getPrice;
            [dish_cell.shoppingCartCell.edit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
            [dish_cell.shoppingCartCell.remove addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        }
        checkoutView.total_cost.text = [NSString stringWithFormat:@"%.02f",tot];
        [checkoutView.checkout addTarget:self action:@selector(checkout) forControlEvents:UIControlEventTouchUpInside];
        if([self.shopping_cart count] == 0) {
            checkoutView.checkout.enabled = NO;
        } else {
            checkoutView.checkout.enabled = YES;
        }
        
        int total_height = self.view.frame.size.height;
        int view_height = checkoutView.frame.size.height;
        int view_position = total_height - view_height;
        
        CGRect frame = checkoutView.frame;
        frame.origin.y = view_position;
//        frame.size.height = view_height;
        checkoutView.frame = frame;
        
        frame = self.tableView.frame;
        frame.size.height = self.view.frame.size.height - view_height;
        self.tableView.frame = frame;
        
        self.checkout_view = checkoutView;
        [self.view addSubview:self.checkout_view];
        
//        self.tableView.tableFooterView = checkoutView;
        self.tableView.opaque = NO;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.backgroundColor = [UIColor clearColor];
        sign_in_color = [UIColor almostBlackColor];
        self.tableView.tableHeaderView = [self setupHeader];
        
    } else {
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.opaque = NO;
        self.tableView.backgroundColor = mainColor;
        sign_in_color = [UIColor whiteColor];
        self.tableView.tableHeaderView = [self setupHeader];
    }
}

- (UIView *) setupHeader {
    
//    int header_size = 30;
//    int offset = 120;
    int logo_size = 60;
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, logo_size, logo_size)];
    logo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [logo setContentMode:UIViewContentModeCenter];
    UIView *head;
    
    if(self.shopping){
        head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
        logo.image = [UIImage imageNamed:@"large_cart.png"];
//        logo.layer.cornerRadius = logo_size / 2.0;
        logo.layer.borderColor = [UIColor almostBlackColor].CGColor;
        logo.layer.borderWidth = 2.5f;
//        [head addSubview:logo];
    } else {
        head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 145)];
        logo.image = [UIImage imageNamed:@"logo.png"];
    }
    
    return head;

    
//    if([[UserSession sharedManager] logged_in]){
//        
//        UIImageView *imageView = [[UserSession sharedManager] profilePic:_shopping color:sign_in_color offset:offset];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, offset + 59, 60, 20)];
//        label.text = @"Logout";
//        label.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
//        label.textColor = sign_in_color;
//        
//        label.textAlignment = NSTextAlignmentCenter;
////        [label sizeToFit];
////
////        CGRect frame = label.frame;
////        frame.size.height = frame.size.height + 6;
////        frame.size.width = frame.size.width + 16;
////        label.frame = frame;
//        
////        label.layer.cornerRadius = 5.0f;
//        label.layer.borderColor = sign_in_color.CGColor;
//        label.layer.borderWidth = 1.0f;
//        
//        if(self.shopping){
//            CGRect frame = label.frame;
//            frame.origin.x = 220;
//            label.frame = frame;
//        } else {
//            CGRect frame = label.frame;
//            frame.origin.x = -1;
//            label.frame = frame;
//        }
////        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        
//        
//        [label setUserInteractionEnabled:NO];
//        [imageView setUserInteractionEnabled:NO];
//        
//        UIButton *signin = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
//        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, 280.0f, 1.0f)];
//        lineView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.9f];
//
//        
//        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, offset + header_size - 1, 280.0f, 1.0f)];
//        lineView2.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.9f];
//
//        [signin addSubview:logo];
//        [signin addSubview:lineView];
//        [signin addSubview:lineView2];
//        [signin addSubview:imageView];
//        [signin addSubview:label];
//        [signin addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
//        
//        return signin;
//    } else {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, header_size, header_size)];
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        [imageView setContentMode:UIViewContentModeCenter];
//        if(self.shopping){
//                    imageView.image = [UIImage imageNamed:@"avatar_black.png"];
//        } else {
//                    imageView.image = [UIImage imageNamed:@"avatar_white.png"];
//        }
//        imageView.layer.masksToBounds = YES;
//        imageView.layer.cornerRadius = [[NSNumber numberWithInt:header_size] floatValue] / 2.0;
//        imageView.layer.borderColor = sign_in_color.CGColor;
//        imageView.layer.borderWidth = 3.0f;
//        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        imageView.layer.shouldRasterize = YES;
//        imageView.clipsToBounds = YES;
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 99, 0, 24)];
//        label.text = @"Sign In";
//        label.textColor = sign_in_color;
//        label.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
////        label.backgroundColor = [UIColor clearColor];
//        label.layer.cornerRadius = 5.0f;
//        label.textAlignment = NSTextAlignmentCenter;        
//        [label sizeToFit];
//        
//        CGRect frame = label.frame;
//        frame.size.height = frame.size.height + 6;
//        frame.size.width = frame.size.width + 16;
//        label.frame = frame;
//        
////        label.layer.cornerRadius = 5.0f;
//        label.layer.borderColor = sign_in_color.CGColor;
//        label.layer.borderWidth = 1.0f;
//
////        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        if(self.shopping){
//            CGRect frame = label.frame;
//            frame.origin.x = 220;
//            label.frame = frame;
//        } else {
//            CGRect frame = label.frame;
//            frame.origin.x = -1;
//            label.frame = frame;
//        }
//        
//        
//        [label setUserInteractionEnabled:NO];
//        [imageView setUserInteractionEnabled:NO];
//        
//        UIButton *signin = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
//        
//        [signin addSubview:logo];
//        [signin addSubview:imageView];
//        [signin addSubview:label];
//        [signin addTarget:self action:@selector(signin) forControlEvents:UIControlEventTouchUpInside];
//        
//        return signin;
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.85];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        if([[UserSession sharedManager] logged_in]){
            [self profile];
        } else {
            [self signin];
        }
    } else if (indexPath.row == 1){
        [self settings];
    } else if (indexPath.row == 2){
        [self favorites];
    } else if (indexPath.row == 3){
        [self logout];
    }
}

#pragma mark -
#pragma mark UITableView Datasource



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if([[UserSession sharedManager] logged_in]){
        return 4;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    WobbleCell *cell = [[WobbleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    CGRect fr = cell.frame;
    fr.size.width = self.tableView.frame.size.width;
    cell.frame = fr;

    int icon_size = 40;
    int start_point = 50;
    
    if (indexPath.row == 0){
        if([[UserSession sharedManager] logged_in]){
            
            UIImageView *imageView = [[UserSession sharedManager] profilePic:self.shopping color:sign_in_color rect:CGRectMake(start_point, 5, icon_size, icon_size)];
            if(imageView.frame.size.width == 0.0){
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(start_point, 5, icon_size, icon_size)];
                [imageView setContentMode:UIViewContentModeCenter];
                imageView.image = [UIImage imageNamed:@"avatar_logged_white.png"];
            }
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = icon_size / 2.0;
            imageView.layer.borderColor = sign_in_color.CGColor;
            imageView.layer.borderWidth = 1.5f;
            imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
            imageView.layer.shouldRasterize = YES;
            imageView.clipsToBounds = YES;

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon_size + 20 + start_point, (icon_size / 2.0) - 5, 100, 20)];
            label.text = @"Profile";
            label.textColor = sign_in_color;
            label.font = [UIFont fontWithName:@"GurmukhiMN-Bold" size:16.0f];
            label.layer.cornerRadius = 5.0f;
            label.textAlignment = NSTextAlignmentLeft;
            
            UIView *hold = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width + label.frame.size.width, cell.frame.size.height)];
            [hold addSubview:imageView];
            [hold addSubview:label];
            
            CGRect frame = hold.frame;
            frame.origin.x = 10.0;
            hold.frame = frame;
            
            [cell addSubview:hold];
            
        } else {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(start_point, 5, icon_size, icon_size)];
            [imageView setContentMode:UIViewContentModeCenter];
            imageView.image = [UIImage imageNamed:@"avatar_white.png"];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = icon_size / 2.0;
            imageView.layer.borderColor = sign_in_color.CGColor;
            imageView.layer.borderWidth = 1.5f;
            imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
            imageView.layer.shouldRasterize = YES;
            imageView.clipsToBounds = YES;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon_size + 20 + start_point, (icon_size / 2.0) - 5, 100, 20)];
            label.text = @"Sign In";
            label.textColor = sign_in_color;
            label.font = [UIFont fontWithName:@"GurmukhiMN-Bold" size:16.0f];
            label.layer.cornerRadius = 5.0f;
            label.textAlignment = NSTextAlignmentLeft;
            
            UIView *hold = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width + label.frame.size.width, cell.frame.size.height)];
            [hold addSubview:imageView];
            [hold addSubview:label];
            
            CGRect frame = hold.frame;
            frame.origin.x = 10.0;
            hold.frame = frame;
            
            [cell addSubview:hold];
        }
    } else if (indexPath.section == 0) {
        
        NSArray *titles = @[@"Settings",@"Favorites",@"Logout"];
        
        NSString *title = titles[indexPath.row - 1];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(start_point, 5, icon_size, icon_size)];
        [imageView setContentMode:UIViewContentModeCenter];
        imageView.image = [UIImage imageNamed:[[NSString stringWithFormat:@"%@.png",title] lowercaseString]];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = icon_size / 2.0;
        imageView.layer.borderColor = sign_in_color.CGColor;
        imageView.layer.borderWidth = 1.5f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(icon_size + 20 + start_point, (icon_size / 2.0) - 5, 100, 20)];
        label.text = title;
        label.textColor = sign_in_color;
        label.font = [UIFont fontWithName:@"GurmukhiMN-Bold" size:16.0f];
        label.layer.cornerRadius = 5.0f;
        label.textAlignment = NSTextAlignmentLeft;
        
        UIView *hold = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width + label.frame.size.width, cell.frame.size.height)];
        [hold addSubview:imageView];
        [hold addSubview:label];
        
        CGRect frame = hold.frame;
        frame.origin.x = 10.0;
        hold.frame = frame;
        
        [cell addSubview:hold];
    }
    
//    if(indexPath.row >= 2){
        [cell wobble];
//    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void) updatePrice {
    float tot = 0.0;
    for(DishTableViewCell *dish_cell in self.shopping_cart){
        tot += dish_cell.getPrice;
        [dish_cell.shoppingCartCell.edit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    }
    checkoutView.total_cost.text = [NSString stringWithFormat:@"%.02f",tot];
}

-(void) viewDidAppear:(BOOL)animated {
    [self.shopping_cart saveShoppingCart];
    if(self.tableView.tableFooterView){
        [self updatePrice];
    }
    [self.tableView reloadData];
}

@end
