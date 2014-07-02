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
#import "SortView.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController {
    ShoppingCartTableView *shop;
    UIColor *mainColor;
    NSMutableArray *options;
    UIColor *sign_in_color;
    CheckoutView *checkoutView;
}

@synthesize sort_by;
@synthesize isOpened;

-(void) edit:(UIGestureRecognizer *) recognizer {
    ButtonCartRow *dish_button = (ButtonCartRow *) recognizer.view;
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

-(void) remove:(UIGestureRecognizer *) recognizer {
    ButtonCartRow *dish_button = (ButtonCartRow *) recognizer.view;
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
    [[((UINavigationController *)self.frostedViewController.contentViewController) topViewController] viewDidAppear:NO];
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
        shop.phone = self.restaurant.phone;
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
            tot += dish_cell.getCurrentPrice;
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(edit:)];
            singleTap.numberOfTapsRequired = 1;
            dish_cell.shoppingCartCell.edit.userInteractionEnabled = YES;
            [dish_cell.shoppingCartCell.edit addGestureRecognizer:singleTap];
            
            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove:)];
            singleTap2.numberOfTapsRequired = 1;
            dish_cell.shoppingCartCell.remove.userInteractionEnabled = YES;
            [dish_cell.shoppingCartCell.remove addGestureRecognizer:singleTap2];
            
        }
        checkoutView.total_cost.text = [NSString stringWithFormat:@"%.02f",tot];
        // call checkout for ordering. been dsiabled a while until we support it
//        [checkoutView.checkout addTarget:self action:@selector(checkout) forControlEvents:UIControlEventTouchUpInside];

// THIS BELOW ALLOWS THEM TO CLICK ORDER
//        if([self.shopping_cart count] == 0) {
//            checkoutView.checkout.enabled = NO;
//        } else {
//            checkoutView.checkout.enabled = YES;
//        }
        
        if(self.restaurant.phone.length > 0){
            [checkoutView.checkout setTitle:@"Call" forState:UIControlStateNormal];
            [checkoutView.checkout addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
        } else {
            checkoutView.checkout.enabled = NO;
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

-(void) call {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.restaurant.phone]]];
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
        head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
        logo.image = [UIImage imageNamed:@"logo.png"];
    }
    
    return head;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.KVOController = KVOController;
    mainColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.85];
    options = [[NSMutableArray alloc] init];
    NSArray *options_text = @[@[@"Opened",@0,@0],@[@"Distance",@1,@0],@[@"Delivery",@2,@0],@[@"Menu Score",@1,@1]];
    for(NSArray *ar in options_text){
        SortView *hold = [[SortView alloc] init];
        [hold setupView:ar[0] type:[ar[1] intValue] value:[ar[2] intValue]];
        [self.KVOController observe:hold keyPath:@"selected" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(MenuTableViewController *observe, SortView *object, NSDictionary *change) {
            if(object.option_type == 1){
                self.sort_by = [NSNumber numberWithInt:object.value];
            }
            if(object.option_type == 0){
                self.isOpened = (BOOL) object.selected;
            }
            if(object.option_type == 2){
                self.doesDelivery = (BOOL) object.selected;
            }
            for(SortView *sortview in options){
                if(sortview == object || sortview.option_type != object.option_type){
                    continue;
                }
                [sortview setSelectedWithoutKvo];
            }
        }];
        [options addObject:hold];
    }
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
    
    return 75;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 75)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 280, 25)];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string = @"Filter Restaurants";
    label.textColor = sign_in_color;
    [label setText:string];
    [view addSubview:label];
//    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            if([[UserSession sharedManager] logged_in]){
                [self profile];
            } else {
                [self signin];
            }
        } else if (indexPath.row == 1){
            [self logout];
        } else if (indexPath.row == 2){
            [self favorites];
        } else if (indexPath.row == 3){
            [self settings];
        }
    } else {
        return;
    }
}

#pragma mark -
#pragma mark UITableView Datasource



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if(sectionIndex == 0){
        if([[UserSession sharedManager] logged_in]){
            return 2;
            return 4;
        } else {
            return 1;
            return 3;
        }
    } else {
        return 4;
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
    
    if(indexPath.section == 0){
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
        } else {
            
            NSArray *titles = @[@"Logout",@"Favorites",@"Settings"];
            
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
    } else {
        SortView *hold = [options objectAtIndex:indexPath.row];
        CGRect frame = cell.frame;
        hold.frame = frame;
        [cell addSubview:hold];
    }
    
    [cell wobble];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void) updatePrice {
    float tot = 0.0;
    for(DishTableViewCell *dish_cell in self.shopping_cart){
        tot += dish_cell.getCurrentPrice;
//        [dish_cell.shoppingCartCell.edit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(edit:)];
        singleTap.numberOfTapsRequired = 1;
        dish_cell.shoppingCartCell.edit.userInteractionEnabled = YES;
        [dish_cell.shoppingCartCell.edit addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove:)];
        singleTap2.numberOfTapsRequired = 1;
        dish_cell.shoppingCartCell.remove.userInteractionEnabled = YES;
        [dish_cell.shoppingCartCell.remove addGestureRecognizer:singleTap2];
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
