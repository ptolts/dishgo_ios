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
#import "UIColor+Custom.h"
#import "SectionDishViewCell.h"


@interface DishTableViewController ()

@end

@implementation DishTableViewController {
    Dishes *dish;
    DishTableViewCell *dish_logic;
    bool editing;
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void) preloadDishCell:(DishTableViewCell *) d{
    dish_logic = d;
    dish_logic.parent = self;
    dish = dish_logic.dish;
    editing = YES;
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
    
    
    CartButton *cartButton = [[CartButton alloc] init];
    [cartButton.button addTarget:self action:@selector(cartClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:cartButton.button];
    //    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, customItem, nil] animated:NO];
    [self.navigationItem setRightBarButtonItem:customItem];
    //    self.navigationItem.rightBarButtonItem = customItem;
    self.cart = cartButton;
}

-(void) myCustomBack {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    self.view.autoresizingMask = UIViewAutoresizingNone;
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupViews];

    [self setupBackButtonAndCart];    
    
    self.tableView.backgroundColor = [UIColor bgColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    int tots = 0;
    for(DishTableViewCell *d in self.shoppingCart){
        tots += (int) d.dishFooterView.stepper.value;
    }
    [self.cart setCount:[NSString stringWithFormat:@"%d", tots]];
}

-(void) setupViews{
    
    int junkHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    // IF THE VIEW ISNT EDITING FROM THE CART, WE NEED TO BUILD ALL THE VIEWS;
    if(dish_logic == nil) {
        dish = self.dish;
        dish_logic = [[[NSBundle mainBundle] loadNibNamed:@"DishTableViewCell" owner:self options:nil] objectAtIndex:0];
        [dish_logic.priceLabel.layer setCornerRadius:5.0f];
        dish_logic.dish = dish;
        dish_logic.dishTitle.text = dish.name;
        dish_logic.parent = self;
        dish_logic.priceLabel.backgroundColor = [UIColor bgColor];
        [dish_logic setupLowerHalf];
    }
    
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
    NSLog(@"SC Count Before: %d",[self.shoppingCart count]);
    [self.shoppingCart addObject:dish_cell];
    NSLog(@"SC Count After: %d",[self.shoppingCart count]);    
    [self.cart setCount:[NSString stringWithFormat:@"%lu", (unsigned long)[self.shoppingCart count]]];
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
