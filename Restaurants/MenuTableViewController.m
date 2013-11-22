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
#import "DishTableViewCell.h"
#import "CheckoutViewController.h"
#import "DishTableViewController.h"
#import "ButtonCartRow.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController {
    ShoppingCartTableView *shop;
}

-(void) edit:(ButtonCartRow *) dish_button {
    DishTableViewCell *dish_cell = dish_button.parent;
    [dish_cell.dishFooterView.add setTitle:@"Save" forState:UIControlStateNormal];
    dish_cell.editing = YES;
    DishTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"dishEditViewController"];
    [vc preloadDishCell:dish_cell];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    [navigationController pushViewController:vc animated:YES];
    [self.frostedViewController hideMenuViewController];
}

-(void) checkout {
    CheckoutViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"checkoutController"];
    vc.shoppingCart = self.shopping_cart;
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

-(void)setupMenu {
    if([self shopping]){
        shop = [[ShoppingCartTableView alloc] init];
        shop.frame = self.tableView.frame;
        shop.tableViewController = self.tableView;
        shop.shopping_cart = self.shopping_cart;
        self.tableView.delegate = shop;
        self.tableView.dataSource = shop;
        CheckoutView *checkoutView = [[CheckoutView alloc] init];
        float tot = 0.0f;
        for(DishTableViewCell *dish_cell in self.shopping_cart){
            tot += dish_cell.getPrice;
            [dish_cell.shoppingCartCell.edit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
        }
        checkoutView.total_cost.text = [NSString stringWithFormat:@"%.02f",tot];
        [checkoutView.checkout addTarget:self action:@selector(checkout) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableFooterView = checkoutView;
    } else {
        self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"Sign In";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    

        [label setUserInteractionEnabled:NO];
        [imageView setUserInteractionEnabled:NO];
        
        UIButton *signin = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        
        [signin addSubview:imageView];
        [signin addSubview:label];
        [signin addTarget:self action:@selector(signin) forControlEvents:UIControlEventTouchUpInside];
        
        signin;
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Previous Orders";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        DEMOHomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
//        navigationController.viewControllers = @[homeViewController];
//    } else {
//        DEMOSecondViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondController"];
//        navigationController.viewControllers = @[secondViewController];
//    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Restaurants", @"Profile", @"Settings"];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSArray *titles = @[@"Sauves", @"Carambola", @"Vivary"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

-(void) viewDidAppear:(BOOL)animated {
    if(self.tableView.tableFooterView){
        float tot = 0.0;
        for(DishTableViewCell *dish_cell in self.shopping_cart){
            tot += dish_cell.getPrice;
            [dish_cell.shoppingCartCell.edit addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
        }
        ((CheckoutView *)self.tableView.tableFooterView).total_cost.text = [NSString stringWithFormat:@"%.02f",tot];
    }
}

@end
