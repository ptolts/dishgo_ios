//
//  DishTableViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 11/19/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "DishTableViewController.h"
#import "Dishes.h"
#import "DishTableViewCell.h"
#import "OptionsView.h"
#import "REFrostedViewController.h"
#import "MenuTableViewController.h"
#import "SectionDishViewCell.h"

@interface DishTableViewController ()

@end

@implementation DishTableViewController {
    Dishes *dish;
    DishTableViewCell *dish_logic;
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.cart setTitle:[NSString stringWithFormat:@"%d", [self.shoppingCart count]] forState:UIControlStateNormal];
    [self.cart addTarget:self action:@selector(cartClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupViews];
}


-(void) setupViews{
    dish = self.dish;
    dish_logic = [[[NSBundle mainBundle] loadNibNamed:@"DishTableViewCell" owner:self options:nil] objectAtIndex:0];
    [dish_logic.priceLabel.layer setCornerRadius:5.0f];
    dish_logic.dish = dish;
    dish_logic.dishTitle.text = dish.name;
    dish_logic.parent = self;
    [dish_logic setupLowerHalf];
    
    int junkHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGRect frame = dish_logic.dishFooterView.frame;
    frame.origin.y = junkHeight - frame.size.height;
    dish_logic.dishFooterView.frame = frame;

    
    CGRect make = CGRectMake(0, (dish_logic.frame.origin.y + dish_logic.frame.size.height), 320, junkHeight - dish_logic.dishFooterView.frame.size.height - dish_logic.frame.size.height);
    
    self.tableView = [[UITableView alloc] initWithFrame:make style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    

    [self.view addSubview: dish_logic.dishFooterView];
    [self.view addSubview: dish_logic];
    
//    NSLog(@"%@",CGRectCreateDictionaryRepresentation([dish_logic dishFooterView].frame));
//    NSLog(@"%@",[dish_logic dishFooterView].class);
//    NSLog(@"%@",CGRectCreateDictionaryRepresentation(self.tableView.frame));
//    NSLog(@"frame %@",CGRectCreateDictionaryRepresentation(self.view.frame));
//    NSLog(@"frame b %@",CGRectCreateDictionaryRepresentation(self.view.bounds));
//    NSLog(@"%@",CGRectCreateDictionaryRepresentation(dish_logic.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (!dish_logic){
//        [self setupViews];
//    }
//    return dish_logic;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (!dish_logic){
//        [self setupViews];
//    }
//    return dish_logic.frame.size.height;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!dish_logic){
        [self setupViews];
    }
    return dish_logic.lower_half;
}

-(void)addDish:(DishTableViewCell *)dish_cell
{
    NSLog(@"-- Adding dish. Total dishes: %lu",(unsigned long)[self.shoppingCart count]);
    [self.shoppingCart addObject:dish_cell];
    [self.cart setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)[self.shoppingCart count]] forState:UIControlStateNormal];
    NSLog(@"-- Added dish. Total dishes: %lu",(unsigned long)[self.shoppingCart count]);
}

- (void)cartClick:sender
{
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping = YES;
    ((MenuTableViewController *)(self.frostedViewController.menuViewController)).shopping_cart = self.shoppingCart;
    [((MenuTableViewController *)(self.frostedViewController.menuViewController)) setupMenu];
    self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
    [self.frostedViewController presentMenuViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!dish_logic){
        [self setupViews];
    }
    return dish_logic.lower_half.full_height;
}



@end